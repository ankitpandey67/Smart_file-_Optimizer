import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: sidebar
    color: "#12122A"

    property int currentPage: 0
    signal pageRequested(int idx)

    // Thin accent strip on right edge
    Rectangle {
        anchors.right: parent.right
        anchors.top:   parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: "#2A2A45"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Logo / branding
        Rectangle {
            Layout.fillWidth: true
            height: 80
            color: "transparent"

            RowLayout {
                anchors.centerIn: parent
                spacing: 12

                // App icon
                Rectangle {
                    width: 36; height: 36; radius: 10
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#6C63FF" }
                        GradientStop { position: 1.0; color: "#43D3A0" }
                    }
                    Text {
                        anchors.centerIn: parent
                        text: "⚡"; font.pixelSize: 18; color: "white"
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "Smart File"
                        font.pixelSize: 13; font.weight: Font.Bold
                        color: "#E8E8F0"
                    }
                    Text {
                        text: "Optimizer"
                        font.pixelSize: 11
                        color: "#6C63FF"
                    }
                }
            }
        }

        // Divider
        Rectangle { Layout.fillWidth: true; height: 1; color: "#1E1E3A" }

        // Spacer
        Item { height: 12 }

        // Nav items
        Repeater {
            model: [
                {icon: "⊞",  label: "Dashboard",   idx: 0},
                {icon: "⊕",  label: "Scan",         idx: 1},
                {icon: "⊙",  label: "Organize",     idx: 2},
                {icon: "⊘",  label: "Duplicates",   idx: 3},
                {icon: "⚙",  label: "Settings",     idx: 4},
            ]

            delegate: NavItem {
                icon:     modelData.icon
                label:    modelData.label
                idx:      modelData.idx
                isActive: sidebar.currentPage === modelData.idx
                onClicked: sidebar.pageRequested(idx)
            }
        }

        // Spacer
        Item { Layout.fillHeight: true }

        // Bottom info
        Rectangle {
            Layout.fillWidth: true
            height: 56
            color: "transparent"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "v1.0.0"
                    font.pixelSize: 11
                    color: "#4A4A6A"
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: "Smart File Optimizer"
                    font.pixelSize: 10
                    color: "#3A3A5A"
                }
            }
        }
    }
}
