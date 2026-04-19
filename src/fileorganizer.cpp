#include "fileorganizer.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QtConcurrent/QtConcurrent>

FileOrganizer::FileOrganizer(QObject *parent)
    : QObject(parent) {}

QString FileOrganizer::buildDestPath(const FileEntry &entry) const
{
    // OutputRoot/Category/filename
    QString root = m_outputRoot.isEmpty()
                   ? QFileInfo(entry.path).absolutePath() + "/.."
                   : m_outputRoot;
    QDir dir;
    QString categoryDir = QDir::cleanPath(root + "/" + entry.category);
    dir.mkpath(categoryDir);
    return categoryDir + "/" + entry.name;
}

bool FileOrganizer::safeMoveFile(const QString &src, const QString &dst, QString &error)
{
    // Handle name collision
    QString target = dst;
    if (QFile::exists(target)) {
        QFileInfo fi(dst);
        int i = 1;
        do {
            target = fi.absolutePath() + "/" +
                     fi.baseName() + QString("_%1.").arg(i++) +
                     fi.suffix();
        } while (QFile::exists(target));
    }

    if (!QFile::rename(src, target)) {
        // Try copy-then-delete as fallback (cross-device)
        if (!QFile::copy(src, target)) {
            error = QString("Cannot move/copy '%1'").arg(QFileInfo(src).fileName());
            return false;
        }
        QFile::remove(src);
    }
    return true;
}

void FileOrganizer::organize(const QList<FileEntry> &entries, bool dryRun)
{
    if (m_running || entries.isEmpty()) return;

    m_running  = true;
    m_progress = 0;
    emit runningChanged();

    QtConcurrent::run([this, entries, dryRun](){
        int moved = 0, skipped = 0, errors = 0;
        int total = entries.size();
        int done  = 0;

        for (const auto &entry : entries) {
            QString dst = buildDestPath(entry);

            // Skip if already in the right place
            if (QFileInfo(entry.path).absolutePath() ==
                QFileInfo(dst).absolutePath()) {
                ++skipped;
                ++done;
                m_progress = (done * 100) / total;
                emit progressChanged();
                continue;
            }

            OrganizerAction action;
            action.source      = entry.path;
            action.destination = dst;
            action.category    = entry.category;

            if (dryRun) {
                action.success = true;
                ++moved;
            } else {
                action.success = safeMoveFile(entry.path, dst, action.errorMsg);
                if (action.success) ++moved; else ++errors;
            }

            m_history.prepend(action); // newest first
            emit actionPerformed(entry.path, dst, dryRun, action.success);

            ++done;
            m_progress = (done * 100) / total;
            emit progressChanged();
        }

        m_running  = false;
        m_progress = 100;
        emit runningChanged();
        emit organizeFinished(moved, skipped, errors);
    });
}

void FileOrganizer::undoLast()
{
    // Find last successful real (non-dry-run) operations
    int restored = 0;
    QList<OrganizerAction> remaining;

    // Undo the most recent batch (up to 500 actions or until success=false)
    for (int i = 0; i < m_history.size(); ++i) {
        const auto &a = m_history[i];
        if (!a.success) continue;
        // Move back: destination -> source
        if (QFile::exists(a.destination)) {
            QString err;
            if (safeMoveFile(a.destination, a.source, err)) {
                ++restored;
                continue; // don't keep in history
            }
        }
        remaining.append(a);
    }

    m_history = remaining;
    emit undoFinished(restored);
}

void FileOrganizer::clearHistory()
{
    m_history.clear();
}
