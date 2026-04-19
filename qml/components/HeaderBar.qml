import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    color: "#12122A"
    
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#1E1E3A"
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 12

        // Folder path display
        Rectangle {
            Layout.fillWidth: true
            height: 38
            radius: 8
            color: "#1A1A35"
            border.color: folderMa.containsMouse ? "#6C63FF" : "#2A2A45"
            border.width: 1

            Behavior on border.color { ColorAnimation { duration: 200 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Text { text: "📁"; font.pixelSize: 14 }

                Text {
                    Layout.fillWidth: true
                    text: App.selectedFolder.length > 0 ? App.selectedFolder : "Click to select a folder…"
                    color: App.selectedFolder.length > 0 ? "#E8E8F0" : "#4A4A6A"
                    font.pixelSize: 13
                    elide: Text.ElideLeft
                }

                Text {
                    text: "Change"
                    color: "#6C63FF"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    visible: App.selectedFolder.length > 0
                }
            }

            MouseArea {
                id: folderMa
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: App.openFolderPicker()
            }
        }

        // Quick action: Scan
        AnimatedButton {
            text: App.scanner.scanning ? "⏹ Stop" : "⊕ Scan"
            accent: App.scanner.scanning ? "#FF6584" : "#6C63FF"
            onClicked: App.scanner.scanning ? App.cancelScan() : App.startScan()
        }

        // Quick action: Organize
        AnimatedButton {
            text: "⊙ Organize"
            accent: "#43D3A0"
            enabled: App.totalFiles > 0 && !App.organizer.running
            onClicked: App.organizeFiles(App.settings.dryRunDefault)
        }
    }
}
