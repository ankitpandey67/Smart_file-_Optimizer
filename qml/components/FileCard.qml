import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: card
    property string fileName: "file.txt"
    property string filePath: ""
    property string category: "Others"
    property string fileSize: "0 KB"
    property string accent: App.categoryColor(category)

    implicitHeight: 44
    radius: 8
    color: ma.containsMouse ? "#1E1E40" : "#181832"
    border.color: ma.containsMouse ? accent : "transparent"
    border.width: 1

    Behavior on color { ColorAnimation { duration: 120 } }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 10

        // Category color dot
        Rectangle {
            width: 8; height: 8; radius: 4
            color: card.accent
        }

        // File icon by category
        Text {
            text: {
                switch(card.category) {
                case "Images":    return "🖼"
                case "Videos":    return "🎬"
                case "Documents": return "📄"
                case "Music":     return "🎵"
                case "Archives":  return "🗜"
                default:          return "📎"
                }
            }
            font.pixelSize: 15
        }

        // Name
        Text {
            Layout.fillWidth: true
            text: card.fileName
            font.pixelSize: 12
            color: "#C0C0E0"
            elide: Text.ElideMiddle
        }

        // Category tag
        Rectangle {
            height: 20; radius: 4
            width: catText.implicitWidth + 12
            color: Qt.rgba(
                parseInt(card.accent.slice(1,3), 16)/255,
                parseInt(card.accent.slice(3,5), 16)/255,
                parseInt(card.accent.slice(5,7), 16)/255,
                0.18)

            Text {
                id: catText
                anchors.centerIn: parent
                text: card.category
                font.pixelSize: 10
                color: card.accent
            }
        }

        // Size
        Text {
            text: card.fileSize
            font.pixelSize: 11
            color: "#5060A0"
            Layout.preferredWidth: 70
            horizontalAlignment: Text.AlignRight
        }
    }

    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true }
}
