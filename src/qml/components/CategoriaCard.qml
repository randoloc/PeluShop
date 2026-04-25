import QtQuick 2.15

Item {
    property string titulo: ""
    property string imagen: ""
    property color color: "#1A1A1A"
    signal clicked

    Rectangle {
        width: parent.width
        height: parent.height
        radius: 12
        color: parent.color
        border.color: "#333333"
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 8
            Text {
                text: getIcon(imagen)
                font.pixelSize: 28
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: titulo
                font.pixelSize: 14
                font.bold: true
                color: "#E5E5E5"
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: clicked()
        }
    }

    function getIcon(cat) {
        switch(cat) {
            case "corte": return "✂️"
            case "color": return "🎨"
            case "tratamiento": return "💆"
            case "peinado": return "👩"
            case "manicure": return "💅"
            case "pedicure": return "🦶"
            default: return "💇"
        }
    }
}