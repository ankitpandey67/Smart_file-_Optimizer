#include "filescanner.h"
#include <QDirIterator>
#include <QCryptographicHash>
#include <QFuture>
#include <QtConcurrent/QtConcurrent>
#include <QDateTime>

FileScanner::FileScanner(QObject *parent)
    : QObject(parent)
{
    m_categories = defaultCategories();
}

QMap<QString,QString> FileScanner::defaultCategories() const
{
    QMap<QString,QString> cats;
    // Images
    for (auto &ext : {"jpg","jpeg","png","gif","bmp","svg","webp","tiff","ico","heic"})
        cats[ext] = Category::Images;
    // Videos
    for (auto &ext : {"mp4","mkv","avi","mov","wmv","flv","webm","m4v","3gp"})
        cats[ext] = Category::Videos;
    // Documents
    for (auto &ext : {"pdf","docx","doc","txt","odt","xlsx","xls","pptx","ppt","csv","md","rtf"})
        cats[ext] = Category::Documents;
    // Music
    for (auto &ext : {"mp3","wav","flac","aac","ogg","m4a","wma","opus"})
        cats[ext] = Category::Music;
    // Archives
    for (auto &ext : {"zip","rar","7z","tar","gz","bz2","xz","iso"})
        cats[ext] = Category::Archives;
    return cats;
}

void FileScanner::setCustomCategories(const QMap<QString,QString> &cats)
{
    m_categories = cats;
}

QString FileScanner::categorize(const QString &ext) const
{
    return m_categories.value(ext.toLower(), Category::Others);
}

QString FileScanner::humanSize(qint64 bytes)
{
    if (bytes < 1024)         return QString("%1 B").arg(bytes);
    if (bytes < 1024*1024)    return QString("%1 KB").arg(bytes/1024.0, 0, 'f', 1);
    if (bytes < 1024*1024*1024) return QString("%1 MB").arg(bytes/(1024.0*1024), 0, 'f', 2);
    return QString("%1 GB").arg(bytes/(1024.0*1024*1024), 0, 'f', 2);
}

void FileScanner::countFiles(const QString &dir, int &count)
{
    QDirIterator it(dir, QDir::Files | QDir::NoDotAndDotDot,
                    QDirIterator::Subdirectories);
    while (it.hasNext()) { it.next(); ++count; }
}

void FileScanner::startScan(const QString &rootPath)
{
    if (m_scanning) return;

    m_cancel  = false;
    m_entries.clear();
    m_totalFiles = 0;
    m_progress   = 0;

    m_scanning = true;
    emit scanningChanged();

    // Run scan in a background thread
    QFuture<void> future = QtConcurrent::run([this, rootPath](){
        scanWorker(rootPath);
    });
}

void FileScanner::cancelScan()
{
    m_cancel = true;
}

void FileScanner::scanWorker(const QString &rootPath)
{
    // --- Phase 1: Count total files for progress ---
    int total = 0;
    countFiles(rootPath, total);
    m_totalFiles = total;
    emit totalFilesChanged();

    if (total == 0) {
        m_scanning = false;
        emit scanningChanged();
        emit scanFinished(0);
        return;
    }

    // --- Phase 2: Iterate and collect ---
    int scanned = 0;
    QDirIterator it(rootPath,
                    QDir::Files | QDir::NoDotAndDotDot | QDir::Hidden,
                    QDirIterator::Subdirectories);

    while (it.hasNext() && !m_cancel) {
        QString filePath = it.next();
        QFileInfo fi(filePath);

        FileEntry entry;
        entry.path      = filePath;
        entry.name      = fi.fileName();
        entry.extension = fi.suffix().toLower();
        entry.category  = categorize(entry.extension);
        entry.size      = fi.size();
        entry.sizeHuman = humanSize(entry.size);
        entry.modified  = fi.lastModified();

        {
            QMutexLocker lock(&m_mutex);
            m_entries.append(entry);
        }

        ++scanned;
        int pct = (scanned * 100) / total;
        if (pct != m_progress) {
            m_progress = pct;
            emit progressChanged();
        }

        emit fileFound(entry.path, entry.category);
    }

    m_scanning = false;
    emit scanningChanged();

    if (m_cancel) {
        emit scanCancelled();
    } else {
        emit scanFinished(scanned);
    }
}

QMap<QString, QPair<int,qint64>> FileScanner::stats() const
{
    QMap<QString, QPair<int,qint64>> result;
    for (const auto &e : m_entries) {
        auto &p = result[e.category];
        p.first++;
        p.second += e.size;
    }
    return result;
}
