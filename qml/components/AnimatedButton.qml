import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: btn
    property string text:   "Button"
    property string accent: "#6C63FF"
    property bool   small:  false
    signal clicked()

    implicitWidth:  textItem.implicitWidth + (small ? 24 : 32)
    implicitHeight: small ? 32 : 38
    radius: height / 2

    color: ma.pressed    ? Qt.darker(accent, 1.3)
         : ma.containsMouse ? Qt.lighter(accent, 1.15)
         : accent

    opacity: enabled ? 1.0 : 0.4

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }

    scale: ma.pressed ? 0.95 : 1.0

    // Glow
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: btn.accent
        border.width: ma.containsMouse ? 0 : 0
        opacity: 0.4
    }

    Text {
        id: textItem
        anchors.centerIn: parent
        text: btn.text
        color: "white"
        font.pixelSize: btn.small ? 12 : 13
        font.weight: Font.Medium
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: if (btn.enabled) btn.clicked()
    }
}
