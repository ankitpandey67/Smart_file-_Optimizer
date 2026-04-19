#include "duplicatedetector.h"
#include <QFile>
#include <QCryptographicHash>
#include <QMap>
#include <QtConcurrent/QtConcurrent>

DuplicateDetector::DuplicateDetector(QObject *parent)
    : QObject(parent) {}

QByteArray DuplicateDetector::computeHash(const QString &path)
{
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly)) return {};

    QCryptographicHash hasher(QCryptographicHash::Md5);

    // For large files only hash first+last 512KB for speed
    const qint64 chunkSize = 512 * 1024;
    if (file.size() > 2 * chunkSize) {
        QByteArray head = file.read(chunkSize);
        hasher.addData(head);
        file.seek(file.size() - chunkSize);
        QByteArray tail = file.read(chunkSize);
        hasher.addData(tail);
        // Also add file size to reduce false positives
        qint64 sz = file.size();
        hasher.addData(reinterpret_cast<char*>(&sz), sizeof(sz));
    } else {
        hasher.addData(&file);
    }

    return hasher.result();
}

void DuplicateDetector::detect(const QList<FileEntry> &entries)
{
    if (m_running) return;
    m_running  = true;
    m_cancel   = false;
    m_progress = 0;
    m_groups.clear();
    emit runningChanged();

    QtConcurrent::run([this, entries](){
        // Step 1: group by size (quick pre-filter)
        QMap<qint64, QStringList> bySize;
        for (const auto &e : entries)
            if (e.size > 0) bySize[e.size].append(e.path);

        // Collect candidates (size > 1)
        QList<QPair<qint64, QStringList>> candidates;
        for (auto it = bySize.cbegin(); it != bySize.cend(); ++it)
            if (it.value().size() > 1)
                candidates.append({it.key(), it.value()});

        if (candidates.isEmpty()) {
            m_running = false;
            emit runningChanged();
            emit detectionFinished(0, 0);
            return;
        }

        // Step 2: hash candidates
        int total = candidates.size();
        int done  = 0;
        QMap<QByteArray, QStringList> byHash;

        for (const auto &[size, paths] : candidates) {
            if (m_cancel) break;
            for (const auto &p : paths) {
                QByteArray h = computeHash(p);
                if (!h.isEmpty()) byHash[h].append(p);
            }
            ++done;
            m_progress = (done * 100) / total;
            emit progressChanged();
        }

        // Step 3: build groups
        for (auto it = byHash.cbegin(); it != byHash.cend(); ++it) {
            if (it.value().size() < 2) continue;
            DuplicateGroup g;
            g.hash         = it.key();
            g.paths        = it.value();
            g.size         = QFileInfo(g.paths.first()).size();
            g.wastedCount  = g.paths.size() - 1;
            g.wastedBytes  = g.wastedCount * g.size;
            m_groups.append(g);
        }

        // Sort by wasted bytes desc
        std::sort(m_groups.begin(), m_groups.end(),
                  [](const DuplicateGroup &a, const DuplicateGroup &b){
                      return a.wastedBytes > b.wastedBytes;
                  });

        m_running = false;
        emit runningChanged();
        emit detectionFinished(m_groups.size(), totalWastedBytes());
    });
}

void DuplicateDetector::cancel() { m_cancel = true; }

qint64 DuplicateDetector::totalWastedBytes() const
{
    qint64 total = 0;
    for (const auto &g : m_groups) total += g.wastedBytes;
    return total;
}
