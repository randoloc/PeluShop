import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var items: []

    Component.onCompleted: {
        dataSource = window.dataLayer
        items = dataSource.usuarios
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
                    text: "Gestión de Usuarios"
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

        Flickable {
            y: 50
            width: page.width
            height: page.height - 50
            contentHeight: col.height

            Column {
                id: col
                width: page.width - 40
                x: 20
                spacing: 16

                Item { height: 20 }

                Rectangle {
                    width: page.width - 40
                    height: 54
                    radius: 27
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }

                    Text {
                        text: "+ AGREGAR USUARIO"
                        color: "#0D0D0D"
                        font.bold: true
                        font.pixelSize: 14
                        letterSpacing: 1
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: console.log("Agregar usuario")
                    }
                }

                Item { height: 30 }

                Text {
                    text: "USUARIOS REGISTRADOS"
                    font.pixelSize: 11
                    color: "#4A4A4A"
                    letterSpacing: 2
                }

                Item { height: 10 }

                ListView {
                    width: page.width - 40
                    height: page.height - 250
                    model: items
                    delegate: Rectangle {
                        width: page.width - 40
                        height: 60
                        radius: 12
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
                                radius: 20
                                color: "#1A1A1A"

                                Text {
                                    text: modelData.nombre.charAt(0)
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: "#D4AF37"
                                    anchors.centerIn: parent
                                }
                            }

                            Column {
                                y: 5
                                spacing: 2

                                Text {
                                    text: modelData.nombre
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#FFFFFF"
                                }

                                Text {
                                    text: modelData.email
                                    font.pixelSize: 11
                                    color: "#555555"
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}