import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Item {
    id: page

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // ── Title row ─────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Duplicates"; font.pixelSize: 24; font.weight: Font.Bold; color: "#E8E8F0" }
                Text { text: "Detect and manage duplicate files"; font.pixelSize: 12; color: "#5060A0" }
            }
            Item { Layout.fillWidth: true }
            AnimatedButton {
                text: App.dupes.running ? "⟳ Detecting…" : "⊘ Detect Duplicates"
                accent: "#FF6584"
                enabled: App.totalFiles > 0 && !App.dupes.running
                onClicked: App.detectDuplicates()
            }
        }

        // ── Detection progress ────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: 12
            color: "#1A1A35"
            visible: App.dupes.running

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                Text {
                    text: "Hashing files…  " + App.dupes.progress + "%"
                    font.pixelSize: 12; color: "#A0A0C0"
                }
                ProgressBar {
                    Layout.fillWidth: true
                    value: App.dupes.progress / 100
                    accentColor: "#FF6584"
                    accent2: "#FFB347"
                }
            }
        }

        // ── Summary cards ─────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            spacing: 14
            visible: App.dupGroupCount > 0 || !App.dupes.running

            StatCard {
                Layout.fillWidth: true
                label: "Duplicate Groups"
                value: App.dupGroupCount.toString()
                icon:  "⊘"
                accent: "#FF6584"
            }
            StatCard {
                Layout.fillWidth: true
                label: "Wasted Space"
                value: App.dupGroupCount > 0 ? App.dupWastedStr : "—"
                icon:  "💾"
                accent: "#FFB347"
            }
            StatCard {
                Layout.fillWidth: true
                label: "Files Scanned"
                value: App.totalFiles.toString()
                icon:  "📂"
                accent: "#6C63FF"
            }
        }

        // ── Duplicate groups list ─────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: "#151530"
            border.color: "#1E1E3A"
            clip: true

            // Empty / no-scan state
            Item {
                anchors.fill: parent
                visible: App.dupGroupCount === 0 && !App.dupes.running

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Text { Layout.alignment: Qt.AlignHCenter; text: "⊘"; font.pixelSize: 48; color: "#3A3A6A" }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: App.totalFiles > 0
                              ? "Click 'Detect Duplicates' to find redundant files"
                              : "Scan a folder first, then detect duplicates"
                        font.pixelSize: 13; color: "#3A3A6A"
                    }
                }
            }

            // Results
            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: App.dupGroups
                spacing: 10
                clip: true
                visible: App.dupGroupCount > 0

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle { radius: 2; color: "#3A3A6A"; implicitWidth: 4 }
                }

                delegate: Rectangle {
                    id: groupCard
                    width: ListView.view.width
                    height: groupCol.implicitHeight + 24
                    radius: 12
                    color: "#1A1A35"
                    border.color: "#FF658440"
                    border.width: 1

                    property bool expanded: false

                    ColumnLayout {
                        id: groupCol
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.margins: 16
                        spacing: 10

                        // Group header
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Rectangle {
                                width: 32; height: 32; radius: 8
                                color: "#2A1020"
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData.count.toString()
                                    font.pixelSize: 14; font.weight: Font.Bold
                                    color: "#FF6584"
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                Text {
                                    text: modelData.names[0]
                                    font.pixelSize: 13; font.weight: Font.Medium
                                    color: "#E8E8F0"; elide: Text.ElideMiddle
                                }
                                Text {
                                    text: modelData.count + " copies  •  " +
                                          modelData.sizeStr + " each  •  " +
                                          modelData.wastedStr + " wasted"
                                    font.pixelSize: 11; color: "#7060A0"
                                }
                            }

                            // Wasted badge
                            Rectangle {
                                height: 26; radius: 6
                                width: wastedTxt.implicitWidth + 16
                                color: "#2A1020"

                                Text {
                                    id: wastedTxt
                                    anchors.centerIn: parent
                                    text: "−" + modelData.wastedStr
                                    font.pixelSize: 12; font.weight: Font.Bold
                                    color: "#FF6584"
                                }
                            }

                            // Expand toggle
                            Rectangle {
                                width: 26; height: 26; radius: 6
                                color: expMa.containsMouse ? "#2A2A4A" : "#1E1E3A"
                                Text {
                                    anchors.centerIn: parent
                                    text: groupCard.expanded ? "▲" : "▼"
                                    font.pixelSize: 10; color: "#7080B0"
                                }
                                MouseArea {
                                    id: expMa; anchors.fill: parent
                                    hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                    onClicked: groupCard.expanded = !groupCard.expanded
                                }
                            }
                        }

                        // Expanded paths list
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            visible: groupCard.expanded

                            Repeater {
                                model: modelData.paths
                                delegate: Rectangle {
                                    Layout.fillWidth: true
                                    height: 34; radius: 6
                                    color: index === 0 ? "#0D2A1A" : "#1E1E38"
                                    border.color: index === 0 ? "#43D3A050" : "transparent"

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10

                                        Rectangle {
                                            width: 6; height: 6; radius: 3
                                            color: index === 0 ? "#43D3A0" : "#5060A0"
                                        }

                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData
                                            font.pixelSize: 11; color: "#A0A0C0"
                                            elide: Text.ElideLeft
                                        }

                                        Text {
                                            text: index === 0 ? "Keep" : "Duplicate"
                                            font.pixelSize: 10; font.weight: Font.Medium
                                            color: index === 0 ? "#43D3A0" : "#FF6584"
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
