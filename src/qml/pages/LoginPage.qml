        color: "#0D0D0D"

        // Splash
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "splash"

            Rectangle {
                width: 160; height: 160
                radius: 80
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#D4AF37" }
                    GradientStop { position: 1.0; color: "#8B7355" }
                }
                anchors.centerIn: parent
            }

            Text {
                text: "B"
                font.family: "Georgia"
                font.pixelSize: 80
                font.bold: true
                color: "#0D0D0D"
                anchors.centerIn: parent
            }

            Text {
                text: "BeautyBook"
                font.family: "Georgia"
                font.pixelSize: 30
                font.bold: true
                color: "white"
                anchors.centerIn: parent
                y: 100
            }

            Timer {
                interval: 2500
                running: true
                onTriggered: window.currentPage = "login"
            }
        }

        // Login
        Rectangle {
            width: 375; height: 812
