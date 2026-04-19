#include "bridge.h"
#include <QFileDialog>
#include <QApplication>
#include <QThread>
#include <cmath>

Bridge::Bridge(QObject *parent)
    : QObject(parent)
{
    m_scanner   = new FileScanner(this);
    m_organizer = new FileOrganizer(this);
    m_dupes     = new DuplicateDetector(this);
    m_logger    = new Logger(this);
    m_settings  = new SettingsManager(this);

    m_selectedFolder = m_settings->lastFolder();

    // Wire scanner signals
    connect(m_scanner, &FileScanner::scanFinished, this, &Bridge::onScanFinished);
    connect(m_scanner, &FileScanner::scanError,    this, [this](const QString &msg){
        m_logger->error("Scan error", msg);
        emit notification("error", msg);
    });
    connect(m_scanner, &FileScanner::scanCancelled, this, [this](){
        m_logger->warning("Scan cancelled by user");
        emit notification("warning", "Scan cancelled");
    });

    // Wire organizer signals
    connect(m_organizer, &FileOrganizer::organizeFinished, this,
            [this](int moved, int skipped, int errors){
        m_logger->success(
            QString("Organize complete: %1 moved, %2 skipped, %3 errors")
                .arg(moved).arg(skipped).arg(errors));
        emit notification("success",
            QString("Done! Moved %1 files").arg(moved));
    });
    connect(m_organizer, &FileOrganizer::undoFinished, this, [this](int n){
        m_logger->info(QString("Undo: restored %1 files").arg(n));
        emit notification("info", QString("Undo: %1 files restored").arg(n));
    });

    // Wire duplicate signals
    connect(m_dupes, &DuplicateDetector::detectionFinished,
            this, &Bridge::onDupDetectionFinished);
}

/* ------------------------------------------------------------------ */
/* Properties                                                           */
/* ------------------------------------------------------------------ */

int Bridge::totalFiles() const
{
    return m_scanner->entries().size();
}

double Bridge::totalSizeMB() const
{
    qint64 total = 0;
    for (const auto &e : m_scanner->entries()) total += e.size;
    return total / (1024.0 * 1024.0);
}

QString Bridge::totalSizeStr() const
{
    qint64 total = 0;
    for (const auto &e : m_scanner->entries()) total += e.size;
    return FileScanner::humanSize(total);
}

static const QMap<QString,QString> &catColors()
{
    static QMap<QString,QString> m = {
        {"Images",    "#6C63FF"},
        {"Videos",    "#FF6584"},
        {"Documents", "#43D3A0"},
        {"Music",     "#FFB347"},
        {"Archives",  "#4FC3F7"},
        {"Others",    "#90A4AE"},
    };
    return m;
}

QString Bridge::categoryColor(const QString &cat) const
{
    return catColors().value(cat, "#90A4AE");
}

const QMap<QString,QString>& Bridge::categoryColors() { return catColors(); }

QVariantList Bridge::categoryStats() const
{
    auto stats = m_scanner->stats();
    QVariantList result;
    for (auto it = stats.cbegin(); it != stats.cend(); ++it) {
        QVariantMap m;
        m["name"]    = it.key();
        m["count"]   = it.value().first;
        m["sizeMB"]  = it.value().second / (1024.0 * 1024.0);
        m["sizeStr"] = FileScanner::humanSize(it.value().second);
        m["color"]   = catColors().value(it.key(), "#90A4AE");
        result.append(m);
    }
    return result;
}

QVariantList Bridge::largeFiles() const
{
    QVariantList result;
    const qint64 threshold = 100LL * 1024 * 1024; // 100MB
    QList<FileEntry> large;
    for (const auto &e : m_scanner->entries())
        if (e.size >= threshold) large.append(e);

    std::sort(large.begin(), large.end(),
              [](const FileEntry &a, const FileEntry &b){ return a.size > b.size; });

    for (const auto &e : large.mid(0, 20)) {
        QVariantMap m;
        m["name"]    = e.name;
        m["path"]    = e.path;
        m["sizeStr"] = e.sizeHuman;
        m["category"]= e.category;
        result.append(m);
    }
    return result;
}

