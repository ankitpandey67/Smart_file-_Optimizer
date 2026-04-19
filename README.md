# Smart File Optimizer & Organizer

A professional desktop application for intelligent file management, built with **C++17** and **Qt 6 QML**.

---

## Features

| Feature | Description |
|---|---|
| 📂 Folder scanning | Recursive multi-threaded file discovery |
| 🗂 Auto-categorization | Images, Videos, Documents, Music, Archives, Others |
| ⊙ Safe organizing | Move files to category subfolders with collision handling |
| 👁 Dry-run / Preview | Simulate moves without touching the filesystem |
| ⊘ Duplicate detection | MD5 hash-based duplicate finder with wasted-space stats |
| ↺ Undo | Reverse the last organize operation |
| 📊 Dashboard | Live donut chart, stat cards, large-file recommendations |
| 📝 Activity log | Full timestamped log with export to .txt |
| ⚙ Settings | Toggles, thread count, custom folder, log export |

---

## Architecture

```
SmartFileOptimizer/
├── src/
│   ├── main.cpp              – App entry point, QML engine setup
│   ├── bridge.h/.cpp         – Central QML↔C++ bridge ("App" context)
│   ├── filescanner.h/.cpp    – Recursive scanner (QtConcurrent)
│   ├── fileorganizer.h/.cpp  – Safe file mover + undo
│   ├── duplicatedetector.h/.cpp – MD5 hash duplicate finder
│   ├── logger.h/.cpp         – QAbstractListModel-based log
│   └── settingsmanager.h/.cpp – QSettings wrapper
├── qml/
│   ├── Main.qml              – Root window, toast notifications
│   ├── Dashboard.qml         – Stats, donut chart, large files
│   ├── ScanPage.qml          – Scan control, real-time file list
│   ├── OrganizePage.qml      – Organize / preview / undo
│   ├── DuplicatesPage.qml    – Duplicate groups viewer
│   ├── SettingsPage.qml      – All settings
│   └── components/
│       ├── Sidebar.qml       – Left navigation
│       ├── HeaderBar.qml     – Folder selector + quick actions
│       ├── AnimatedButton.qml
│       ├── StatCard.qml
│       ├── FileCard.qml
│       ├── DonutChart.qml    – Canvas-based donut chart
│       ├── ProgressBar.qml   – Shimmer-animated progress bar
│       └── LogPanel.qml
├── resources/
│   └── resources.qrc
├── SmartFileOptimizer.pro    – qmake project file
└── CMakeLists.txt            – CMake alternative
```

---

## Requirements

- **Qt 6.2+** (Qt 6.4+ recommended)
  - Modules: `Core Gui Widgets Quick QuickControls2 Concurrent Charts`
- **C++17** compiler (GCC 9+, Clang 10+, MSVC 2019+)
- **Qt Creator 8+** (recommended IDE)

---

## Building in Qt Creator

### Step 1 – Open the project

1. Launch **Qt Creator**
2. Go to **File → Open File or Project…**
3. Navigate to the `SmartFileOptimizer` folder
4. Open **`SmartFileOptimizer.pro`** (qmake) **or** **`CMakeLists.txt`** (CMake)

### Step 2 – Configure the kit

1. Qt Creator will prompt you to configure a kit
2. Select a **Qt 6** desktop kit (e.g., `Qt 6.6.x GCC 64bit`)
3. Click **Configure Project**

### Step 3 – Build and Run

1. Press **Ctrl+R** (or click the green ▶ button)
2. The app will build and launch automatically

> **Tip:** For a Release build (faster), go to the kit selector at the bottom-left and switch from Debug to Release.

---

## Building from the Command Line

### qmake
```bash
cd SmartFileOptimizer
mkdir build && cd build
qmake ../SmartFileOptimizer.pro -spec linux-g++ CONFIG+=release
make -j$(nproc)
./SmartFileOptimizer
```

### CMake
```bash
cd SmartFileOptimizer
cmake -B build -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x.x/gcc_64
cmake --build build --parallel
./build/SmartFileOptimizer
```

Replace `/path/to/Qt/6.x.x/gcc_64` with your actual Qt installation path, e.g.:
- **Linux:**   `~/Qt/6.6.0/gcc_64`
- **macOS:**   `~/Qt/6.6.0/macos`
- **Windows:** `C:\Qt\6.6.0\msvc2019_64`

---

## Usage Guide

1. **Select a folder** – Click the folder bar in the header or "Select Folder" button
2. **Scan** – Click "⊕ Scan Now" to recursively discover all files
3. **Review** – Check the Dashboard for category breakdown, large files, storage chart
4. **Preview** – Go to Organize → ensure "Dry Run" is ON → click "Preview"
5. **Organize** – Toggle Dry Run OFF → click "Organize Now" to move files
6. **Undo** – Click "↺ Undo Last" on the Organize page to restore moved files
7. **Duplicates** – Go to Duplicates → "Detect Duplicates" to find redundant files
8. **Settings** – Customize thread count, toggle behaviors, export logs

---

## Safety Notes

- **Dry Run is ON by default** – no files are moved until you disable it
- Collision handling: if a file with the same name already exists at the destination, it is renamed with a numeric suffix (e.g., `photo_1.jpg`)
- Cross-device moves: the app falls back to copy+delete when rename fails across filesystems
- Undo restores files from their categorized location back to their original path

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `QML module not found` | Ensure `QML_IMPORT_PATH` or `QML_FILES` is correct in `.pro`/`CMakeLists.txt` |
| `Cannot find -lQt6Charts` | Install `libqt6charts6-dev` or add Charts module in Qt Maintenance Tool |
| Blank window on Linux | Run `export QT_QPA_PLATFORM=xcb` before launching |
| FileDialog not found | Add `Qt5Compat.GraphicalEffects` or use `QtQuick.Dialogs 1.3` (Qt 5) vs `QtQuick.Dialogs` (Qt 6) |

---

## License

MIT License — free for personal and commercial use.
