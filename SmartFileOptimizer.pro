QT += core gui widgets quick quickcontrols2 concurrent charts

CONFIG += c++17

TARGET = SmartFileOptimizer
TEMPLATE = app

SOURCES += \
    src/main.cpp \
    src/filescanner.cpp \
    src/fileorganizer.cpp \
    src/duplicatedetector.cpp \
    src/logger.cpp \
    src/settingsmanager.cpp \
    src/bridge.cpp

HEADERS += \
    src/filescanner.h \
    src/fileorganizer.h \
    src/duplicatedetector.h \
    src/logger.h \
    src/settingsmanager.h \
    src/bridge.h

RESOURCES += resources/resources.qrc

QML_IMPORT_PATH += qml

DISTFILES += \
    qml/Main.qml \
    qml/Dashboard.qml \
    qml/ScanPage.qml \
    qml/OrganizePage.qml \
    qml/DuplicatesPage.qml \
    qml/SettingsPage.qml \
    qml/components/Sidebar.qml \
    qml/components/StatCard.qml \
    qml/components/FileCard.qml \
    qml/components/LogPanel.qml \
    qml/components/ProgressBar.qml \
    qml/components/DonutChart.qml \
    qml/components/AnimatedButton.qml \
    qml/components/HeaderBar.qml