int Bridge::dupGroupCount() const { return m_dupes->groups().size(); }

QString Bridge::dupWastedStr() const
{
    return FileScanner::humanSize(m_dupes->totalWastedBytes());
}

QVariantList Bridge::dupGroups() const
{
    QVariantList result;
    for (const auto &g : m_dupes->groups()) {
        QVariantMap m;
        m["hash"]        = g.hash.toHex();
        m["count"]       = g.paths.size();
        m["sizeStr"]     = FileScanner::humanSize(g.size);
        m["wastedStr"]   = FileScanner::humanSize(g.wastedBytes);
        m["wastedBytes"] = (double)g.wastedBytes;
        QStringList names;
        for (const auto &p : g.paths) names.append(QFileInfo(p).fileName());
        m["names"]       = names;
        m["paths"]       = g.paths;
        result.append(m);
    }
    return result;
}

/* ------------------------------------------------------------------ */
/* Slots                                                                */
/* ------------------------------------------------------------------ */

void Bridge::setSelectedFolder(const QString &path)
{
    if (m_selectedFolder == path) return;
    m_selectedFolder = path;
    m_settings->setLastFolder(path);
    emit selectedFolderChanged();
    m_logger->info("Folder selected", path);
}

void Bridge::startScan()
{
    if (m_selectedFolder.isEmpty()) {
        emit notification("warning", "Please select a folder first");
        return;
    }
    m_logger->info("Starting scan", m_selectedFolder);
    m_scanner->startScan(m_selectedFolder);
}

void Bridge::cancelScan()
{
    m_scanner->cancelScan();
}

void Bridge::organizeFiles(bool dryRun)
{
    if (m_scanner->entries().isEmpty()) {
        emit notification("warning", "No files scanned yet");
        return;
    }
    m_organizer->setOutputRoot(m_selectedFolder);
    m_logger->info(dryRun ? "Dry-run organize started" : "Organize started",
                   QString("%1 files").arg(m_scanner->entries().size()));
    m_organizer->organize(m_scanner->entries(), dryRun);
}

void Bridge::undoOrganize()
{
    m_organizer->undoLast();
}

void Bridge::detectDuplicates()
{
    if (m_scanner->entries().isEmpty()) {
        emit notification("warning", "Scan a folder first");
        return;
    }
    m_logger->info("Duplicate detection started",
                   QString("%1 files").arg(m_scanner->entries().size()));
    m_dupes->detect(m_scanner->entries());
}

void Bridge::exportLog(const QString &path)
{
    QString cleanPath = path;
    cleanPath.remove("file://");
    if (m_logger->exportLog(cleanPath))
        emit notification("success", "Log exported to " + cleanPath);
    else
        emit notification("error", "Could not export log");
}

void Bridge::openFolderPicker()
{
    QString path = QFileDialog::getExistingDirectory(
        nullptr, "Select Folder to Organize",
        m_selectedFolder.isEmpty() ? QDir::homePath() : m_selectedFolder,
        QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    if (!path.isEmpty()) {
        setSelectedFolder(path);
        emit folderPickerResult(path);
    }
}

void Bridge::onScanFinished(int total)
{
    m_logger->success(QString("Scan complete: %1 files found").arg(total),
                      totalSizeStr() + " total");
    emit statsChanged();
    emit notification("success", QString("Scanned %1 files (%2)").arg(total).arg(totalSizeStr()));
}

void Bridge::onDupDetectionFinished(int groups, qint64 wasted)
{
    m_logger->success(
        QString("Duplicates: %1 groups found").arg(groups),
        QString("Wasted space: %1").arg(FileScanner::humanSize(wasted)));
    emit dupStatsChanged();
    emit notification("info",
        QString("%1 duplicate groups, %2 wasted")
            .arg(groups).arg(FileScanner::humanSize(wasted)));
}
