import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Item {
    id: page

    // File list model (accumulated from scanner signals)
    ListModel { id: fileModel }

    Connections {
        target: App.scanner
        function onFileFound(path, category) {
            // Only keep latest 500 in view for performance
            if (fileModel.count >= 500) fileModel.remove(0)
            var parts = path.split("/")
            fileModel.append({
                fileName: parts[parts.length - 1],
                filePath: path,
                category: category,
                fileSize: ""
            })
        }
        function onScanFinished(total) {
            // Rebuild from actual entries with sizes
            fileModel.clear()
            // We show up to 300 in the list
            var entries = App.categoryStats  // just trigger re-bind
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // ── Title row ─────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Scan"; font.pixelSize: 24; font.weight: Font.Bold; color: "#E8E8F0" }
                Text { text: "Recursively scan and analyse your folder"; font.pixelSize: 12; color: "#5060A0" }
            }
            Item { Layout.fillWidth: true }
            AnimatedButton {
                text: App.scanner.scanning ? "⏹ Cancel" : "⊕ Start Scan"
                accent: App.scanner.scanning ? "#FF6584" : "#6C63FF"
                enabled: App.selectedFolder.length > 0
                onClicked: App.scanner.scanning ? App.cancelScan() : App.startScan()
            }
        }

        // ── Scan status card ──────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 14
            color: "#1A1A35"
            border.color: "#22223A"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                // Animated spinner
                Rectangle {
                    width: 42; height: 42; radius: 21
                    color: "#6C63FF"
                    opacity: App.scanner.scanning ? 1 : 0.3

                    Text {
                        anchors.centerIn: parent
                        text: App.scanner.scanning ? "⟳" : "⊕"
                        font.pixelSize: 20
                        color: "white"

                        NumberAnimation on rotation {
                            from: 0; to: 360
                            duration: 1200
                            loops: Animation.Infinite
                            running: App.scanner.scanning
                        }
                    }
                }

                ColumnLayout {
                    spacing: 6

                    RowLayout {
                        Text {
                            text: App.scanner.scanning
                                  ? "Scanning…  " + App.scanner.progress + "%"
                                  : (App.totalFiles > 0 ? "Scan complete" : "Ready to scan")
                            font.pixelSize: 14; font.weight: Font.Medium
                            color: "#E8E8F0"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: App.scanner.totalFiles + " files detected"
                            font.pixelSize: 12; color: "#5060A0"
                            visible: App.scanner.scanning || App.totalFiles > 0
                        }
                    }

                    ProgressBar {
                        Layout.preferredWidth: 400
                        value: App.scanner.progress / 100
                    }
                }
            }
        }

        // ── Category filter tabs ──────────────────────────────────
        property string filterCat: "All"

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: ["All", "Images", "Videos", "Documents", "Music", "Archives", "Others"]
                delegate: Rectangle {
                    property bool active: page.filterCat === modelData
                    height: 30; radius: 15
                    width: tabText.implicitWidth + 24
                    color: active ? "#6C63FF" : (tm.containsMouse ? "#1E1E40" : "#1A1A35")
                    border.color: active ? "transparent" : "#2A2A45"

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        id: tabText
                        anchors.centerIn: parent
                        text: modelData
                        font.pixelSize: 12
                        color: active ? "white" : "#7080A0"
                    }
                    MouseArea {
                        id: tm; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: page.filterCat = modelData
                    }
                }
            }

            Item { Layout.fillWidth: true }
            Text {
                text: App.totalFiles + " total  •  " + App.totalSizeStr
                font.pixelSize: 12; color: "#5060A0"
                visible: App.totalFiles > 0
            }
        }

        // ── File list ─────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: "#151530"
            border.color: "#1E1E3A"
            clip: true

            // Empty state
            Item {
                anchors.fill: parent
                visible: fileModel.count === 0

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Text { Layout.alignment: Qt.AlignHCenter; text: "📂"; font.pixelSize: 48 }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: App.selectedFolder.length === 0
                              ? "Select a folder to start"
                              : "Click 'Start Scan' to discover files"
                        font.pixelSize: 14; color: "#3A3A6A"
                    }
                    AnimatedButton {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Select Folder"
                        visible: App.selectedFolder.length === 0
                        onClicked: App.openFolderPicker()
                    }
                }
            }

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: fileModel
                clip: true
                spacing: 3
                visible: fileModel.count > 0

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle { radius: 2; color: "#3A3A6A"; implicitWidth: 4 }
                }

                delegate: FileCard {
                    width: ListView.view.width
                    fileName: model.fileName
                    filePath: model.filePath
                    category: model.category
                    fileSize: model.fileSize
                    visible: page.filterCat === "All" || page.filterCat === model.category
                    height: visible ? 44 : 0
                }
            }
        }
    }
}
