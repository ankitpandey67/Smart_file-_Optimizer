import QtQuick 2.15

Item {
    id: root
    property real value: 0       // 0.0 – 1.0
    property string label: ""
    property color  accentColor: "#6C63FF"
    property color  accent2:     "#43D3A0"

    implicitHeight: 10

    // Track
    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: "#1E1E3A"
    }

    // Fill
    Rectangle {
        id: fill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: Math.max(height, parent.width * Math.min(root.value, 1.0))
        radius: height / 2

        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: root.accentColor }
            GradientStop { position: 1.0; color: root.accent2 }
        }

        // Animated shimmer
        Rectangle {
            id: shimmer
            width: 60; height: parent.height
            radius: height / 2
            color: "white"
            opacity: 0.15
            x: -width

            NumberAnimation on x {
                from: -shimmer.width
                to:   fill.width + shimmer.width
                duration: 1400
                loops: Animation.Infinite
                running: root.value > 0 && root.value < 1
                easing.type: Easing.Linear
            }
        }
    }
}
