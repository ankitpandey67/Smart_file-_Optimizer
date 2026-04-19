import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: toggleRow

    property string label: ""
    property string subtitle: ""
    property bool checked: false
    signal toggled(bool checked)

    Layout.fillWidth: true
    spacing: 12

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 2
        Text { text: toggleRow.label; font.pixelSize: 13; color: "#C0C0E0" }
        Text {
            text: toggleRow.subtitle
            font.pixelSize: 11
            color: "#5060A0"
            visible: toggleRow.subtitle.length > 0
        }
    }

    Rectangle {
        id: tog
        width: 48; height: 26; radius: 13
        color: toggleRow.checked ? "#6C63FF" : "#2A2A45"
        Behavior on color { ColorAnimation { duration: 200 } }

        Rectangle {
            width: 20; height: 20; radius: 10
            anchors.verticalCenter: parent.verticalCenter
            x: tog.checked ? parent.width - width - 3 : 3
            color: "white"
            Behavior on x { NumberAnimation { duration: 200 } }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: toggleRow.toggled(!toggleRow.checked)
        }
    }
}
