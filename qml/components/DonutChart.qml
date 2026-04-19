import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property var segments: []   // [{color, value, label}]
    property string centerText: ""
    property string centerSub:  ""
    implicitWidth: 200
    implicitHeight: 200

    // Compute total once
    property real total: {
        var t = 0;
        for (var i = 0; i < segments.length; i++) t += segments[i].value;
        return t > 0 ? t : 1;
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = height / 2;
            var R  = Math.min(width, height) / 2 - 10;
            var r  = R * 0.62;

            var start = -Math.PI / 2;

            for (var i = 0; i < root.segments.length; i++) {
                var seg = root.segments[i];
                if (seg.value <= 0) continue;
                var sweep = (seg.value / root.total) * 2 * Math.PI;
                var end   = start + sweep;

                ctx.beginPath();
                ctx.moveTo(cx + R * Math.cos(start), cy + R * Math.sin(start));
                ctx.arc(cx, cy, R, start, end);
                ctx.arc(cx, cy, r, end, start, true);
                ctx.closePath();
                ctx.fillStyle = seg.color;
                ctx.fill();

                // Gap between segments
                start = end + 0.015;
            }

            // Center hole
            ctx.beginPath();
            ctx.arc(cx, cy, r - 2, 0, 2 * Math.PI);
            ctx.fillStyle = "#1A1A35";
            ctx.fill();
        }
        onWidthChanged:  requestPaint()
        onHeightChanged: requestPaint()
    }

    // Re-paint when data changes
    onSegmentsChanged: canvas.requestPaint()

    // Center label
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 2

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.centerText
            font.pixelSize: 20
            font.weight: Font.Bold
            color: "#E8E8F0"
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.centerSub
            font.pixelSize: 10
            color: "#6070A0"
            visible: root.centerSub.length > 0
        }
    }
}
