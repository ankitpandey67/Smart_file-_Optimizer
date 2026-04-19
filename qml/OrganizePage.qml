import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Item {
    id: page

    // Action list model
    ListModel { id: actionModel }

    Connections {
        target: App.organizer
        function onActionPerformed(src, dst, dryRun, success) {
            var srcParts = src.split("/")
            var dstParts = dst.split("/")
            actionModel.insert(0, {
                srcName: srcParts[srcParts.length - 1],
                dstFolder: dstParts[dstParts.length - 2] || "",
                isDryRun: dryRun,
                isSuccess: success
            })
            if (actionModel.count > 300) actionModel.remove(300)
        }
        function onOrganizeFinished(moved, skipped, errors) {
            resultMoved.text   = moved.toString()
            resultSkipped.text = skipped.toString()
            resultErrors.text  = errors.toString()
            resultBar.visible  = true
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 20

        // ── Title ─────────────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            ColumnLayout {
                spacing: 4
                Text { text: "Organize"; font.pixelSize: 24; font.weight: Font.Bold; color: "#E8E8F0" }
                Text { text: "Move files into categorized subfolders"; font.pixelSize: 12; color: "#5060A0" }
            }
            Item { Layout.fillWidth: true }

            AnimatedButton {
                text: "↺ Undo Last"
                accent: "#5060A0"
                enabled: !App.organizer.running
                onClicked: App.undoOrganize()
            }
        }

        // ── Options row ───────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 70
            radius: 14
            color: "#1A1A35"
            border.color: "#22223A"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 24

                // Dry run toggle
                RowLayout {
                    spacing: 10
                    Rectangle {
                        id: dryToggle
                        width: 48; height: 26; radius: 13
                        property bool on: App.settings.dryRunDefault
                        color: on ? "#6C63FF" : "#2A2A45"
                        Behavior on color { ColorAnimation { duration: 200 } }

                        Rectangle {
                            width: 20; height: 20; radius: 10
                            anchors.verticalCenter: parent.verticalCenter
                            x: dryToggle.on ? parent.width - width - 3 : 3
                            color: "white"
                            Behavior on x { NumberAnimation { duration: 200 } }
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: App.settings.dryRunDefault = !App.settings.dryRunDefault
                        }
                    }
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Dry Run Mode"; font.pixelSize: 13; color: "#E8E8F0" }
                        Text { text: "Preview changes without moving files"; font.pixelSize: 11; color: "#5060A0" }
                    }
                }

                Rectangle { width: 1; height: 40; color: "#2A2A45" }

                // Info
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: App.totalFiles + " files ready to organize"
                        font.pixelSize: 13; color: "#C0C0E0"
                    }
                    Text {
                        text: "→ " + App.selectedFolder
                        font.pixelSize: 11; color: "#5060A0"
                        elide: Text.ElideLeft
                    }
                }

                Item { Layout.fillWidth: true }

                // Start button
                AnimatedButton {
                    text: App.organizer.running
                          ? "⟳ Organizing…"
                          : (App.settings.dryRunDefault ? "⊙ Preview" : "⊙ Organize Now")
                    accent: App.settings.dryRunDefault ? "#FFB347" : "#43D3A0"
                    enabled: App.totalFiles > 0 && !App.organizer.running
                    onClicked: App.organizeFiles(App.settings.dryRunDefault)
                }
            }
        }

        // ── Progress ──────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: 40
            radius: 10
            color: "#1A1A35"
            visible: App.organizer.running

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                Text {
                    text: "Organizing…  " + App.organizer.progress + "%"
                    font.pixelSize: 12; color: "#A0A0C0"
                }
                ProgressBar {
                    Layout.fillWidth: true
                    value: App.organizer.progress / 100
                    accentColor: "#43D3A0"
                }
            }
        }

        // ── Result summary ────────────────────────────────────────
        Rectangle {
            id: resultBar
            Layout.fillWidth: true
            height: 56
            radius: 12
            color: "#0F2A1A"
            border.color: "#43D3A0"
            border.width: 1
            visible: false

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 20

                Text { text: "✓  Complete"; font.pixelSize: 13; font.weight: Font.Medium; color: "#43D3A0" }

                Rectangle { width: 1; height: 30; color: "#1E4A2A" }

                RowLayout {
                    spacing: 6
                    Text { text: "Moved:"; font.pixelSize: 12; color: "#5070A0" }
                    Text { id: resultMoved; text: "0"; font.pixelSize: 14; font.weight: Font.Bold; color: "#43D3A0" }
                }
                RowLayout {
                    spacing: 6
                    Text { text: "Skipped:"; font.pixelSize: 12; color: "#5070A0" }
                    Text { id: resultSkipped; text: "0"; font.pixelSize: 14; font.weight: Font.Bold; color: "#FFB347" }
                }
                RowLayout {
                    spacing: 6
                    Text { text: "Errors:"; font.pixelSize: 12; color: "#5070A0" }
                    Text { id: resultErrors; text: "0"; font.pixelSize: 14; font.weight: Font.Bold; color: "#FF6584" }
                }

                Item { Layout.fillWidth: true }

                AnimatedButton {
                    text: "Dismiss"; small: true; accent: "#2A4A3A"
                    onClicked: resultBar.visible = false
                }
            }
        }

        // ── Action list ───────────────────────────────────────────
        RowLayout {
            Layout.fillWidth: true
            Text { text: "Actions"; font.pixelSize: 13; font.weight: Font.Medium; color: "#7080A0" }
            Item { Layout.fillWidth: true }
            Text {
                text: actionModel.count + " actions"
                font.pixelSize: 12; color: "#3A3A6A"
                visible: actionModel.count > 0
            }
            AnimatedButton {
                text: "Clear"; small: true; accent: "#2A2A45"
                visible: actionModel.count > 0
                onClicked: actionModel.clear()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: "#151530"
            border.color: "#1E1E3A"
            clip: true

            // Empty
            Text {
                anchors.centerIn: parent
                text: "No actions yet — run organize or preview"
                color: "#2A2A5A"; font.pixelSize: 13
                visible: actionModel.count === 0
            }

            ListView {
                anchors.fill: parent
                anchors.margins: 10
                model: actionModel
                spacing: 3
                clip: true
                visible: actionModel.count > 0

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    contentItem: Rectangle { radius: 2; color: "#3A3A6A"; implicitWidth: 4 }
                }

                delegate: Rectangle {
                    width: ListView.view.width
                    height: 40
                    radius: 8
                    color: index % 2 === 0 ? "#181832" : "transparent"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 10

                        // Status dot
                        Rectangle {
                            width: 8; height: 8; radius: 4
                            color: model.isDryRun ? "#FFB347"
                                 : model.isSuccess ? "#43D3A0" : "#FF6584"
                        }

                        // Dry run badge
                        Rectangle {
                            width: 36; height: 18; radius: 4
                            color: model.isDryRun ? "#2A2010" : "#102A20"
                            visible: true

                            Text {
                                anchors.centerIn: parent
                                text: model.isDryRun ? "DRY" : "DONE"
                                font.pixelSize: 9; font.weight: Font.Bold
                                color: model.isDryRun ? "#FFB347" : "#43D3A0"
                            }
                        }

                        Text {
                            Layout.fillWidth: true
                            text: model.srcName
                            font.pixelSize: 12; color: "#C0C0E0"
                            elide: Text.ElideMiddle
                        }

                        Text { text: "→"; color: "#3A3A6A"; font.pixelSize: 12 }

                        Rectangle {
                            height: 20; radius: 4
                            width: destText.implicitWidth + 12
                            color: "#1A2A1A"
                            Text {
                                id: destText
                                anchors.centerIn: parent
                                text: model.dstFolder
                                font.pixelSize: 11; color: "#43D3A0"
                            }
                        }
                    }
                }
            }
        }
    }
}
