import QtQuick 2.15

Rectangle {
    id: root
    anchors.fill: parent
    color: "#0D0D0DE8"
    visible: isSaving
    z: 10

    property bool isSaving: false

    Column {
        anchors.centerIn: parent
        spacing: 20

        // Timer para animar las tijeras
        Timer {
            id: tijerasTimer
            interval: 16
            repeat: true
            running: isSaving
            property real angle: 0
            onTriggered: {
                angle += 3
                if (angle >= 360) angle = 0
                tijera1.rotation = angle
                tijera2.rotation = angle
                tijera3.rotation = angle
            }
        }

        Row {
            spacing: 16
            anchors.horizontalCenter: parent.horizontalCenter

            Text { id: tijera1; text: "✂️"; font.pixelSize: 40 }
            Text { id: tijera2; text: "✂️"; font.pixelSize: 40 }
            Text { id: tijera3; text: "✂️"; font.pixelSize: 40 }
        }

        Text {
            text: "Guardando..."
            font.pixelSize: 18
            font.bold: true
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
