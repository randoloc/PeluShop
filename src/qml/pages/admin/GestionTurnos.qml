import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var items: []

    Component.onCompleted: {
        dataSource = window.dataLayer
        items = dataSource.reservas
    }

    function count(estado) {
        var n = 0
        for (var i = 0; i < items.length; i++) {
            if (items[i].estado === estado) n++
        }
        return n
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
            height: 100
            color: "#0D0D0D"
            anchors.top: parent.top

            Rectangle {
                width: page.width
                height: 50
                color: "#0D0D0D"

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
                        text: "Gestión de Turnos"
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

            Row {
                y: 60
                x: 16
                spacing: 12

                Rectangle {
                    height: 32
                    radius: 16
                    color: "#D4AF37"

                    Text {
                        text: count("pendiente") + " Pend."
                        font.pixelSize: 12
                        color: "#0D0D0D"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    height: 32
                    radius: 16
                    color: "#4CAF50"

                    Text {
                        text: count("confirmada") + " Conf."
                        font.pixelSize: 12
                        color: "#0D0D0D"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    height: 32
                    radius: 16
                    color: "#666666"

                    Text {
                        text: count("completada") + " Comp."
                        font.pixelSize: 12
                        color: "#FFFFFF"
                        anchors.centerIn: parent
                    }
                }
            }
        }

        ListView {
            y: 100
            width: page.width
            height: page.height - 100
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
                    spacing: 12

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : "#2A2A2A"

                        Text {
                            text: "📅"
                            font.pixelSize: 18
                            anchors.centerIn: parent
                        }
                    }

                    Column {
                        y: 2
                        spacing: 4

                        Text {
                            text: modelData.usuarioId + " - " + modelData.servicioId
                            font.pixelSize: 13
                            color: "#FFFFFF"
                        }

                        Row {
                            spacing: 6

                            Text {
                                text: modelData.fecha + " " + modelData.hora
                                font.pixelSize: 12
                                color: "#CCCCCC"
                            }

                            Text {
                                text: "•"
                                color: "#4A4A4A"
                            }

                            Text {
                                text: modelData.estado
                                font.pixelSize: 11
                                color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : "#666666"
                            }
                        }
                    }
                }
            }
        }
    }
}