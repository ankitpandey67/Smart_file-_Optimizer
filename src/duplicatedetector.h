#pragma once
#include "filescanner.h"
#include <QObject>
#include <QList>
#include <QMap>
#include <QByteArray>

struct DuplicateGroup {
    QByteArray hash;
    qint64     size;          // bytes per file
    QStringList paths;        // all paths with same hash
    int         wastedCount;  // paths.size()-1
    qint64      wastedBytes;  // (paths.size()-1)*size
};

class DuplicateDetector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int  progress READ progress NOTIFY progressChanged)

public:
    explicit DuplicateDetector(QObject *parent = nullptr);

    bool isRunning() const { return m_running; }
    int  progress()  const { return m_progress; }

    const QList<DuplicateGroup>& groups() const { return m_groups; }

    // Total wasted space
    qint64 totalWastedBytes() const;

public slots:
    void detect(const QList<FileEntry> &entries);
    void cancel();

signals:
    void runningChanged();
    void progressChanged();
    void detectionFinished(int groupCount, qint64 wastedBytes);

private:
    static QByteArray computeHash(const QString &path);

    QList<DuplicateGroup> m_groups;
    std::atomic<bool>     m_running{false};
    std::atomic<bool>     m_cancel{false};
    std::atomic<int>      m_progress{0};
};
