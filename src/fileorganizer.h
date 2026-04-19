#pragma once
#include "filescanner.h"
#include <QObject>
#include <QMap>
#include <QStringList>

// Represents one organizer action (for undo/log)
struct OrganizerAction {
    QString source;
    QString destination;
    QString category;
    bool    success;
    QString errorMsg;
};

class FileOrganizer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ isRunning NOTIFY runningChanged)
    Q_PROPERTY(int  progress READ progress NOTIFY progressChanged)

public:
    explicit FileOrganizer(QObject *parent = nullptr);

    // Set root output folder (default = same as scan root)
    void setOutputRoot(const QString &path) { m_outputRoot = path; }

    bool isRunning() const { return m_running; }
    int  progress()  const { return m_progress; }

    const QList<OrganizerAction>& history() const { return m_history; }

public slots:
    // dryRun=true -> simulate, don't actually move
    void organize(const QList<FileEntry> &entries, bool dryRun = false);
    void undoLast();
    void clearHistory();

signals:
    void runningChanged();
    void progressChanged();
    void actionPerformed(const QString &src, const QString &dst, bool dryRun, bool success);
    void organizeFinished(int moved, int skipped, int errors);
    void undoFinished(int restored);

private:
    QString buildDestPath(const FileEntry &entry) const;
    bool    safeMoveFile(const QString &src, const QString &dst, QString &error);

    QString               m_outputRoot;
    QList<OrganizerAction> m_history;
    bool                  m_running{false};
    int                   m_progress{0};
};
