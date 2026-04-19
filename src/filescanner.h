#pragma once
#include <QObject>
#include <QThread>
#include <QDir>
#include <QFileInfo>
#include <QList>
#include <QMap>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QVariantMap>
#include <QMutex>
#include <atomic>

// Represents a single scanned file
struct FileEntry {
    QString path;
    QString name;
    QString extension;
    QString category;
    qint64  size;       // bytes
    QString sizeHuman;
    QDateTime modified;
    QByteArray hash;    // MD5 hash (filled lazily)
};

// Category names
namespace Category {
    inline constexpr char Images[]    = "Images";
    inline constexpr char Videos[]    = "Videos";
    inline constexpr char Documents[] = "Documents";
    inline constexpr char Music[]     = "Music";
    inline constexpr char Archives[]  = "Archives";
    inline constexpr char Others[]    = "Others";
}

class FileScanner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool scanning READ isScanning NOTIFY scanningChanged)
    Q_PROPERTY(int  progress READ progress   NOTIFY progressChanged)
    Q_PROPERTY(int  totalFiles READ totalFiles NOTIFY totalFilesChanged)

public:
    explicit FileScanner(QObject *parent = nullptr);

    // Configuration - maps extension -> category
    void setCustomCategories(const QMap<QString,QString> &cats);
    QMap<QString,QString> defaultCategories() const;

    // Categorise a single extension
    QString categorize(const QString &ext) const;

    // Human-readable size
    static QString humanSize(qint64 bytes);

    // Accessors
    bool isScanning() const { return m_scanning; }
    int  progress()   const { return m_progress; }
    int  totalFiles() const { return m_totalFiles; }

    const QList<FileEntry>& entries() const { return m_entries; }

    // Statistics: category -> {count, totalBytes}
    QMap<QString, QPair<int,qint64>> stats() const;

public slots:
    void startScan(const QString &rootPath);
    void cancelScan();

signals:
    void scanningChanged();
    void progressChanged();
    void totalFilesChanged();
    void fileFound(const QString &path, const QString &category);
    void scanFinished(int total);
    void scanError(const QString &message);
    void scanCancelled();

private:
    void scanWorker(const QString &rootPath);
    void countFiles(const QString &dir, int &count);

    QMap<QString,QString>  m_categories;
    QList<FileEntry>       m_entries;
    QMutex                 m_mutex;
    std::atomic<bool>      m_scanning{false};
    std::atomic<bool>      m_cancel{false};
    std::atomic<int>       m_progress{0};
    std::atomic<int>       m_totalFiles{0};
    QThread               *m_thread = nullptr;
};
