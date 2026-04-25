import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var items: []
    property string filterCategoria: ""

    Component.onCompleted: {
        dataSource = window.dataLayer
        console.log("ServiciosPage loaded, dataSource:", !!dataSource)
        if (dataSource) {
            items = dataSource.servicios
            console.log("Servicios count:", items.length)
        }
    }

    function getCategoriaIcon(cat) {
        if (cat === "corte") return "✂️"
        if (cat === "color") return "🎨"
        if (cat === "tratamiento") return "💆"
        return "✨"
    }

    function getCategoriaNombre(cat) {
        if (cat === "corte") return "Cortes"
        if (cat === "color") return "Coloración"
        if (cat === "tratamiento") return "Tratamientos"
        return "Servicios"
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
                        text: "Servicios"
                        font.pixelSize: 18
                        color: "#FFFFFF"
                    }
                }

                MouseArea {
                    width: 60
                    height: 50
                    onClicked: window.navigate("inicio")
                }
            }

            Row {
                x: 16
                y: 60
                spacing: 8

                Rectangle {
                    height: 32
                    radius: 16
                    color: filterCategoria === "" ? "#D4AF37" : "#1A1A1A"
                    border.width: 1
                    border.color: filterCategoria === "" ? "#D4AF37" : "#2A2A2A"

                    Text {
                        text: "Todos"
                        font.pixelSize: 12
                        color: filterCategoria === "" ? "#0D0D0D" : "#8B7355"
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 0
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            filterCategoria = ""
                            items = dataSource.servicios
                        }
                    }
                }

                Repeater {
                    model: ["corte", "color", "tratamiento"]
                    delegate: Rectangle {
                        height: 32
                        radius: 16
                        color: filterCategoria === modelData ? "#D4AF37" : "#1A1A1A"
                        border.width: 1
                        border.color: filterCategoria === modelData ? "#D4AF37" : "#2A2A2A"

                        Text {
                            text: getCategoriaNombre(modelData)
                            font.pixelSize: 12
                            color: filterCategoria === modelData ? "#0D0D0D" : "#8B7355"
                            anchors.centerIn: parent
                            anchors.horizontalCenterOffset: 0
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                filterCategoria = modelData
                                var filtered = []
                                for (var i = 0; i < dataSource.servicios.length; i++) {
                                    if (dataSource.servicios[i].categoria === modelData) {
                                        filtered.push(dataSource.servicios[i])
                                    }
                                }
                                items = filtered
                            }
                        }
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
                height: 90
                color: "#141414"
                border.width: 1
                border.color: "#252525"

                Row {
                    x: 16
                    y: 20
                    spacing: 16

                    Rectangle {
                        width: 50
                        height: 50
                        radius: 12
                        color: "#1A1A1A"

                        Text {
                            text: getCategoriaIcon(modelData.categoria)
                            font.pixelSize: 22
                            anchors.centerIn: parent
                        }
                    }

                    Column {
                        y: 2
                        spacing: 4

                        Text {
                            text: modelData.nombre
                            font.pixelSize: 15
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Row {
                            spacing: 6

                            Text {
                                text: "$" + modelData.precio
                                font.pixelSize: 13
                                color: "#D4AF37"
                            }

                            Text {
                                text: "•"
                                color: "#4A4A4A"
                            }

                            Text {
                                text: modelData.duracion + " min"
                                color: "#666666"
                                font.pixelSize: 13
                            }
                        }

                        Text {
                            text: modelData.descripcion
                            color: "#555555"
                            font.pixelSize: 11
                        }
                    }
                }

                Rectangle {
                    width: 1
                    height: 70
                    color: "#252525"
                    x: page.width - 50
                    y: 10

                    Text {
                        text: "→"
                        font.pixelSize: 18
                        color: "#4A4A4A"
                        x: -8
                        y: 25
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Selected:", modelData.nombre)
                        window.servicioActual = modelData
                        window.navigate("reserva")
                    }
                }
            }
        }
    }
}