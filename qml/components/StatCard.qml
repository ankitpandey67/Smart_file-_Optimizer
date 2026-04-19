import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: card
    property string label:   "Stat"
    property string value:   "0"
    property string icon:    "📊"
    property string accent:  "#6C63FF"
    property string subtitle: ""

    implicitHeight: 110
    radius: 14
    color: "#1A1A35"
    border.color: ma.containsMouse ? accent : "#22223A"
    border.width: 1

    Behavior on border.color { ColorAnimation { duration: 200 } }

    // Top accent strip
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 3
        radius: 3
        color: accent
        opacity: 0.8
    }

    // Subtle background glow
    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6
        radius: width / 2
        color: card.accent
        opacity: 0.04
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 16

        // Icon circle
        Rectangle {
            width: 46; height: 46; radius: 12
            color: card.accent
            opacity: 0.18

            Text {
                anchors.centerIn: parent
                text: card.icon
                font.pixelSize: 22
            }
        }
        // Overlay icon on top of the colored circle
        Text {
            x: 9; y: 9  // will be positioned relative to parent anyway
            anchors.left: parent.left
            anchors.leftMargin: 21
            anchors.verticalCenter: parent.verticalCenter
            text: card.icon
            font.pixelSize: 22
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                text: card.label
                font.pixelSize: 11
                font.weight: Font.Medium
                color: "#6070A0"
                font.letterSpacing: 1
                font.capitalization: Font.AllUppercase
            }

            Text {
                text: card.value
                font.pixelSize: 26
                font.weight: Font.Bold
                color: "#E8E8F0"
            }

            Text {
                text: card.subtitle
                font.pixelSize: 11
                color: "#5060A0"
                visible: card.subtitle.length > 0
            }
        }
    }

    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true }
}
