#pragma once
#include <QObject>
#include <QSettings>
#include <QMap>
#include <QString>
#include <QStringList>

class SettingsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool darkTheme      READ darkTheme      WRITE setDarkTheme      NOTIFY darkThemeChanged)
    Q_PROPERTY(bool dryRunDefault  READ dryRunDefault  WRITE setDryRunDefault  NOTIFY dryRunDefaultChanged)
    Q_PROPERTY(bool skipHidden     READ skipHidden     WRITE setSkipHidden     NOTIFY skipHiddenChanged)
    Q_PROPERTY(bool autoHashDupes  READ autoHashDupes  WRITE setAutoHashDupes  NOTIFY autoHashDupesChanged)
    Q_PROPERTY(int  threadCount    READ threadCount    WRITE setThreadCount    NOTIFY threadCountChanged)
    Q_PROPERTY(QString lastFolder  READ lastFolder     WRITE setLastFolder     NOTIFY lastFolderChanged)

public:
    explicit SettingsManager(QObject *parent = nullptr);

    bool    darkTheme()     const { return m_darkTheme; }
    bool    dryRunDefault() const { return m_dryRunDefault; }
    bool    skipHidden()    const { return m_skipHidden; }
    bool    autoHashDupes() const { return m_autoHashDupes; }
    int     threadCount()   const { return m_threadCount; }
    QString lastFolder()    const { return m_lastFolder; }

    // Custom category map: ext -> category name
    QMap<QString,QString> customCategories() const;
    void setCustomCategories(const QMap<QString,QString> &cats);

public slots:
    void setDarkTheme    (bool v);
    void setDryRunDefault(bool v);
    void setSkipHidden   (bool v);
    void setAutoHashDupes(bool v);
    void setThreadCount  (int v);
    void setLastFolder   (const QString &v);
    void save();
    void load();
    void reset();

signals:
    void darkThemeChanged();
    void dryRunDefaultChanged();
    void skipHiddenChanged();
    void autoHashDupesChanged();
    void threadCountChanged();
    void lastFolderChanged();

private:
    QSettings m_settings;
    bool    m_darkTheme{true};
    bool    m_dryRunDefault{true};
    bool    m_skipHidden{true};
    bool    m_autoHashDupes{false};
    int     m_threadCount{4};
    QString m_lastFolder;
    QMap<QString,QString> m_customCategories;
};
