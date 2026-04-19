#pragma once
#include "filescanner.h"
#include "fileorganizer.h"
#include "duplicatedetector.h"
#include "logger.h"
#include "settingsmanager.h"
#include <QObject>
#include <QVariantList>
#include <QVariantMap>
#include <QStringList>

/**
 * Bridge is the single QML-accessible object that orchestrates all modules.
 * Exposed to QML as "App".
 */
class Bridge : public QObject
{
    Q_OBJECT

    // Sub-objects exposed to QML
    Q_PROPERTY(Logger*          log       READ log       CONSTANT)
    Q_PROPERTY(SettingsManager* settings  READ settings  CONSTANT)
    Q_PROPERTY(FileScanner*     scanner   READ scanner   CONSTANT)
    Q_PROPERTY(FileOrganizer*   organizer READ organizer CONSTANT)
    Q_PROPERTY(DuplicateDetector* dupes   READ dupes     CONSTANT)

    // Convenience props
    Q_PROPERTY(QString  selectedFolder READ selectedFolder WRITE setSelectedFolder NOTIFY selectedFolderChanged)
    Q_PROPERTY(int      totalFiles     READ totalFiles     NOTIFY statsChanged)
    Q_PROPERTY(double   totalSizeMB    READ totalSizeMB    NOTIFY statsChanged)
    Q_PROPERTY(QString  totalSizeStr   READ totalSizeStr   NOTIFY statsChanged)

    // Category stats for charts (list of {name, count, sizeMB, color})
    Q_PROPERTY(QVariantList categoryStats READ categoryStats NOTIFY statsChanged)

    // Large file recommendations (files > 100MB)
    Q_PROPERTY(QVariantList largeFiles READ largeFiles NOTIFY statsChanged)

    // Duplicate stats
    Q_PROPERTY(int     dupGroupCount  READ dupGroupCount  NOTIFY dupStatsChanged)
    Q_PROPERTY(QString dupWastedStr   READ dupWastedStr   NOTIFY dupStatsChanged)
    Q_PROPERTY(QVariantList dupGroups READ dupGroups      NOTIFY dupStatsChanged)

public:
    explicit Bridge(QObject *parent = nullptr);

    Logger*            log()       { return m_logger; }
    SettingsManager*   settings()  { return m_settings; }
    FileScanner*       scanner()   { return m_scanner; }
    FileOrganizer*     organizer() { return m_organizer; }
    DuplicateDetector* dupes()     { return m_dupes; }

    QString  selectedFolder() const { return m_selectedFolder; }
    int      totalFiles()     const;
    double   totalSizeMB()    const;
    QString  totalSizeStr()   const;
    QVariantList categoryStats() const;
    QVariantList largeFiles()    const;
    int      dupGroupCount()  const;
    QString  dupWastedStr()   const;
    QVariantList dupGroups()  const;

public slots:
    void setSelectedFolder(const QString &path);

    // QML-callable actions
    void startScan();
    void cancelScan();
    void organizeFiles(bool dryRun);
    void undoOrganize();
    void detectDuplicates();
    void exportLog(const QString &path);

    // Utility: open folder picker (returns path via signal)
    void openFolderPicker();

    // Returns category color for a given category name
    QString categoryColor(const QString &cat) const;

signals:
    void selectedFolderChanged();
    void statsChanged();
    void dupStatsChanged();
    void folderPickerResult(const QString &path);
    void notification(const QString &type, const QString &message); // type: success/error/info/warning

private:
    void onScanFinished(int total);
    void onDupDetectionFinished(int groups, qint64 wasted);

    FileScanner*       m_scanner;
    FileOrganizer*     m_organizer;
    DuplicateDetector* m_dupes;
    Logger*            m_logger;
    SettingsManager*   m_settings;

    QString            m_selectedFolder;

    static const QMap<QString,QString>& categoryColors();
};
