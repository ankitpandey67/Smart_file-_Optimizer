import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import "components"

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 800
    minimumWidth: 1000
    minimumHeight: 640
    title: "Smart File Optimizer"

    Material.theme: Material.Dark
    Material.accent: "#6C63FF"
    Material.primary: "#1A1A2E"

    // ── Colour palette ─────────────────────────────────────────────
    QtObject {
        id: theme
        readonly property color bg:         "#0F0F1A"
        readonly property color surface:    "#1A1A2E"
        readonly property color surface2:   "#16213E"
        readonly property color card:       "#1E1E35"
        readonly property color border:     "#2A2A45"
        readonly property color accent:     "#6C63FF"
        readonly property color accent2:    "#43D3A0"
        readonly property color textPrimary:"#E8E8F0"
        readonly property color textMuted:  "#7070A0"
        readonly property color danger:     "#FF6584"
        readonly property color warning:    "#FFB347"
        readonly property color success:    "#43D3A0"
    }

    // ── Notification toast ─────────────────────────────────────────
    property string notifType: "info"
    property string notifMsg:  ""
    property bool   notifVisible: false

    Connections {
        target: App
        function onNotification(type, message) {
            root.notifType    = type
            root.notifMsg     = message
            root.notifVisible = true
            notifTimer.restart()
        }
    }

    Timer { id: notifTimer; interval: 3500; onTriggered: root.notifVisible = false }

    // ── Background ─────────────────────────────────────────────────
    background: Rectangle { color: theme.bg }

    // ── Root layout ────────────────────────────────────────────────
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Sidebar
        Sidebar {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 220
            currentPage: stackView.currentIndex
            onPageRequested: stackView.currentIndex = idx
        }

        // Main content area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            HeaderBar {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
            }

            // Page stack
            StackLayout {
                id: stackView
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                Dashboard   { }
                ScanPage    { }
                OrganizePage{ }
                DuplicatesPage { }
                SettingsPage{ }
            }
        }
    }

    // ── Toast notification ─────────────────────────────────────────
    Rectangle {
        id: toastBg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        width: toastRow.implicitWidth + 48
        height: 48
        radius: 24
        visible: root.notifVisible
        opacity: root.notifVisible ? 1 : 0
        z: 9999

        color: {
            switch (root.notifType) {
            case "success": return theme.success
            case "error":   return theme.danger
            case "warning": return theme.warning
            default:        return theme.accent
            }
        }

        Behavior on opacity { NumberAnimation { duration: 250 } }

        Row {
            id: toastRow
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: {
                    switch (root.notifType) {
                    case "success": return "✓"
                    case "error":   return "✕"
                    case "warning": return "⚠"
                    default:        return "ℹ"
                    }
                }
                color: "white"
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: root.notifMsg
                color: "white"
                font.pixelSize: 14
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
