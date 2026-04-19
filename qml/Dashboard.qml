import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Item {
    id: page

    // Refresh chart whenever stats change
    Connections {
        target: App
        function onStatsChanged() { chartTimer.restart() }
    }
    Timer { id: chartTimer; interval: 50; onTriggered: donutChart.requestPaintUpdate() }

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

            // ── Page title ────────────────────────────────────────
            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 4
                    Text {
                        text: "Dashboard"
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        color: "#E8E8F0"
                    }
                    Text {
                        text: App.selectedFolder.length > 0
                              ? App.selectedFolder
                              : "No folder selected — pick one in the header"
                        font.pixelSize: 12
                        color: "#5060A0"
                        elide: Text.ElideLeft
                    }
                }

                Item { Layout.fillWidth: true }

                // CTA when no folder selected
                AnimatedButton {
                    text: "⊕ Select Folder"
                    accent: "#6C63FF"
                    visible: App.selectedFolder.length === 0
                    onClicked: App.openFolderPicker()
                }

                AnimatedButton {
                    text: App.scanner.scanning ? "⏹ Scanning…" : "⊕ Scan Now"
                    accent: App.scanner.scanning ? "#FF6584" : "#6C63FF"
                    visible: App.selectedFolder.length > 0
                    onClicked: App.scanner.scanning ? App.cancelScan() : App.startScan()
                }
            }

            // ── Scan progress bar ─────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                height: 54
                radius: 12
                color: "#1A1A35"
                border.color: "#2A2A45"
                visible: App.scanner.scanning || App.organizer.running

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 6

                    RowLayout {
                        Text {
                            text: App.scanner.scanning
                                  ? "Scanning files…  " + App.scanner.progress + "%"
                                  : "Organizing files…  " + App.organizer.progress + "%"
                            font.pixelSize: 12
                            color: "#A0A0C0"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: App.scanner.totalFiles + " found"
                            font.pixelSize: 11
                            color: "#5060A0"
                            visible: App.scanner.scanning
                        }
                    }

                    ProgressBar {
                        Layout.fillWidth: true
                        value: App.scanner.scanning
                               ? App.scanner.progress / 100
                               : App.organizer.progress / 100
                    }
                }
            }

            // ── Stat cards row ────────────────────────────────────
            GridLayout {
                Layout.fillWidth: true
                columns: 4
                columnSpacing: 14
                rowSpacing: 14

                StatCard {
                    Layout.fillWidth: true
                    label: "Total Files"
                    value: App.totalFiles.toLocaleString()
                    icon:  "📂"
                    accent: "#6C63FF"
                    subtitle: App.totalSizeStr
                }
                StatCard {
                    Layout.fillWidth: true
                    label: "Duplicates"
                    value: App.dupGroupCount.toString()
                    icon:  "⊘"
                    accent: "#FF6584"
                    subtitle: App.dupGroupCount > 0 ? App.dupWastedStr + " wasted" : "Run detection"
                }
                StatCard {
                    Layout.fillWidth: true
                    label: "Large Files"
                    value: App.largeFiles.length.toString()
                    icon:  "⚠"
                    accent: "#FFB347"
                    subtitle: "> 100 MB each"
                }
                StatCard {
                    Layout.fillWidth: true
                    label: "Categories"
                    value: App.categoryStats.length.toString()
                    icon:  "⊞"
                    accent: "#43D3A0"
                    subtitle: "File types"
                }
            }

            // ── Chart + category breakdown ────────────────────────
            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                // Donut chart card
                Rectangle {
                    Layout.preferredWidth: 280
                    Layout.fillHeight: true
                    implicitHeight: 280
                    radius: 14
                    color: "#1A1A35"
                    border.color: "#22223A"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 8

                        Text {
                            text: "Storage by Category"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#8080B0"
                        }

                        DonutChart {
                            id: donutChart
                            Layout.alignment: Qt.AlignHCenter
                            width: 200; height: 200
                            centerText: App.totalSizeStr.length > 0 ? App.totalSizeStr : "—"
                            centerSub: "total"

                            function requestPaintUpdate() {
                                var segs = [];
                                for (var i = 0; i < App.categoryStats.length; i++) {
                                    var s = App.categoryStats[i];
                                    segs.push({ color: s.color, value: s.sizeMB, label: s.name });
                                }
                                segments = segs;
                            }
                        }
                    }
                }

                // Category list
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    implicitHeight: 280
                    radius: 14
                    color: "#1A1A35"
                    border.color: "#22223A"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 10

                        Text {
                            text: "Category Breakdown"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: "#8080B0"
                        }

                        // Empty state
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: App.categoryStats.length === 0

                            Text {
                                anchors.centerIn: parent
                                text: "Scan a folder to see breakdown"
                                color: "#3A3A6A"
                                font.pixelSize: 13
                            }
                        }

                        Repeater {
                            model: App.categoryStats
                            visible: App.categoryStats.length > 0

                            delegate: ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    Rectangle {
                                        width: 10; height: 10; radius: 3
                                        color: modelData.color
                                    }
                                    Text {
                                        text: modelData.name
                                        font.pixelSize: 12
                                        color: "#C0C0E0"
                                        Layout.fillWidth: true
                                    }
                                    Text {
                                        text: modelData.count + " files"
                                        font.pixelSize: 11
                                        color: "#5060A0"
                                    }
                                    Text {
                                        text: modelData.sizeStr
                                        font.pixelSize: 11
                                        color: "#5060A0"
                                        Layout.preferredWidth: 70
                                        horizontalAlignment: Text.AlignRight
                                    }
                                }

                                // Mini bar
                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 4; radius: 2
                                    color: "#1E1E3A"

                                    property real maxMB: {
                                        var m = 1;
                                        for (var i = 0; i < App.categoryStats.length; i++)
                                            if (App.categoryStats[i].sizeMB > m) m = App.categoryStats[i].sizeMB;
                                        return m;
                                    }

                                    Rectangle {
                                        height: parent.height; radius: 2
                                        color: modelData.color
                                        width: parent.maxMB > 0
                                               ? parent.width * (modelData.sizeMB / parent.maxMB)
                                               : 0
                                        Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── Large files section ────────────────────────────────
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: largeCol.implicitHeight + 30
                radius: 14
                color: "#1A1A35"
                border.color: "#22223A"
                visible: App.largeFiles.length > 0

                ColumnLayout {
                    id: largeCol
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 20
                    spacing: 8

                    RowLayout {
                        Text {
                            text: "⚠  Large Files (>100 MB)"
                            font.pixelSize: 13; font.weight: Font.Medium
                            color: "#FFB347"
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: App.largeFiles.length + " files"
                            font.pixelSize: 11; color: "#5060A0"
                        }
                    }

                    Repeater {
                        model: App.largeFiles
                        delegate: FileCard {
                            Layout.fillWidth: true
                            fileName: modelData.name
                            filePath: modelData.path
                            category: modelData.category
                            fileSize: modelData.sizeStr
                        }
                    }
                }
            }

            // ── Log panel ─────────────────────────────────────────
            LogPanel {
                Layout.fillWidth: true
                implicitHeight: 200
            }

            Item { height: 20 }
        }
    }
}
