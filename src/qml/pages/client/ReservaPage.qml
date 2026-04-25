import QtQuick 2.15

Item {
    id: page
    property var dataSource
    property var servicio: null
    property int mes: 1
    property int dia: -1
    property string hora: ""
    property bool confirmando: false

    function getDiasEnMes(m) {
        if (m === 1 || m === 3 || m === 5 || m === 7 || m === 8 || m === 10 || m === 12) return 31
        if (m === 4 || m === 6 || m === 9 || m === 11) return 30
        if (m === 2) {
            var anio = new Date().getFullYear()
            if ((anio % 4 === 0 && anio % 100 !== 0) || anio % 400 === 0) return 29
            return 28
        }
        return 30
    }

    property int diasEnMes: getDiasEnMes(mes)

    Component.onCompleted: {
        dataSource = window.dataLayer
        servicio = window.servicioActual
        console.log("ReservaPage, servicio:", servicio ? servicio.nombre : "null")
    }

    function getFechaActual() {
        var now = new Date()
        var dia = now.getDate()
        var mes = now.getMonth() + 1
        var anio = now.getFullYear()
        return dia + "/" + mes + "/" + anio
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
                        text: "Nueva Reserva"
                        font.pixelSize: 18
                        color: "#FFFFFF"
                    }
                }

                MouseArea {
                    width: 60
                    height: 50
                    onClicked: window.navigate("servicios")
                }
            }

            Rectangle {
                y: 50
                width: page.width
                height: 50
                color: "#141414"

                Row {
                    x: 16
                    y: 10
                    spacing: 12

                    Rectangle {
                        width: 50
                        height: 30
                        radius: 8
                        color: "#1A1A1A"

                        Text {
                            text: servicio ? servicio.icono : "✨"
                            font.pixelSize: 20
                            anchors.centerIn: parent
                        }
                    }

                    Column {
                        y: 2
                        spacing: 2

                        Text {
                            text: servicio ? servicio.nombre : "Selecciona un servicio"
                            font.pixelSize: 14
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Text {
                            text: servicio ? "$" + servicio.precio + " • " + servicio.duracion + " min" : ""
                            font.pixelSize: 12
                            color: "#D4AF37"
                        }
                    }
                }
            }
        }

        Flickable {
            y: 100
            width: page.width
            height: page.height - 200
            contentHeight: col.height

            Column {
                id: col
                width: page.width - 32
                x: 16
                spacing: 24

                Item { height: 10 }

                Text {
                    text: "Selecciona el mes"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#FFFFFF"
                }

                Item { height: 10 }

                Row {
                    spacing: 8
                    Repeater {
                        model: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
                        delegate: Rectangle {
                            width: 65
                            height: 35
                            radius: 8
                            color: (mes - 1) === index ? "#D4AF37" : "#141414"
                            border.width: 1
                            border.color: (mes - 1) === index ? "#D4AF37" : "#252525"

                            Text {
                                text: modelData
                                font.pixelSize: 12
                                font.bold: (mes - 1) === index
                                color: (mes - 1) === index ? "#0D0D0D" : "#CCCCCC"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    mes = index + 1
                                    console.log("Mes:", modelData)
                                }
                            }
                        }
                    }
                }

                Item { height: 20 }

                Text {
                    text: "Selecciona el día"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#FFFFFF"
                }

                Text {
                    text: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"][mes - 1]
                    font.pixelSize: 12
                    color: "#666666"
                }

                Item { height: 10 }

                Grid {
                    columns: 7
                    spacing: 8

                    Repeater {
                        model: page.diasEnMes
                        delegate: Rectangle {
                            width: 44
                            height: 44
                            radius: 22
                            color: dia === index ? "#D4AF37" : "#141414"
                            border.width: 1
                            border.color: dia === index ? "#D4AF37" : "#252525"

                            Text {
                                text: index + 1
                                font.pixelSize: 14
                                color: dia === index ? "#0D0D0D" : "#CCCCCC"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    dia = index
                                    console.log("Dia:", index + 1)
                                }
                            }
                        }
                    }
                }

                Item { height: 20 }

                Text {
                    text: "Selecciona el horario"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#FFFFFF"
                }

                Item { height: 10 }

                Grid {
                    columns: 4
                    spacing: 10

                    Repeater {
                        model: ["09:00", "10:00", "11:00", "12:00", "14:00", "15:00", "16:00", "17:00"]
                        delegate: Rectangle {
                            width: 75
                            height: 40
                            radius: 10
                            color: hora === modelData ? "#D4AF37" : "#141414"
                            border.width: 1
                            border.color: hora === modelData ? "#D4AF37" : "#252525"

                            Text {
                                text: modelData
                                font.pixelSize: 13
                                font.bold: hora === modelData
                                color: hora === modelData ? "#0D0D0D" : "#CCCCCC"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    hora = modelData
                                    console.log("Hora:", modelData)
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            width: page.width
            height: 90
            color: "#0D0D0D"
            anchors.bottom: parent.bottom

            Rectangle {
                width: page.width
                height: 1
                color: "#252525"
            }

            Column {
                x: 20
                y: 15
                spacing: 4

                Text {
                    text: servicio && dia >= 0 && hora ? "Total: $" + servicio.precio : "Complete todos los datos"
                    font.pixelSize: 14
                    color: "#666666"
                }
            }

            Rectangle {
                width: page.width - 40
                height: 54
                radius: 27
                x: 20
                y: 35
                color: (servicio && mes > 0 && dia >= 0 && hora) ? (confirmando ? "#666666" : "#D4AF37") : "#2A2A2A"
                gradient: (servicio && mes > 0 && dia >= 0 && hora && !confirmando) ? Gradient {
                    GradientStop { position: 0.0; color: "#D4AF37" }
                    GradientStop { position: 1.0; color: "#8B7355" }
                } : null

                Text {
                    text: confirmando ? "Confirmando..." : "CONFIRMAR RESERVA"
                    color: (servicio && mes > 0 && dia >= 0 && hora) ? "#0D0D0D" : "#555555"
                    font.bold: true
                    font.pixelSize: 14
                    letterSpacing: 1
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (servicio && mes > 0 && dia >= 0 && hora) {
                            confirmando = true
                            console.log("CONFIRMAR!")
                            var anioActual = new Date().getFullYear()
                            var fecha = anioActual + "-" + (mes < 10 ? "0" + mes : mes) + "-" + (dia + 1 < 10 ? "0" + (dia + 1) : (dia + 1))
                            var res = {
                                usuarioId: window.currentUser.id,
                                servicioId: servicio.id,
                                fecha: fecha,
                                hora: hora,
                                estado: "pendiente"
                            }
                            dataSource.addReserva(res)

                            window.navigate("misCitas")
                        }
                    }
                }
            }
        }
    }
}