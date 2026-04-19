import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "components"

Item {
    id: page

    Flickable {
        anchors.fill: parent
        contentHeight: mainCol.implicitHeight + 40
        clip: true

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AsNeeded
            contentItem: Rectangle { radius: 2; color: "#3A3A6A"; implicitWidth: 4 }
        }

        ColumnLayout {
            id: mainCol
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 24
            spacing: 20

            // ── Title ─────────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 4
                    Text { text: "Settings"; font.pixelSize: 24; font.weight: Font.Bold; color: "#E8E8F0" }
                    Text { text: "Customize behaviour and categories"; font.pixelSize: 12; color: "#5060A0" }
                }
                Item { Layout.fillWidth: true }
                AnimatedButton {
                    text: "Reset to Defaults"
                    accent: "#FF6584"
                    onClicked: App.settings.reset()
                }
            }

            // ── Section: Behaviour ────────────────────────────────
            SectionCard {
                Layout.fillWidth: true
                title: "Behaviour"

                ToggleRow {
                    label: "Dry Run by Default"
                    subtitle: "Preview changes before applying"
                    checked: App.settings.dryRunDefault
                    onToggled: App.settings.dryRunDefault = checked
                }
                Divider {}
                ToggleRow {
                    label: "Skip Hidden Files"
                    subtitle: "Ignore files starting with '.'"
                    checked: App.settings.skipHidden
                    onToggled: App.settings.skipHidden = checked
                }
                Divider {}
                ToggleRow {
                    label: "Auto-hash on Scan"
                    subtitle: "Compute MD5 during scan (slower but faster duplicates)"
                    checked: App.settings.autoHashDupes
                    onToggled: App.settings.autoHashDupes = checked
                }
            }

            // ── Section: Performance ──────────────────────────────
            SectionCard {
                Layout.fillWidth: true
                title: "Performance"

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    ColumnLayout {
                        spacing: 4
                        Text { text: "Thread Count"; font.pixelSize: 13; color: "#C0C0E0" }
                        Text { text: "Parallel threads for scanning/hashing"; font.pixelSize: 11; color: "#5060A0" }
                    }
                    Item { Layout.fillWidth: true }

                    RowLayout {
                        spacing: 8
                        Rectangle {
                            width: 28; height: 28; radius: 6
                            color: tMinus.containsMouse ? "#2A2A4A" : "#1E1E3A"
                            Text { anchors.centerIn: parent; text: "−"; color: "#8080B0"; font.pixelSize: 14 }
                            MouseArea {
                                id: tMinus; anchors.fill: parent; hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (App.settings.threadCount > 1) App.settings.threadCount--
                            }
                        }
                        Text {
                            text: App.settings.threadCount.toString()
                            font.pixelSize: 16; font.weight: Font.Bold; color: "#E8E8F0"
                            Layout.preferredWidth: 24
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Rectangle {
                            width: 28; height: 28; radius: 6
                            color: tPlus.containsMouse ? "#2A2A4A" : "#1E1E3A"
                            Text { anchors.centerIn: parent; text: "+"; color: "#8080B0"; font.pixelSize: 14 }
                            MouseArea {
                                id: tPlus; anchors.fill: parent; hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (App.settings.threadCount < 32) App.settings.threadCount++
                            }
                        }
                    }
                }
            }

            // ── Section: Default Folder ───────────────────────────
            SectionCard {
                Layout.fillWidth: true
                title: "Default Folder"

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        Layout.fillWidth: true
                        height: 38; radius: 8
                        color: "#1A1A35"
                        border.color: "#2A2A45"

                        Text {
                            anchors.fill: parent
                            anchors.margins: 12
                            text: App.settings.lastFolder.length > 0
                                  ? App.settings.lastFolder
                                  : "No default folder"
                            color: App.settings.lastFolder.length > 0 ? "#E8E8F0" : "#3A3A6A"
                            font.pixelSize: 12
                            elide: Text.ElideLeft
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    AnimatedButton {
                        text: "Browse"
                        accent: "#6C63FF"
                        onClicked: App.openFolderPicker()
                    }
                }
            }

            // ── Section: Export ───────────────────────────────────
            SectionCard {
                Layout.fillWidth: true
                title: "Export"

                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout {
                        spacing: 4
                        Text { text: "Export Activity Log"; font.pixelSize: 13; color: "#C0C0E0" }
                        Text { text: "Save the full log to a .txt file"; font.pixelSize: 11; color: "#5060A0" }
                    }
                    Item { Layout.fillWidth: true }
                    AnimatedButton {
                        text: "Export Log"
                        accent: "#43D3A0"
                        onClicked: logSaveDialog.open()
                    }
                }
            }

            // ── Section: About ────────────────────────────────────
            SectionCard {
                Layout.fillWidth: true
                title: "About"

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    Rectangle {
                        width: 48; height: 48; radius: 12
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0; color: "#6C63FF" }
                            GradientStop { position: 1; color: "#43D3A0" }
                        }
                        Text { anchors.centerIn: parent; text: "⚡"; font.pixelSize: 24; color: "white" }
                    }

                    ColumnLayout {
                        spacing: 4
                        Text { text: "Smart File Optimizer"; font.pixelSize: 14; font.weight: Font.Bold; color: "#E8E8F0" }
                        Text { text: "Version 1.0.0  •  Built with Qt 6 + C++17"; font.pixelSize: 11; color: "#5060A0" }
                        Text { text: "Intelligent file management and optimization"; font.pixelSize: 11; color: "#4050A0" }
                    }
                }
            }

            Item { height: 20 }
        }
    }

    // Save dialog (Qt 6 style)
    FileDialog {
        id: logSaveDialog
        title: "Save Log File"
        fileMode: FileDialog.SaveFile
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        onAccepted: App.exportLog(logSaveDialog.selectedFile.toString().replace("file://", ""))
    }
}
