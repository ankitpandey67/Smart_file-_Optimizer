#include "logger.h"
#include <QFile>
#include <QTextStream>

Logger::Logger(QObject *parent) : QAbstractListModel(parent) {}

int Logger::rowCount(const QModelIndex &) const { return m_entries.size(); }

QVariant Logger::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_entries.size()) return {};
    const auto &e = m_entries[index.row()];
    switch (role) {
    case TimestampRole: return e.timestamp.toString("hh:mm:ss");
    case LevelRole:     return static_cast<int>(e.level);
    case LevelNameRole:
        switch (e.level) {
        case LogEntry::Info:    return "INFO";
        case LogEntry::Warning: return "WARN";
        case LogEntry::Success: return "OK";
        case LogEntry::Error:   return "ERR";
        }
        return "INFO";
    case MessageRole:   return e.message;
    case DetailRole:    return e.detail;
    default:            return {};
    }
}

QHash<int,QByteArray> Logger::roleNames() const
{
    return {
        {TimestampRole, "timestamp"},
        {LevelRole,     "level"},
        {LevelNameRole, "levelName"},
        {MessageRole,   "message"},
        {DetailRole,    "detail"},
    };
}

void Logger::append(LogEntry::Level level, const QString &msg, const QString &detail)
{
    if (m_entries.size() >= MAX_ENTRIES) {
        beginRemoveRows({}, m_entries.size()-1, m_entries.size()-1);
        m_entries.removeLast();
        endRemoveRows();
    }
    LogEntry e;
    e.timestamp = QDateTime::currentDateTime();
    e.level     = level;
    e.message   = msg;
    e.detail    = detail;

    beginInsertRows({}, 0, 0);
    m_entries.prepend(e);
    endInsertRows();

    emit countChanged();
    QString levelName;
    switch (level) {
    case LogEntry::Info:    levelName = "info";    break;
    case LogEntry::Warning: levelName = "warning"; break;
    case LogEntry::Success: levelName = "success"; break;
    case LogEntry::Error:   levelName = "error";   break;
    }
    emit entryAdded(levelName, msg);
}

void Logger::info   (const QString &m, const QString &d) { append(LogEntry::Info,    m, d); }
void Logger::warning(const QString &m, const QString &d) { append(LogEntry::Warning, m, d); }
void Logger::success(const QString &m, const QString &d) { append(LogEntry::Success, m, d); }
void Logger::error  (const QString &m, const QString &d) { append(LogEntry::Error,   m, d); }

void Logger::clear()
{
    beginResetModel();
    m_entries.clear();
    endResetModel();
    emit countChanged();
}

bool Logger::exportLog(const QString &filePath) const
{
    QFile file(filePath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)) return false;
    QTextStream out(&file);
    out << "Smart File Optimizer - Log Export\n";
    out << "Generated: " << QDateTime::currentDateTime().toString(Qt::ISODate) << "\n";
    out << QString(60, '-') << "\n";
    for (int i = m_entries.size()-1; i >= 0; --i) {
        const auto &e = m_entries[i];
        QString lvl;
        switch (e.level) {
        case LogEntry::Info:    lvl = "INFO   "; break;
        case LogEntry::Warning: lvl = "WARNING"; break;
        case LogEntry::Success: lvl = "SUCCESS"; break;
        case LogEntry::Error:   lvl = "ERROR  "; break;
        }
        out << "[" << e.timestamp.toString("yyyy-MM-dd hh:mm:ss") << "] "
            << lvl << " | " << e.message;
        if (!e.detail.isEmpty()) out << " -- " << e.detail;
        out << "\n";
    }
    return true;
}
