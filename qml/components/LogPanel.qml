import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: panel
    color: "#111125"
    radius: 12
    border.color: "#1E1E3A"
    border.width: 1
    clip: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#16162E"
            radius: 12

            // Square bottom corners
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 12
                color: parent.color
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 10

                Text {
                    text: "▸ Activity Log"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: "#8080B0"
                    font.family: "monospace"
                }
                Item { Layout.fillWidth: true }

                Text {
                    text: LogModel.count + " entries"
                    font.pixelSize: 11
                    color: "#5050A0"
                }

                // Clear button
                Rectangle {
                    width: 52; height: 22; radius: 11
                    color: clearMa.containsMouse ? "#2A2A4A" : "transparent"
                    border.color: "#2A2A4A"; border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Clear"
                        font.pixelSize: 10
                        color: "#6070A0"
                    }
                    MouseArea {
                        id: clearMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: LogModel.clear()
                    }
                }
            }
        }

        // Log list
        ListView {
            id: logView
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: LogModel
            clip: true
            spacing: 0
            verticalLayoutDirection: ListView.TopToBottom

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                contentItem: Rectangle {
                    radius: 2
                    color: "#3A3A6A"
                    implicitWidth: 4
                }
            }

            delegate: Rectangle {
                width: logView.width
                height: 34
                color: index % 2 === 0 ? "transparent" : "#0D0D20"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 10
                    spacing: 10

                    // Timestamp
                    Text {
                        text: model.timestamp
                        font.pixelSize: 10
                        font.family: "monospace"
                        color: "#3A3A6A"
                        Layout.preferredWidth: 60
                    }

                    // Level badge
                    Rectangle {
                        width: 36; height: 16; radius: 4
                        color: {
                            switch(model.level) {
                            case 0: return "#1A2040"   // info
                            case 1: return "#2A1A10"   // warning
                            case 2: return "#102A20"   // success
                            case 3: return "#2A0A10"   // error
                            default: return "#1A1A3A"
                            }
                        }
                        Text {
                            anchors.centerIn: parent
                            text: model.levelName
                            font.pixelSize: 9
                            font.weight: Font.Bold
                            color: {
                                switch(model.level) {
                                case 0: return "#6C63FF"
                                case 1: return "#FFB347"
                                case 2: return "#43D3A0"
                                case 3: return "#FF6584"
                                default: return "#8080B0"
                                }
                            }
                        }
                    }

                    // Message
                    Text {
                        Layout.fillWidth: true
                        text: model.message + (model.detail.length > 0 ? "  —  " + model.detail : "")
                        font.pixelSize: 11
                        font.family: "monospace"
                        color: "#A0A0C0"
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
