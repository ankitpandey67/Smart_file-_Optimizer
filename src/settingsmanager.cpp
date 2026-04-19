#include "settingsmanager.h"
#include <QThread>

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent),
      m_settings("SmartFileOptimizer", "Settings")
{
    m_threadCount = QThread::idealThreadCount();
    load();
}

void SettingsManager::load()
{
    m_darkTheme      = m_settings.value("ui/darkTheme",      true).toBool();
    m_dryRunDefault  = m_settings.value("behavior/dryRun",   true).toBool();
    m_skipHidden     = m_settings.value("behavior/skipHidden",true).toBool();
    m_autoHashDupes  = m_settings.value("behavior/autoHash", false).toBool();
    m_threadCount    = m_settings.value("performance/threads", QThread::idealThreadCount()).toInt();
    m_lastFolder     = m_settings.value("state/lastFolder",  "").toString();

    // Custom categories
    m_customCategories.clear();
    int size = m_settings.beginReadArray("customCategories");
    for (int i = 0; i < size; ++i) {
        m_settings.setArrayIndex(i);
        QString ext = m_settings.value("ext").toString();
        QString cat = m_settings.value("category").toString();
        if (!ext.isEmpty() && !cat.isEmpty())
            m_customCategories[ext] = cat;
    }
    m_settings.endArray();
}

void SettingsManager::save()
{
    m_settings.setValue("ui/darkTheme",          m_darkTheme);
    m_settings.setValue("behavior/dryRun",        m_dryRunDefault);
    m_settings.setValue("behavior/skipHidden",    m_skipHidden);
    m_settings.setValue("behavior/autoHash",      m_autoHashDupes);
    m_settings.setValue("performance/threads",    m_threadCount);
    m_settings.setValue("state/lastFolder",       m_lastFolder);

    m_settings.beginWriteArray("customCategories");
    int i = 0;
    for (auto it = m_customCategories.cbegin(); it != m_customCategories.cend(); ++it, ++i) {
        m_settings.setArrayIndex(i);
        m_settings.setValue("ext",      it.key());
        m_settings.setValue("category", it.value());
    }
    m_settings.endArray();
    m_settings.sync();
}

void SettingsManager::reset()
{
    m_settings.clear();
    m_darkTheme = true; m_dryRunDefault = true;
    m_skipHidden = true; m_autoHashDupes = false;
    m_threadCount = QThread::idealThreadCount();
    m_lastFolder.clear(); m_customCategories.clear();
    emit darkThemeChanged(); emit dryRunDefaultChanged();
    emit skipHiddenChanged(); emit autoHashDupesChanged();
    emit threadCountChanged(); emit lastFolderChanged();
}

QMap<QString,QString> SettingsManager::customCategories() const { return m_customCategories; }
void SettingsManager::setCustomCategories(const QMap<QString,QString> &cats)
{ m_customCategories = cats; save(); }

void SettingsManager::setDarkTheme(bool v)
{ if (m_darkTheme != v) { m_darkTheme = v; emit darkThemeChanged(); save(); } }
void SettingsManager::setDryRunDefault(bool v)
{ if (m_dryRunDefault != v) { m_dryRunDefault = v; emit dryRunDefaultChanged(); save(); } }
void SettingsManager::setSkipHidden(bool v)
{ if (m_skipHidden != v) { m_skipHidden = v; emit skipHiddenChanged(); save(); } }
void SettingsManager::setAutoHashDupes(bool v)
{ if (m_autoHashDupes != v) { m_autoHashDupes = v; emit autoHashDupesChanged(); save(); } }
void SettingsManager::setThreadCount(int v)
{ if (m_threadCount != v) { m_threadCount = v; emit threadCountChanged(); save(); } }
void SettingsManager::setLastFolder(const QString &v)
{ if (m_lastFolder != v) { m_lastFolder = v; emit lastFolderChanged(); save(); } }
