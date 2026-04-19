#pragma once
#include <QObject>
#include <QAbstractListModel>
#include <QDateTime>
#include <QList>

struct LogEntry {
    enum Level { Info, Warning, Success, Error };
    QDateTime timestamp;
    Level     level;
    QString   message;
    QString   detail;
};

class Logger : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        TimestampRole = Qt::UserRole + 1,
        LevelRole,
        LevelNameRole,
        MessageRole,
        DetailRole
    };

    explicit Logger(QObject *parent = nullptr);

    // QAbstractListModel
    int      rowCount(const QModelIndex &parent = {}) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

public slots:
    void info   (const QString &msg, const QString &detail = {});
    void warning(const QString &msg, const QString &detail = {});
    void success(const QString &msg, const QString &detail = {});
    void error  (const QString &msg, const QString &detail = {});
    void clear();

    // Export to file
    bool exportLog(const QString &filePath) const;

signals:
    void countChanged();
    void entryAdded(const QString &level, const QString &message);

private:
    void append(LogEntry::Level level, const QString &msg, const QString &detail);
    QList<LogEntry> m_entries;
    static const int MAX_ENTRIES = 2000;
};
