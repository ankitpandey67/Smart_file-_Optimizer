import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: navItem

    property string icon
    property string label
    property int idx
    property bool isActive: false
    signal clicked()

    Layout.fillWidth: true
    height: 48
    color: navItem.isActive ? "#1E1E40" : (ma.containsMouse ? "#181830" : "transparent")
    radius: 0

    Behavior on color { ColorAnimation { duration: 150 } }

    Rectangle {
        width: 3; height: 28; radius: 2
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        color: "#6C63FF"
        visible: navItem.isActive
        Behavior on visible { NumberAnimation { duration: 150 } }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 16
        spacing: 12

        Text {
            text: navItem.icon
            font.pixelSize: 16
            color: navItem.isActive ? "#6C63FF" : "#6070A0"
        }
        Text {
            text: navItem.label
            font.pixelSize: 13
            font.weight: navItem.isActive ? Font.Medium : Font.Normal
            color: navItem.isActive ? "#E8E8F0" : "#6070A0"
            Layout.fillWidth: true
        }
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: navItem.clicked()
    }
}
