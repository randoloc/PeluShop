import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var items: []

    Component.onCompleted: {
        dataSource = window.dataLayer
        items = dataSource.servicios
    }

    function getCategoriaIcon(cat) {
        if (cat === "corte") return "✂️"
        if (cat === "color") return "🎨"
        if (cat === "tratamiento") return "💆"
        return "✨"
    }

    Rectangle {
        anchors.fill: parent
        color: "#0D0D0D"

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0D0D0D" }
                GradientStop { position: 0.5; color: "#141414" }
                GradientStop { position: 1.0; color: "#0D0D0D" }
            }
        }

        Rectangle {
            width: page.width
            height: 50
            color: "#0D0D0D"
            anchors.top: parent.top

            Row {
                x: 16
                y: 15
                spacing: 8

                Text {
                    text: "←"
                    font.pixelSize: 20
                    color: "#D4AF37"
                }

                Text {
                    text: "Gestión de Servicios"
                    font.pixelSize: 18
                    color: "#FFFFFF"
                }
            }

            MouseArea {
                width: 60
                height: 50
                onClicked: window.navigate("admin")
            }
        }

        ListView {
            y: 50
            width: page.width
            height: page.height - 50
            model: items
            delegate: Rectangle {
                width: page.width
                height: 70
                color: "#141414"
                border.width: 1
                border.color: "#252525"

                Row {
                    x: 16
                    y: 15
                    spacing: 16

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: "#1A1A1A"

                        Text {
                            text: getCategoriaIcon(modelData.categoria)
                            font.pixelSize: 18
                            anchors.centerIn: parent
                        }
                    }

                    Column {
                        y: 2
                        spacing: 4

                        Text {
                            text: modelData.nombre
                            font.pixelSize: 14
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Row {
                            spacing: 6

                            Text {
                                text: "$" + modelData.precio
                                font.pixelSize: 12
                                color: "#D4AF37"
                            }

                            Text {
                                text: "•"
                                color: "#4A4A4A"
                            }

                            Text {
                                text: modelData.duracion + " min"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }
                    }
                }
            }
        }
    }
}