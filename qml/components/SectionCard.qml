import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: sectionCard

    property string title: ""
    default property alias children: innerCol.data

    implicitHeight: headerRow.height + innerCol.implicitHeight + 32
    radius: 14
    color: "#1A1A35"
    border.color: "#22223A"

    ColumnLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 20
        spacing: 14

        RowLayout {
            id: headerRow
            Layout.fillWidth: true
            Text {
                text: sectionCard.title
                font.pixelSize: 12
                font.weight: Font.Medium
                color: "#6C63FF"
                font.letterSpacing: 1
                font.capitalization: Font.AllUppercase
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: "#2A2A45" }
        }

        ColumnLayout { id: innerCol; Layout.fillWidth: true; spacing: 12 }
    }
}
