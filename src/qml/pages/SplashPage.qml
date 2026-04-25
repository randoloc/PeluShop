import QtQuick 2.15

Rectangle {
    id: splashRoot
    color: "#0D0D0D"

    Rectangle {
        id: gradientOverlay
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0D0D0D" }
            GradientStop { position: 0.5; color: "#1A1410" }
            GradientStop { position: 1.0; color: "#0D0D0D" }
        }
        opacity: 0.5
    }

    Rectangle {
        id: circleBg
        width: 160
        height: 160
        radius: 80
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#D4AF37" }
            GradientStop { position: 1.0; color: "#8B7355" }
        }
        anchors.centerIn: parent
        scale: 0.0
        opacity: 0.0
    }

    Rectangle {
        id: innerCircle
        width: 140
        height: 140
        radius: 70
        color: "#0D0D0D"
        anchors.centerIn: circleBg
        scale: 0.0
        opacity: 0.0
    }

    Text {
        id: logoFallback
        text: "B"
        font.family: "Georgia"
        font.pixelSize: 80
        font.bold: true
        color: "#D4AF37"
        anchors.centerIn: circleBg
        scale: 0.0
        opacity: 0.0
    }

    Column {
        id: titleCol
        anchors.centerIn: parent
        y: parent.height / 2 + 120
        spacing: 12
        opacity: 0.0

        Text {
            text: "BeautyBook"
            font.family: "Georgia"
            font.pixelSize: 36
            font.bold: true
            color: "#FFFFFF"
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: "B"
                font.family: "Georgia"
                font.pixelSize: 36
                font.bold: true
                color: "#D4AF37"
            }
        }

        Text {
            text: "Belleza y Elegancia"
            font.pixelSize: 13
            font.styleName: "Italic"
            color: "#8B7355"
            anchors.horizontalCenter: parent.horizontalCenter
            letterSpacing: 2
        }
    }

    Rectangle {
        id: loadingBar
        width: 0
        height: 2
        radius: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#8B7355" }
            GradientStop { position: 0.5; color: "#D4AF37" }
            GradientStop { position: 1.0; color: "#8B7355" }
        }
        anchors.centerIn: parent
        y: parent.height / 2 + 210
    }

    Rectangle {
        id: glowCircle
        width: 200
        height: 200
        radius: 100
        color: "transparent"
        border.color: "#D4AF37"
        border.width: 1
        opacity: 0.0
        anchors.centerIn: circleBg
    }

    property var onComplete: null

    function whenDone(cb) {
        onComplete = cb
    }

    Component.onCompleted: {
        step1.start()
    }

    SequentialAnimation {
        id: step1

        NumberAnimation {
            target: circleBg
            property: "scale"
            to: 1.0
            duration: 800
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: circleBg
            property: "opacity"
            to: 1.0
            duration: 500
        }

        ScriptAction { script: step2.start() }
    }

    SequentialAnimation {
        id: step2

        NumberAnimation {
            target: innerCircle
            property: "scale"
            to: 1.0
            duration: 500
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: innerCircle
            property: "opacity"
            to: 1.0
            duration: 400
        }

        PauseAnimation { duration: 200 }

        ScriptAction { script: step2b.start() }
    }

    SequentialAnimation {
        id: step2b

        NumberAnimation {
            target: logoFallback
            property: "scale"
            to: 1.0
            duration: 600
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: logoFallback
            property: "opacity"
            to: 1.0
            duration: 400
        }

        PauseAnimation { duration: 300 }

        ScriptAction { script: step3.start() }
    }

    SequentialAnimation {
        id: step3

        NumberAnimation {
            target: titleCol
            property: "opacity"
            to: 1.0
            duration: 600
        }

        PauseAnimation { duration: 300 }

        ScriptAction { script: step4.start() }
    }

    SequentialAnimation {
        id: step4

        NumberAnimation {
            target: loadingBar
            property: "width"
            from: 0
            to: 180
            duration: 1800
            easing.type: Easing.InOutSine
        }

        PauseAnimation { duration: 600 }

        ScriptAction { script: step5.start() }
    }

    SequentialAnimation {
        id: step5

        NumberAnimation {
            target: splashRoot
            property: "opacity"
            from: 1.0
            to: 0.0
            duration: 500
        }

        ScriptAction { script: { if (onComplete) onComplete() } }
    }

    SequentialAnimation {
        id: glowPulse

        NumberAnimation {
            target: glowCircle
            property: "opacity"
            from: 0.4
            to: 0.0
            duration: 1200
        }

        NumberAnimation {
            target: glowCircle
            property: "scale"
            from: 1.0
            to: 1.3
            duration: 1200
        }

        running: false
        loops: 2
    }
}
