import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var user: null

    Component.onCompleted: {
        dataSource = window.dataLayer
        user = window.currentUser
    }

    function getCountUsers() { return dataSource ? dataSource.usuarios.length : 0 }
    function getCountServicios() { return dataSource ? dataSource.servicios.length : 0 }
    function getCountReservas() { return dataSource ? dataSource.reservas.length : 0 }

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
                height: 60
                color: "#0D0D0D"

                Text {
                    text: "BeautyBook"
                    font.family: "Georgia"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#FFFFFF"
                    x: 20
                    y: 20
                }

                Row {
                    x: page.width - 90
                    y: 22
                    spacing: 6

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: "#4CAF50"
                    }

                    Text {
                        text: user ? user.nombre : "Admin"
                        font.pixelSize: 13
                        color: "#8B7355"
                    }
                }
            }

            Rectangle {
                y: 60
                width: page.width
                height: 40
                color: "transparent"

                Text {
                    text: "Panel de Administración"
                    font.pixelSize: 12
                    color: "#666666"
                    x: 20
                    y: 12
                }
            }
        }

        Flickable {
            y: 100
            width: page.width
            height: page.height - 100
            contentHeight: col.height

            Column {
                id: col
                width: page.width - 40
                x: 20
                spacing: 20

                Item { height: 10 }

                Row {
                    spacing: 12

                    Rectangle {
                        width: (page.width - 40 - 24) / 3
                        height: 90
                        radius: 16
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            x: 16
                            y: 16
                            spacing: 8

                            Text {
                                text: getCountUsers()
                                font.pixelSize: 28
                                font.bold: true
                                color: "#D4AF37"
                            }

                            Text {
                                text: "Usuarios"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }
                    }

                    Rectangle {
                        width: (page.width - 40 - 24) / 3
                        height: 90
                        radius: 16
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            x: 16
                            y: 16
                            spacing: 8

                            Text {
                                text: getCountServicios()
                                font.pixelSize: 28
                                font.bold: true
                                color: "#4CAF50"
                            }

                            Text {
                                text: "Servicios"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }
                    }

                    Rectangle {
                        width: (page.width - 40 - 24) / 3
                        height: 90
                        radius: 16
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            x: 16
                            y: 16
                            spacing: 8

                            Text {
                                text: getCountReservas()
                                font.pixelSize: 28
                                font.bold: true
                                color: "#2196F3"
                            }

                            Text {
                                text: "Citas"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }
                    }
                }

                Item { height: 10 }

                Text {
                    text: "ADMINISTRACIÓN"
                    font.pixelSize: 11
                    color: "#4A4A4A"
                    letterSpacing: 2
                }

                Item { height: 8 }

                Rectangle {
                    width: page.width - 40
                    height: 70
                    radius: 14
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Row {
                        x: 20
                        y: 20
                        spacing: 16

                        Rectangle {
                            width: 40
                            height: 40
                            radius: 10
                            color: "#1A1A1A"

                            Text {
                                text: "✂️"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            y: 5
                            spacing: 4

                            Text {
                                text: "Gestión de Servicios"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#FFFFFF"
                            }

                            Text {
                                text: "Agregar, editar o eliminar servicios"
                                font.pixelSize: 11
                                color: "#555555"
                            }
                        }

                        Text {
                            text: "→"
                            font.pixelSize: 20
                            color: "#4A4A4A"
                            x: page.width - 120
                            y: 20
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Click servicios")
                            window.navigate("gestionServicios")
                        }
                    }
                }

                Rectangle {
                    width: page.width - 40
                    height: 70
                    radius: 14
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Row {
                        x: 20
                        y: 20
                        spacing: 16

                        Rectangle {
                            width: 40
                            height: 40
                            radius: 10
                            color: "#1A1A1A"

                            Text {
                                text: "📅"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            y: 5
                            spacing: 4

                            Text {
                                text: "Gestión de Turnos"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#FFFFFF"
                            }

                            Text {
                                text: "Ver y gestionar reservas"
                                font.pixelSize: 11
                                color: "#555555"
                            }
                        }

                        Text {
                            text: "→"
                            font.pixelSize: 20
                            color: "#4A4A4A"
                            x: page.width - 120
                            y: 20
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Click turnos")
                            window.navigate("gestionTurnos")
                        }
                    }
                }

                Rectangle {
                    width: page.width - 40
                    height: 70
                    radius: 14
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Row {
                        x: 20
                        y: 20
                        spacing: 16

                        Rectangle {
                            width: 40
                            height: 40
                            radius: 10
                            color: "#1A1A1A"

                            Text {
                                text: "👥"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            y: 5
                            spacing: 4

                            Text {
                                text: "Gestión de Usuarios"
                                font.pixelSize: 15
                                font.bold: true
                                color: "#FFFFFF"
                            }

                            Text {
                                text: "Administrar clientes"
                                font.pixelSize: 11
                                color: "#555555"
                            }
                        }

                        Text {
                            text: "→"
                            font.pixelSize: 20
                            color: "#4A4A4A"
                            x: page.width - 120
                            y: 20
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Click usuarios")
                            window.navigate("gestionUsuarios")
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
                            console.log("Click logout")
                            window.logoutUser()
                        }
                    }
                }

                Item { height: 40 }
            }
        }
    }
}