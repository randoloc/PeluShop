import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: galleryView
    property var fotos: []
    property bool isVisible: false

    Rectangle {
        anchors.fill: parent
        color: "#0D0D0D"
        visible: parent.isVisible

        Rectangle {
            width: parent.width
            height: 50
            color: "#0D0D0D"
            z: 10

            Row {
                x: 16; y: 15
                spacing: 8

                Text {
                    text: "<"
                    font.pixelSize: 20
                    color: "#D4AF37"
                }

                Text {
                    text: "Galeria"
                    font.pixelSize: 18
                    color: "white"
                }
            }

            MouseArea {
                width: 60; height: 50
                onClicked: parent.parent.parent.isVisible = false
            }
        }

        ListView {
            y: 60
            width: parent.width
            height: parent.height - 60
            visible: parent.isVisible
            model: parent.fotos

            delegate: Rectangle {
                width: parent.width
                height: 300
                color: "#141414"

                Rectangle {
                    width: parent.width - 32
                    height: 260
                    x: 16
                    radius: 12
                    color: "#1A1A1A"

                    Image {
                        id: galleryImage
                        source: modelData
                        fillMode: Image.PreserveAspectCrop
                        width: parent.width - 32
                        height: 260
                        x: 16
                        radius: 12
                        smooth: true
                        asynchronous: true

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "#141414"
                            visible: parent.status === Image.Loading
                        }

                        Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "#1A1A1A"
                            visible: parent.status === Image.Error
                        }

                        Text {
                            text: "Cargando..."
                            color: "#555"
                            visible: parent.status === Image.Loading
                            anchors.centerIn: parent
                        }

                        Text {
                            text: "Error al cargar"
                            color: "#E53935"
                            visible: parent.status === Image.Error
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            Text {
                text: "No hay fotos disponibles"
                color: "#555"
                font.pixelSize: 14
                anchors.centerIn: parent
                visible: parent.model.length === 0
            }
        }

        Rectangle {
            y: parent.height - 100
            width: parent.width
            height: 80
            color: "#0D0D0D"
            visible: parent.isVisible

            Rectangle {
                width: 335; height: 54
                radius: 27
                x: 20
                color: "#1A1A1A"
                border.width: 1
                border.color: "#D4AF37"

                Text {
                    text: "+ Agregar Foto (URL)"
                    color: "#D4AF37"
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Agregar foto desde URL")
                    }
                }
            }
        }
    }
}