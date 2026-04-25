import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var user: null
    property var misReservas: []

    Component.onCompleted: {
        dataSource = window.dataLayer
        user = window.currentUser
        console.log("InicioPage, user:", user ? user.nombre : "null")
    }

    onVisibleChanged: {
        if (visible) {
            loadReservas()
        }
    }

    function loadReservas() {
        if (dataSource && user) {
            misReservas = dataSource.getReservasByUsuario(user.id)
        }
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
            height: 120
            color: "transparent"
            anchors.top: parent.top

            Rectangle {
                width: page.width
                height: 80
                color: "#0D0D0D"

                Text {
                    text: "BeautyBook"
                    font.family: "Georgia"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#FFFFFF"
                    x: 20
                    y: 40
                }

                Text {
                    text: user ? user.nombre : "Usuario"
                    font.pixelSize: 13
                    color: "#8B7355"
                    x: page.width - 100
                    y: 45
                }
            }

            Rectangle {
                width: page.width
                height: 40
                color: "transparent"

                Text {
                    text: "Inicio"
                    font.pixelSize: 12
                    color: "#666666"
                    x: 20
                    y: 12
                }
            }
        }

        Flickable {
            y: 120
            width: page.width
            height: page.height - 120
            contentHeight: col.height

            Column {
                id: col
                width: page.width - 40
                x: 20
                spacing: 24

                Item { height: 10 }

                Rectangle {
                    width: page.width - 40
                    height: 100
                    radius: 16
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Column {
                        x: 20
                        y: 20
                        spacing: 8

                        Text {
                            text: "Mis Citas"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        if (misReservas.length === 0) {
                            Text {
                                text: "No tienes citas programadas"
                                color: "#555555"
                                font.pixelSize: 13
                            }
                        }

                        Column {
                            spacing: 6
                            Repeater {
                                model: misReservas
                                delegate: Row {
                                    spacing: 8
                                    Rectangle {
                                        width: 4
                                        height: 4
                                        radius: 2
                                        color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : "#666666"
                                        y: 6
                                    }
                                    Text {
                                        text: modelData.fecha + " • " + modelData.hora
                                        color: "#CCCCCC"
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        text: "[" + modelData.estado + "]"
                                        color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : "#666666"
                                        font.pixelSize: 11
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: page.width - 40
                    height: 56
                    radius: 28
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: "+"
                            color: "#0D0D0D"
                            font.bold: true
                            font.pixelSize: 20
                        }

                        Text {
                            text: "Nueva Reserva"
                            color: "#0D0D0D"
                            font.bold: true
                            font.pixelSize: 15
                            letterSpacing: 0.5
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Click Reservar")
                            window.navigate("servicios")
                        }
                    }
                }

                Item { height: 10 }

                Text {
                    text: "ACCESO RÁPIDO"
                    font.pixelSize: 11
                    color: "#4A4A4A"
                    letterSpacing: 2
                }

                Item { height: 8 }

                Row {
                    spacing: 12

                    Rectangle {
                        width: (page.width - 40 - 12) / 2
                        height: 80
                        radius: 12
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "Servicios"
                                font.pixelSize: 14
                                color: "#D4AF37"
                            }

                            Text {
                                text: "Ver todos"
                                font.pixelSize: 11
                                color: "#555555"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: window.navigate("servicios")
                        }
                    }

                    Rectangle {
                        width: (page.width - 40 - 12) / 2
                        height: 80
                        radius: 12
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "Mis Citas"
                                font.pixelSize: 14
                                color: "#D4AF37"
                            }

                            Text {
                                text: misReservas.length + " actives"
                                font.pixelSize: 11
                                color: "#555555"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: window.navigate("reserva")
                        }
                    }
                }

                Item { height: 30 }

                Rectangle {
                    width: page.width - 40
                    height: 50
                    radius: 25
                    color: "#1A1A1A"
                    border.width: 1
                    border.color: "#2A2A2A"

                    Text {
                        text: "Cerrar Sesión"
                        color: "#666666"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Click Logout")
                            window.logoutUser()
                        }
                    }
                }

                Item { height: 40 }
            }
        }
    }
}