import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.0

ApplicationWindow {
    id: window
    width: 375
    height: 812
    visible: true
    title: "PeluShop"
    color: "#0D0D0D"

    property QtObject dataLayer: DataLayer {}
    property QtObject syncMgr: syncManager
    SyncManager {
        id: syncManager
    }
    property var currentUser: null
    property string currentPage: "splash"
    property string autoFillEmail: ""
    property string tempAdminEmail: ""
    property string tempAdminPassword: ""
    property bool showTempPassword: false
    property var selectedService: null
    property int selectedDia: -1
    property string selectedHora: ""
    property var galleryService: null
    property bool showGallery: false
    property int selDia: 1
    property int selMes: 1
property int selAnio: 1990
property string currentNegocioId: ""
    property bool hasNegocio: false
    property bool isEditing: false
    property var diasTrabajoString: "lunes,martes,miercoles,jueves,viernes"
    property int duracionCita: 45
    property var negocioDataTemp: ({})

    function navigate(page) {
        currentPage = page
        if (page === "inicio" && window.dataLayer && window.currentUser) {
            window.dataLayer.loadReservas ? window.dataLayer.loadReservas() : null
        }
    }

    function selectService(service) {
        selectedService = service
        selectedDia = -1
        selectedHora = ""
    }

    function doLogin(user) {
        if (user.mustChangePassword) {
            currentUser = user
            currentPage = "changePassword"
        } else if (user.rol === "admin") {
            currentUser = user
            currentPage = "admin"
        } else if (user.birthday === "" || user.birthday === undefined) {
            currentUser = user
            currentPage = "birthday"
        } else {
            currentUser = user
            currentPage = "inicio"
        }
    }

    function logoutUser() {
        currentUser = null
        currentPage = "login"
    }

    Rectangle {
        width: 375
        height: 812
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
                text: "PeluShop"
                font.family: "Georgia"
                font.pixelSize: 30
                font.bold: true
                color: "white"
                anchors.centerIn: parent
                y: 100
            }

            Timer {
                interval: 100
                running: true
                repeat: true
                onTriggered: {
                    if (syncMgr && syncMgr.initialized) {
                            running = false
                        }
                    }
                }
            }

            Timer {
                interval: 5000
                running: true
                onTriggered: {
                    running = false
                    if (currentPage === "splash") {
                        if (syncMgr && syncMgr.initialized) {
                            syncMgr.checkNegocioConfigurado()
                        } else {
                            console.log("SyncManager timeout, going to crearNegocio")
                            currentPage = "crearNegocio"
                        }
                    }
                }
            }
        }

        // Login
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "login"

            Column {
                width: 375
                spacing: 0
                anchors.top: parent.top
                anchors.topMargin: 100

                Text {
                    text: "B"
                    font.family: "Georgia"
                    font.pixelSize: 60
                    font.bold: true
                    color: "#D4AF37"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "PeluShop"
                    font.family: "Georgia"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "BELLEZA Y ELEGANCIA"
                    font.pixelSize: 10
                    color: "#8B7355"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 50 }

                Column {
                    width: 327
                    x: 24
                    spacing: 20

                    Text {
                        text: "Bienvenido"
                        font.pixelSize: 22
                        font.bold: true
                        color: "white"
                    }

                    Text {
                        text: "Ingresa tus credenciales"
                        font.pixelSize: 13
                        color: "#666666"
                    }

                    Item { height: 10 }

                    Rectangle {
                        width: 327
                        height: 56
                        radius: 12
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        TextInput {
                            id: txtEmail
                            anchors.fill: parent
                            anchors.leftMargin: 18
                            color: "white"
                            font.pixelSize: 15
                            onVisibleChanged: {
                                if (visible && window.autoFillEmail) {
                                    text = window.autoFillEmail
                                    window.autoFillEmail = ""
                                }
                            }
                        }

                        Text {
                            text: "Correo electronico"
                            color: "#555555"
                            font.pixelSize: 14
                            visible: txtEmail.text === ""
                            x: 18; y: 18
                        }
                    }

                    Item { height: 10 }

                    Rectangle {
                        width: 327
                        height: 56
                        radius: 12
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        TextInput {
                            id: txtPass
                            anchors.fill: parent
                            anchors.leftMargin: 18
                            echoMode: TextInput.Password
                            color: "white"
                            font.pixelSize: 15
                        }

                        Text {
                            text: "Contrasena"
                            color: "#555555"
                            font.pixelSize: 14
                            visible: txtPass.text === ""
                            x: 18; y: 18
                        }
                    }

                    Text {
                        id: errorText
                        text: ""
                        color: "#E53935"
                        font.pixelSize: 12
                    }

                    Item { height: 5 }

                    Rectangle {
                        width: 327
                        height: 54
                        radius: 27
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#D4AF37" }
                            GradientStop { position: 1.0; color: "#8B7355" }
                        }

                        Text {
                            text: "INICIAR SESION"
                            color: "#0D0D0D"
                            font.bold: true
                            font.pixelSize: 14
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var email = txtEmail.text.trim()
                                var pass = txtPass.text

                                if (!email) {
                                    errorText.text = "Ingresa tu correo"
                                    return
                                }
                                if (email.indexOf("@") < 0) {
                                    errorText.text = "Correo invalido"
                                    return
                                }
                                if (pass.length < 6) {
                                    errorText.text = "Minimo 6 caracteres"
                                    return
                                }

                                errorText.text = "Conectando..."

                                var sm = window.syncManager
                                var negocioId = window.currentNegocioId

                                if (sm && negocioId) {
                                    sm.loginUsuario(negocioId, email, pass, function(success, usuario) {
                                        if (success) {
                                            var user = {
                                                id: usuario.id,
                                                email: usuario.email,
                                                nombre: usuario.nombre,
                                                rol: usuario.rol,
                                                birthday: usuario.birthday || "",
                                                negocioId: usuario.negocioId,
                                                mustChangePassword: usuario.mustChangePassword || false
                                            }
                                            window.doLogin(user)
                                        } else {
                                            errorText.text = "Correo o contraseña incorrectos"
                                        }
                                    })
                                } else {
                                    errorText.text = "Error de conexion"
                                }
                            }
                        }
                    }

                    Item { height: 20 }

                    Column {
                        spacing: 4
                        Text {
                            text: "Cuenta de prueba:"
                            color: "#555555"
                            font.pixelSize: 11
                        }
                        Text {
                            text: "admin@beautybook.com (Admin)"
                            color: "#8B7355"
                            font.pixelSize: 11
                        }
                        Text {
                            text: "cualquier@email.com (Cliente)"
                            color: "#8B7355"
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }

        // Crear Negocio (solo primera vez)
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "crearNegocio"

            Column {
                width: 375
                spacing: 0
                anchors.top: parent.top
                anchors.topMargin: 80

                Text {
                    text: "B"
                    font.family: "Georgia"
                    font.pixelSize: 50
                    font.bold: true
                    color: "#D4AF37"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Crear tu Salon"
                    font.family: "Georgia"
                    font.pixelSize: 26
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Configura tu negocio para comenzar"
                    font.pixelSize: 13
                    color: "#666666"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 40 }

                Column {
                    width: 327
                    x: 24
                    spacing: 16

                    Text {
                        text: "Nombre del salon"
                        font.pixelSize: 12
                        color: "#8B7355"
                    }

                    Rectangle {
                        width: 327
                        height: 50
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        TextInput {
                            id: txtNombreNegocio
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Text {
                        text: "Telefono"
                        font.pixelSize: 12
                        color: "#8B7355"
                    }

                    Rectangle {
                        width: 327
                        height: 50
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        TextInput {
                            id: txtTelefonoNegocio
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Text {
                        text: "Direccion"
                        font.pixelSize: 12
                        color: "#8B7355"
                    }

                    Rectangle {
                        width: 327
                        height: 50
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        TextInput {
                            id: txtDireccionNegocio
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Text {
                        text: "Email del Administrador"
                        font.pixelSize: 12
                        color: "#8B7355"
                    }

                    Rectangle {
                        width: 327
                        height: 50
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        TextInput {
                            id: txtEmailAdmin
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            color: "white"
                            font.pixelSize: 15
                        }
                    }

                    Text {
                        text: "Logo del negocio (opcional)"
                        font.pixelSize: 12
                        color: "#8B7355"
                    }

                    Rectangle {
                        width: 327
                        height: 50
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"

                        Text {
                            id: txtLogoPath
                            anchors.fill: parent
                            anchors.margins: 16
                            color: txtLogoPath.text === "" ? "#555" : "white"
                            font.pixelSize: 14
                            verticalAlignment: Text.AlignVCenter
                            text: ""
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: fileDialog.open()
                        }
                    }

                    // Logo preview
                    Rectangle {
                        visible: txtLogoPath.text !== ""
                        width: 100; height: 100
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#2A2A2A"
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            anchors.fill: parent
                            anchors.margins: 8
                            source: txtLogoPath.text !== "" ? "file://" + txtLogoPath.text : ""
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    Text {
                        id: errorNegocio
                        text: ""
                        color: "#E53935"
                        font.pixelSize: 12
                    }

                    Item { height: 10 }

                    Rectangle {
                        width: 327
                        height: 54
                        radius: 27
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#D4AF37" }
                            GradientStop { position: 1.0; color: "#8B7355" }
                        }

                        Text {
                            text: "CREAR SALON"
                            color: "#0D0D0D"
                            font.bold: true
                            font.pixelSize: 14
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            id: btnCrearSalon
                            anchors.fill: parent
                            onClicked: {
                                var nombre = txtNombreNegocio.text.trim()
                                if (!nombre) {
                                    errorNegocio.text = "Ingresa el nombre del salon"
                                    return
                                }

                                var telefono = txtTelefonoNegocio.text.trim()
                                var direccion = txtDireccionNegocio.text.trim()
                                var emailAdmin = txtEmailAdmin.text.trim()

                                console.log("Creando negocio:", nombre)
                                errorNegocio.text = "Creando..."

                                var sm = syncMgr
                                console.log("SyncManager:", !!sm, "initialized:", sm ? sm.initialized : false)

                                if (sm) {
                                    negocioDataTemp = {
                                        nombre: nombre,
                                        telefono: telefono,
                                        direccion: direccion,
                                        emailAdmin: emailAdmin,
                                        logoPath: txtLogoPath.text !== "" ? txtLogoPath.text : ""
                                    }
                                    currentPage = "configurarNegocio"
                                } else {
                                    errorNegocio.text = "Error: SyncManager no disponible"
                                }
                            }
                        }
                    }
                }
            }

        // FileDialog for logo selection (Qt.labs.platform)
        FileDialog {
            id: fileDialog
            title: "Seleccionar logo"
            nameFilters: ["Image files (*.png *.jpg *.jpeg *.svg)"]
            onAccepted: {
                if (fileDialog.file !== null) {
                    var path = fileDialog.file.toString().replace("file://", "")
                    txtLogoPath.text = path
                    txtLogoPath.color = "white"
                }
            }
        }
        }

        // Configurar Negocio (Step 2 - Onboarding)
        Rectangle {
            id: configurarNegocioPage
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "configurarNegocio"
            property bool isSaving: false

            Flickable {
                width: 375
                height: 812
                contentHeight: contenidoConfic.height + 40

                Column {
                    id: contenidoConfic
                    width: 375
                    spacing: 0
                    anchors.top: parent.top
                    anchors.topMargin: 60

                    Row {
                        spacing: 10
                        x: 16

                        Text {
                            text: "<"
                            font.pixelSize: 20
                            color: "#D4AF37"
                        }

                        Text {
                            text: "Configurar Salon"
                            font.pixelSize: 18
                            color: "white"
                        }
                    }

                    Text {
                        text: "Paso 2 de 2 - Personaliza tu negocio"
                        font.pixelSize: 12
                        color: "#666"
                        x: 16
                        anchors.topMargin: 8
                    }

                    Item { height: 30 }

                    Column {
                        width: 327
                        x: 24
                        spacing: 16

                        Text {
                            text: "Descripcion (opcional)"
                            font.pixelSize: 12
                            color: "#8B7355"
                        }

                        Rectangle {
                            width: 327
                            height: 80
                            radius: 10
                            color: "#141414"
                            border.width: 1
                            border.color: "#2A2A2A"

                            TextEdit {
                                id: txtDescripcion
                                anchors.fill: parent
                                anchors.margins: 12
                                color: "white"
                                font.pixelSize: 14
                                wrapMode: TextEdit.Wrap
                            }

                            Text {
                                text: "Breve descripcion de tu salon..."
                                color: "#555"
                                font.pixelSize: 14
                                anchors.margins: 16
                                visible: txtDescripcion.text === ""
                                anchors.top: parent.top
                                anchors.topMargin: 16
                            }
                        }

                        Text {
                            text: "Horario de atencion"
                            font.pixelSize: 12
                            color: "#8B7355"
                        }

                        Row {
                            spacing: 10
                            width: 327

                            Column {
                                width: 150

                                Text {
                                    text: "Apertura"
                                    font.pixelSize: 11
                                    color: "#666"
                                }

                                Rectangle {
                                    width: 150
                                    height: 44
                                    radius: 10
                                    color: "#141414"
                                    border.width: 1
                                    border.color: "#2A2A2A"

                                    TextInput {
                                        id: txtHoraApertura
                                        anchors.fill: parent
                                        anchors.leftMargin: 12
                                        color: "white"
                                        font.pixelSize: 14
                                        inputMask: "00:00"
                                        text: "09:00"
                                    }
                                }
                            }

                            Column {
                                width: 150

                                Text {
                                    text: "Cierre"
                                    font.pixelSize: 11
                                    color: "#666"
                                }

                                Rectangle {
                                    width: 150
                                    height: 44
                                    radius: 10
                                    color: "#141414"
                                    border.width: 1
                                    border.color: "#2A2A2A"

                                    TextInput {
                                        id: txtHoraCierre
                                        anchors.fill: parent
                                        anchors.leftMargin: 12
                                        color: "white"
                                        font.pixelSize: 14
                                        inputMask: "00:00"
                                        text: "18:00"
                                    }
                                }
                            }
                        }

                        Text {
                            text: "Dias de trabajo"
                            font.pixelSize: 12
                            color: "#8B7355"
                        }

                        Row {
                            spacing: 8
                            width: 327

                            Repeater {
                                model: [
                                    {dia: "L", clave: "lunes"},
                                    {dia: "M", clave: "martes"},
                                    {dia: "X", clave: "miercoles"},
                                    {dia: "J", clave: "jueves"},
                                    {dia: "V", clave: "viernes"},
                                    {dia: "S", clave: "sabado"},
                                    {dia: "D", clave: "domingo"}
                                ]

                                delegate: Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 20
                                    color: diasTrabajoString.includes(modelData.clave) ? "#D4AF37" : "#1A1A1A"
                                    border.width: 1
                                    border.color: diasTrabajoString.includes(modelData.clave) ? "#D4AF37" : "#2A2A2A"

                                    Text {
                                        text: modelData.dia
                                        color: diasTrabajoString.includes(modelData.clave) ? "#0D0D0D" : "#666"
                                        font.bold: true
                                        anchors.centerIn: parent
                                        font.pixelSize: 14
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (diasTrabajoString.includes(modelData.clave)) {
                                                diasTrabajoString = diasTrabajoString.replace(modelData.clave, "").replace(",,", ",")
                                                if (diasTrabajoString.charAt(0) === ",") diasTrabajoString = diasTrabajoString.substring(1)
                                                if (diasTrabajoString.charAt(diasTrabajoString.length - 1) === ",") diasTrabajoString = diasTrabajoString.substring(0, diasTrabajoString.length - 1)
                                            } else {
                                                diasTrabajoString = diasTrabajoString === "" ? modelData.clave : diasTrabajoString + "," + modelData.clave
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Text {
                            text: "Duracion por defecto de cita"
                            font.pixelSize: 12
                            color: "#8B7355"
                        }

                        Row {
                            spacing: 10

                            Repeater {
                                model: [30, 45, 60, 90]

                                delegate: Rectangle {
                                    width: 70
                                    height: 40
                                    radius: 10
                                    color: duracionCita === modelData ? "#D4AF37" : "#1A1A1A"
                                    border.width: 1
                                    border.color: duracionCita === modelData ? "#D4AF37" : "#2A2A2A"

                                    Text {
                                        text: modelData + " min"
                                        color: duracionCita === modelData ? "#0D0D0D" : "#666"
                                        font.pixelSize: 12
                                        anchors.centerIn: parent
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: duracionCita = modelData
                                    }
                                }
                            }
                        }

                        Text {
                            text: "Notas del salon (opcional)"
                            font.pixelSize: 12
                            color: "#8B7355"
                        }

                        Rectangle {
                            width: 327
                            height: 60
                            radius: 10
                            color: "#141414"
                            border.width: 1
                            border.color: "#2A2A2A"

                            TextInput {
                                id: txtNotas
                                anchors.fill: parent
                                anchors.leftMargin: 12
                                anchors.topMargin: 8
                                color: "white"
                                font.pixelSize: 14
                            }

                            Text {
                                text: "Ej: Solo citas previas"
                                color: "#555"
                                font.pixelSize: 14
                                anchors.leftMargin: 16
                                anchors.topMargin: 14
                                visible: txtNotas.text === ""
                            }
                        }

                        Text {
                            id: errorConfigurar
                            text: ""
                            color: "#E53935"
                            font.pixelSize: 12
                        }

                        Item { height: 20 }

                        Rectangle {
                            width: 327
                            height: 54
                            radius: 27
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#D4AF37" }
                                GradientStop { position: 1.0; color: "#8B7355" }
                            }

                            Text {
                                text: "GUARDAR Y CONTINUAR"
                                color: "#0D0D0D"
                                font.bold: true
                                font.pixelSize: 14
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (diasTrabajoString === "") {
                                        errorConfigurar.text = "Selecciona al menos un dia"
                                        return
                                    }

                                        configurarNegocioPage.isSaving = true
                                     var sm = syncManager
                                     if (sm && Object.keys(negocioDataTemp).length > 0) {
                                         var datosExtra = {
                                             nombre: negocioDataTemp.nombre,
                                             telefono: negocioDataTemp.telefono,
                                             direccion: negocioDataTemp.direccion,
                                             descripcion: txtDescripcion.text.trim(),
                                             horaApertura: txtHoraApertura.text,
                                             horaCierre: txtHoraCierre.text,
                                             diasLaborales: diasTrabajoString,
                                             duracionCita: duracionCita,
                                             notas: txtNotas.text.trim(),
                                             logoPath: negocioDataTemp.logoPath || ""
                                         }

                                         sm.crearNegocioCompleto(datosExtra, function(success, returnedId) {
                                             configurarNegocioPage.isSaving = false
                                             if (success && returnedId) {
                                                 window.currentNegocioId = returnedId
                                                 window.hasNegocio = true
                                                 // Generate temp password and save admin data
                                                 if (negocioDataTemp.emailAdmin) {
                                                     var adminEmail = negocioDataTemp.emailAdmin
                                                     window.tempAdminEmail = adminEmail
                                                     // Generate random temp password
                                                     var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
                                                     var pass = ""
                                                     for (var i = 0; i < 8; i++) {
                                                         pass += chars.charAt(Math.floor(Math.random() * chars.length))
                                                     }
                                                     window.tempAdminPassword = pass
                                                     // Create admin user without password in Supabase for now
                                                     sm.crearUsuario(returnedId, adminEmail.split("@")[0], adminEmail, "admin", function(success2, nuevoUsuario) {
                                                         if (success2) {
                                                             window.showTempPassword = true
                                                             currentPage = "showTempPassword"
                                                         } else {
                                                             errorConfigurar.text = "Error al crear admin"
                                                         }
                                                     })
                                                 } else {
                                                     currentPage = "login"
                                                 }
                                             } else {
                                                 errorConfigurar.text = "Error al guardar"
                                             }
                                         })
                                     } else {
                                         configurarNegocioPage.isSaving = false
                                     }
                                }
                            }
                        }

                Item { height: 40 }
                    }
                }

                // Loading overlay con tijeras giratorias
                LoadingOverlay {
                    isSaving: configurarNegocioPage.isSaving
                }
            }
        }

        // Show Temp Password Page
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "showTempPassword"

            Column {
                width: 375
                spacing: 20
                anchors.centerIn: parent

                Text {
                    text: "B"
                    font.family: "Georgia"
                    font.pixelSize: 80
                    color: "#8B7355"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "PeluShop"
                    font.family: "Georgia"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 20 }

                Text {
                    text: "Tu contraseña temporal"
                    font.pixelSize: 22
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Guarda esta contraseña, la necesitarás para tu primer inicio de sesión"
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    width: 300
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: 300; height: 60
                    color: "#1A1A1A"
                    radius: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.color: "#8B7355"
                    border.width: 2

                    Row {
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: window.tempAdminPassword
                            font.pixelSize: 24
                            font.bold: true
                            color: "#8B7355"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            id: copyBtn
                            width: 80; height: 36
                            color: copyMA.pressed ? "#5A4F3F" : "#8B7355"
                            radius: 18
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                id: copyBtnText
                                text: "Copiar"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                id: copyMA
                                anchors.fill: parent
                                onClicked: {
                                    console.log("=== COPY CLICKED ===")
                                    Clipboard.text = window.tempAdminPassword
                                    console.log("Clipboard now:", Clipboard.text)
                                    copyFeedback.text = "Copiado!"
                                    copyBtnText.text = "Copiado"
                                    copyFeedbackTimer.restart()
                                }
                            }
                        }
                    }
                }

                Text {
                    id: copyFeedback
                    text: ""
                    color: "#4CAF50"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Timer {
                    id: copyFeedbackTimer
                    interval: 2000
                    onTriggered: {
                        copyFeedback.text = ""
                        copyBtnText.text = "Copiar"
                    }
                }

                Text {
                    text: "Email: " + window.tempAdminEmail
                    font.pixelSize: 16
                    color: "#CCCCCC"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 20 }

                Rectangle {
                    width: 200; height: 50
                    color: "#8B7355"
                    radius: 25
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Continuar al login"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            window.autoFillEmail = window.tempAdminEmail
                            currentPage = "login"
                        }
                    }
                }
            }
        }

        // Change Password Page (first login)

                Text {
                    text: "PeluShop"
                    font.family: "Georgia"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 20 }

                Text {
                    text: "Tu contraseña temporal"
                    font.pixelSize: 22
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Guarda esta contraseña, la necesitarás para tu primer inicio de sesión"
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    width: 300
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: 300; height: 60
                    color: "#1A1A1A"
                    radius: 8
                    anchors.horizontalCenter: parent.horizontalCenter
                    border.color: "#8B7355"
                    border.width: 2

                    Row {
                        anchors.centerIn: parent
                        spacing: 15

                        Text {
                            text: window.tempAdminPassword
                            font.pixelSize: 24
                            font.bold: true
                            color: "#8B7355"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Rectangle {
                            width: 80; height: 36
                            color: copyMA.pressed ? "#5A4F3F" : "#8B7355"
                            radius: 18
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Copiar"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                id: copyMA
                                anchors.fill: parent
                                onClicked: {
                                    console.log("=== COPY CLICKED ===")
                                    Clipboard.text = window.tempAdminPassword
                                    console.log("Clipboard:", Clipboard.text)
                                    copyFeedback.text = "Copiado!"
                                    copyBtnText.text = "Copiado"
                                    copyFeedbackTimer.restart()
                                }
                            }
                        }
                    }
                }

                Text {
                    id: copyFeedback
                    text: ""
                    color: "#4CAF50"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Timer {
                    id: copyFeedbackTimer
                    interval: 2000
                    onTriggered: {
                        copyFeedback.text = ""
                        copyBtnText.text = "Copiar"
                    }
                }

                        Rectangle {
                            width: 80; height: 36
                            color: copyMA.pressed ? "#5A4F3F" : "#8B7355"
                            radius: 18
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Copiar"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                id: copyMA
                                anchors.fill: parent
                                onClicked: {
                                    console.log("=== COPIANDO PASSWORD ===")
                                    Clipboard.text = window.tempAdminPassword
                                    console.log("Clipboard.text:", Clipboard.text)
                                    copyFeedback.text = "Copiado!"
                                    copyFeedbackTimer.restart()
                                }
                            }
                        }
                    }
                }

                Text {
                    id: copyFeedback
                    text: ""
                    color: "#4CAF50"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Timer {
                    id: copyFeedbackTimer
                    interval: 2000
                    onTriggered: copyFeedback.text = ""
                }

                        Rectangle {
                            width: 80; height: 36
                            color: copyMA.pressed ? "#5A4F3F" : "#8B7355"
                            radius: 18
                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                text: "Copiar"
                                color: "white"
                                font.pixelSize: 14
                                font.bold: true
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                id: copyMA
                                anchors.fill: parent
                                onClicked: {
                                    console.log("=== COPIANDO PASSWORD ===")
                                    Clipboard.text = window.tempAdminPassword
                                    console.log("Clipboard text ahora:", Clipboard.text)
                                    window._copyCount = (window._copyCount || 0) + 1
                                    copyFeedback.text = "Copiado (" + window._copyCount + ")!"
                                    copyFeedbackTimer.restart()
                                }
                            }
                        }
                    }
                }

                Text {
                    id: copyFeedback
                    text: ""
                    color: "#4CAF50"
                    font.pixelSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Timer {
                    id: copyFeedbackTimer
                    interval: 2000
                    onTriggered: copyFeedback.text = ""
                }

                Text {
                    text: "Email: " + window.tempAdminEmail
                    font.pixelSize: 16
                    color: "#CCCCCC"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 20 }

                Rectangle {
                    width: 200; height: 50
                    color: "#8B7355"
                    radius: 25
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Continuar al login"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            window.autoFillEmail = window.tempAdminEmail
                            currentPage = "login"
                        }
                    }
                }
            }
        }

        // Change Password Page (first login)
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "changePassword"

            Column {
                width: 375
                spacing: 20
                anchors.centerIn: parent

                Text {
                    text: "PeluShop"
                    font.family: "Georgia"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Cambio de contraseña requerido"
                    font.pixelSize: 18
                    color: "#8B7355"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Por seguridad, debes cambiar tu contraseña temporal"
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    spacing: 8
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Nueva contraseña"
                        color: "#8B7355"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        width: 300; height: 50
                        color: "#1A1A1A"
                        radius: 8
                        border.color: "#8B7355"
                        border.width: 1

                        TextInput {
                            id: newPassInput
                            anchors.fill: parent
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: 16
                            echoMode: TextInput.Password
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Column {
                    spacing: 8
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Confirmar contraseña"
                        color: "#8B7355"
                        font.pixelSize: 14
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Rectangle {
                        width: 300; height: 50
                        color: "#1A1A1A"
                        radius: 8
                        border.color: "#8B7355"
                        border.width: 1

                        TextInput {
                            id: confirmPassInput
                            anchors.fill: parent
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: 16
                            echoMode: TextInput.Password
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Text {
                    id: changePassError
                    text: ""
                    color: "#E53935"
                    font.pixelSize: 13
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Rectangle {
                    width: 200; height: 50
                    color: newPassInput.text.length >= 6 && newPassInput.text === confirmPassInput.text ? "#8B7355" : "#333333"
                    radius: 25
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Cambiar contraseña"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (newPassInput.text.length < 6) {
                                changePassError.text = "Minimo 6 caracteres"
                                return
                            }
                            if (newPassInput.text !== confirmPassInput.text) {
                                changePassError.text = "Las contraseñas no coinciden"
                                return
                            }
                            if (window.syncManager && window.currentUser) {
                                window.syncManager.changePassword(window.currentUser.id, newPassInput.text, function(success) {
                                    if (success) {
                                        window.currentUser.mustChangePassword = false
                                        // Navigate based on role
                                        if (window.currentUser.rol === "admin") {
                                            currentPage = "admin"
                                        } else {
                                            currentPage = "inicio"
                                        }
                                    } else {
                                        changePassError.text = "Error al cambiar contraseña"
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }

        // Inicio (Cliente)
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "inicio"

            Column {
                width: 375
                spacing: 20
                anchors.centerIn: parent

                Text {
                    text: "PeluShop"
                    font.family: "Georgia"
                    font.pixelSize: 24
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Bienvenido"
                    color: "#8B7355"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 30 }

                Rectangle {
                    width: 300; height: 56
                    radius: 28
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "+ Nueva Reserva"
                        color: "#0D0D0D"
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.currentPage = "servicios"
                    }
                }

                Item { height: 10 }

                Rectangle {
                    width: 300; height: 60
                    radius: 12
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Mis Citas"
                        color: "white"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.currentPage = "misCitas"
                    }
                }

                Item { height: 30 }

                Rectangle {
                    width: 200; height: 50
                    radius: 25
                    color: "#1A1A1A"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Cerrar Sesion"
                        color: "#666"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.logoutUser()
                    }
                }
            }
        }

        // Birthday Registration
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "birthday"

            property int byear: 1990
            property int bmonth: 1
            property int bday: 1

            Column {
                width: 375
                spacing: 15
                anchors.centerIn: parent

                Text {
                    text: "Bienvenido!"
                    font.family: "Georgia"
                    font.pixelSize: 28
                    font.bold: true
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Completa tu perfil"
                    font.pixelSize: 14
                    color: "#8B7355"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Item { height: 20 }

                Text {
                    text: "Número de teléfono"
                    font.pixelSize: 16
                    color: "white"
                    x: 20
                }

                Text {
                    text: "Used to confirm or cancel your appointment"
                    font.pixelSize: 11
                    color: "#666666"
                    x: 20
                }

                Rectangle {
                    width: 327; height: 44
                    radius: 8
                    color: "#141414"
                    border.width: 1
                    border.color: "#D4AF37"
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextInput {
                        id: txtTelefono
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        color: "white"
                        font.pixelSize: 14
                        inputMask: "+00 000 000 0000"
                    }
                }

                Rectangle {
                    width: 200; height: 36
                    radius: 18
                    color: "#1A1A1A"
                    border.width: 1
                    border.color: "#252525"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "Detectar de SIM"
                        font.pixelSize: 12
                        color: "#D4AF37"
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var simNumbers = ["+34600000000", "+34600000001", "+34600000002"]
                            var randomNum = simNumbers[Math.floor(Math.random() * simNumbers.length)]
                            txtTelefono.text = randomNum
                        }
                    }
                }

                Item { height: 10 }

                Text {
                    text: "Cuál es tu fecha de nacimiento?"
                    font.pixelSize: 16
                    color: "white"
                    x: 20
                }

                Row {
                    spacing: 8
                    anchors.horizontalCenter: parent.horizontalCenter

                    Column {
                        Text {
                            text: "Día"
                            color: "#666666"
                            font.pixelSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Rectangle {
                            width: 70; height: 100
                            radius: 8
                            color: "#141414"
                            border.width: 1
                            border.color: "#252525"

                            ListView {
                                width: 70; height: 100
                                clip: true
                                model: 31
                                delegate: Rectangle {
                                    width: 70; height: 30
                                    color: index + 1 === selDia ? "#D4AF37" : "transparent"
                                    Text {
                                        text: index + 1
                                        color: index + 1 === selDia ? "#0D0D0D" : "#888888"
                                        font.pixelSize: 14
                                        anchors.centerIn: parent
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: selDia = index + 1
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        Text {
                            text: "Mes"
                            color: "#666666"
                            font.pixelSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Rectangle {
                            width: 80; height: 100
                            radius: 8
                            color: "#141414"
                            border.width: 1
                            border.color: "#252525"

                            ListView {
                                width: 80; height: 100
                                clip: true
                                model: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"]
                                delegate: Rectangle {
                                    width: 80; height: 30
                                    color: index + 1 === selMes ? "#D4AF37" : "transparent"
                                    Text {
                                        text: modelData
                                        color: index + 1 === selMes ? "#0D0D0D" : "#888888"
                                        font.pixelSize: 14
                                        anchors.centerIn: parent
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: selMes = index + 1
                                    }
                                }
                            }
                        }
                    }

                    Column {
                        Text {
                            text: "Año"
                            color: "#666666"
                            font.pixelSize: 10
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        Rectangle {
                            width: 80; height: 100
                            radius: 8
                            color: "#141414"
                            border.width: 1
                            border.color: "#252525"

                            ListView {
                                width: 80; height: 100
                                clip: true
                                model: 80
                                delegate: Rectangle {
                                    width: 80; height: 30
                                    color: (1950 + index) === selAnio ? "#D4AF37" : "transparent"
                                    Text {
                                        text: 1950 + index
                                        color: (1950 + index) === selAnio ? "#0D0D0D" : "#888888"
                                        font.pixelSize: 14
                                        anchors.centerIn: parent
                                    }
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: selAnio = 1950 + index
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    text: "Lo usamos para enviarte promociones especiales!"
                    font.pixelSize: 12
                    color: "#666"
                    x: 20
                }

                Item { height: 20 }

                Rectangle {
                    width: 300; height: 50
                    radius: 25
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "CONTINUAR"
                        color: "#0D0D0D"
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var mm = selMes < 10 ? "0" + selMes : selMes
                            var dd = selDia < 10 ? "0" + selDia : selDia
                            var selectedDate = selAnio + "-" + mm + "-" + dd
                            window.dataLayer.updateUsuarioBirthday(window.currentUser.id, selectedDate)
                            window.dataLayer.updateUsuarioTelefono(window.currentUser.id, txtTelefono.text)
                            window.currentUser.birthday = selectedDate
                            window.currentUser.telefono = txtTelefono.text
                            window.currentPage = "inicio"
                        }
                    }
                }
            }
        }

        // Admin
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "admin"

            Rectangle {
                width: 375; height: 60
                color: "#0D0D0D"

                Text {
                    text: "PeluShop"
                    font.family: "Georgia"
                    font.pixelSize: 22
                    font.bold: true
                    color: "white"
                    x: 20; y: 20
                }

                Row {
                    x: 280; y: 22
                    spacing: 6
                    Rectangle {
                        width: 8; height: 8
                        radius: 4
                        color: "#4CAF50"
                    }
                    Text {
                        text: "Admin"
                        font.pixelSize: 13
                        color: "#8B7355"
                    }
                }
            }

            Column {
                width: 335
                x: 20
                y: 80
                spacing: 20

                Row {
                    spacing: 12

                    Rectangle {
                        width: 105; height: 90
                        radius: 16
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            x: 16; y: 20
                            Text {
                                text: window.dataLayer.usuarios.length
                                font.pixelSize: 28
                                font.bold: true
                                color: "#D4AF37"
                            }
                            Text {
                                text: "Usuarios"
                                font.pixelSize: 12
                                color: "#666"
                            }
                        }
                    }

                    Rectangle {
                        width: 105; height: 90
                        radius: 16
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            x: 16; y: 20
                            Text {
                                text: window.dataLayer.servicios.length
                                font.pixelSize: 28
                                font.bold: true
                                color: "#4CAF50"
                            }
                            Text {
                                text: "Servicios"
                                font.pixelSize: 12
                                color: "#666"
                            }
                        }
                    }

                    Rectangle {
                        width: 105; height: 90
                        radius: 16
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Column {
                            x: 16; y: 20
                            Text {
                                text: window.dataLayer.reservas.length
                                font.pixelSize: 28
                                font.bold: true
                                color: "#2196F3"
                            }
                            Text {
                                text: "Citas"
                                font.pixelSize: 12
                                color: "#666"
                            }
                        }
                    }
                }

                Text {
                    text: "ADMINISTRACION"
                    font.pixelSize: 11
                    color: "#4A4A4A"
                }

                Rectangle {
                    width: 335; height: 70
                    radius: 14
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Row {
                        x: 20; y: 20
                        spacing: 12

                        Rectangle {
                            width: 40; height: 40
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
                            Text {
                                text: "Gestion de Turnos"
                                font.pixelSize: 15
                                font.bold: true
                                color: "white"
                            }
                            Text {
                                text: "Ver y gestionar reservas"
                                font.pixelSize: 11
                                color: "#555"
                            }
                        }

                        Text {
                            text: ">"
                            font.pixelSize: 20
                            color: "#4A4A4A"
                            x: 290; y: 20
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.currentPage = "gestionTurnos"
                    }
                }

                Rectangle {
                    width: 335; height: 70
                    radius: 14
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Row {
                        x: 20; y: 20
                        spacing: 12

                        Rectangle {
                            width: 40; height: 40
                            radius: 10
                            color: "#1A1A1A"

                            Text {
                                text: "🎨"
                                font.pixelSize: 20
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            y: 5
                            Text {
                                text: "Gestion de Servicios"
                                font.pixelSize: 15
                                font.bold: true
                                color: "white"
                            }
                            Text {
                                text: "Agregar, editar o eliminar"
                                font.pixelSize: 11
                                color: "#555"
                            }
                        }

                        Text {
                            text: ">"
                            font.pixelSize: 20
                            color: "#4A4A4A"
                            x: 290; y: 20
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.currentPage = "gestionServicios"
                    }
                }

                Item { height: 20 }

                Rectangle {
                    width: 335; height: 50
                    radius: 25
                    color: "#1A1A1A"
                    border.width: 1
                    border.color: "#2A2A2A"

                    Text {
                        text: "Cerrar Sesion"
                        color: "#666"
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.logoutUser()
                    }
                }
            }
        }

        // Gestion Turnos (with confirm/cancel)
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "gestionTurnos"

            property string selectedReservaId: ""
            property var showConfirmDialog: false
            property var showCancelDialog: false
            property string cancelMotivo: ""

            Rectangle {
                width: 375; height: 50
                color: "#0D0D0D"

                Row {
                    x: 16; y: 15
                    spacing: 8

                    Text {
                        text: "<"
                        font.pixelSize: 20
                        color: "#D4AF37"
                    }

                    Text {
                        text: "Gestion de Turnos"
                        font.pixelSize: 18
                        color: "white"
                    }
                }

                MouseArea {
                    width: 60; height: 50
                    onClicked: window.currentPage = "admin"
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
                        text: window.dataLayer.countReservasByEstado("pendiente") + " Pend."
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
                        text: window.dataLayer.countReservasByEstado("confirmada") + " Conf."
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
                        text: window.dataLayer.countReservasByEstado("completada") + " Comp."
                        font.pixelSize: 12
                        color: "white"
                        anchors.centerIn: parent
                    }
                }
            }

            ListView {
                y: 100
                width: 375
                height: 500
                model: window.dataLayer.reservas
                delegate: Rectangle {
                    width: 375
                    height: 90
                    color: "#141414"
                    border.width: 1
                    border.color: "#252525"

                    Row {
                        x: 16; y: 10
                        spacing: 12

                        Rectangle {
                            width: 40; height: 40
                            radius: 10
                            color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : modelData.estado === "cancelada" ? "#E53935" : "#2A2A2A"

                            Text {
                                text: "📅"
                                font.pixelSize: 18
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            y: 2
                            Text {
                                text: modelData.usuarioId + " - " + modelData.servicioId
                                font.pixelSize: 13
                                color: "white"
                            }
                            Row {
                                spacing: 6
                                Text {
                                    text: modelData.fecha + " " + modelData.hora
                                    font.pixelSize: 12
                                    color: "#CCC"
                                }
                                Text {
                                    text: "|"
                                    color: "#4A4A4A"
                                }
                                Text {
                                    text: modelData.estado
                                    font.pixelSize: 11
                                    color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : modelData.estado === "cancelada" ? "#E53935" : "#666"
                                }
                            }
                        }
                    }

                    Row {
                        y: 60
                        x: 16
                        spacing: 8

                        // Confirmar button (for pendiente)
                        Rectangle {
                            width: 80; height: 24
                            radius: 12
                            color: modelData.estado === "pendiente" ? "#4CAF50" : "#333"
                            visible: modelData.estado === "pendiente"

                            Text {
                                text: "Confirmar"
                                font.pixelSize: 10
                                color: "white"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    window.dataLayer.confirmarReserva(modelData.id)
                                    window.currentPage = "admin"
                                }
                            }
                        }

                        // Cancelar button (for confirmada)
                        Rectangle {
                            width: 80; height: 24
                            radius: 12
                            color: modelData.estado === "confirmada" ? "#E53935" : "#333"
                            visible: modelData.estado === "confirmada"

                            Text {
                                text: "Cancelar"
                                font.pixelSize: 10
                                color: "white"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    window.dataLayer.cancelarReserva(modelData.id, "Cancelado por el salon")
                                    window.currentPage = "admin"
                                }
                            }
                        }

                        // Completar button (for confirmada)
                        Rectangle {
                            width: 80; height: 24
                            radius: 12
                            color: modelData.estado === "confirmada" ? "#2196F3" : "#333"
                            visible: modelData.estado === "confirmada"

                            Text {
                                text: "Completar"
                                font.pixelSize: 10
                                color: "white"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    window.dataLayer.updateReservaEstado(modelData.id, "completada")
                                    window.currentPage = "admin"
                                }
                            }
                        }
                    }
                }
            }

            // Notification area
            Rectangle {
                y: 610
                width: 335
                x: 20
                height: 180
                radius: 12
                color: "#141414"
                border.width: 1
                border.color: "#252525"

                Column {
                    x: 16; y: 16
                    spacing: 12

                    Text {
                        text: "Notificaciones"
                        font.pixelSize: 14
                        font.bold: true
                        color: "white"
                    }

                    Text {
                        text: "Sistema envia notificaciones al cliente cuando:"
                        font.pixelSize: 12
                        color: "#666"
                    }

                    Text {
                        text: "- Reserva confirmada"
                        font.pixelSize: 11
                        color: "#4CAF50"
                    }

                    Text {
                        text: "- Reserva cancelada"
                        font.pixelSize: 11
                        color: "#E53935"
                    }

                    Text {
                        text: "- Reserva completada"
                        font.pixelSize: 11
                        color: "#2196F3"
                    }
                }
            }
        }

        // Gestion Servicios
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "gestionServicios"

            Rectangle {
                width: 375; height: 50
                color: "#0D0D0D"

                Row {
                    x: 16; y: 15
                    spacing: 8

                    Text {
                        text: "<"
                        font.pixelSize: 20
                        color: "#D4AF37"
                    }

                    Text {
                        text: parent.parent.isEditing ? "Editar Servicio" : "Gestion de Servicios"
                        font.pixelSize: 18
                        color: "white"
                    }
                }

                MouseArea {
                    width: 60; height: 50
                    onClicked: {
                        parent.parent.isEditing = false
                        parent.parent.editingServicioId = ""
                        window.currentPage = "admin"
                    }
                }
            }

            Rectangle {
                y: 60
                width: 375
                height: 692

                visible: window.isEditing

                Rectangle {
                    anchors.fill: parent
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#0D0D0D" }
                        GradientStop { position: 0.5; color: "#141414" }
                        GradientStop { position: 1.0; color: "#0D0D0D" }
                    }
                }

                Column {
                    width: 327
                    x: 24
                    spacing: 16

                    Text {
                        text: "Nombre del servicio"
                        color: "#8B7355"
                        font.pixelSize: 12
                    }

                    Rectangle {
                        width: 327; height: 44
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#D4AF37"

                        TextInput {
                            id: editNombre
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            color: "white"
                            font.pixelSize: 14
                        }
                    }

                    Text {
                        text: "Precio ($)"
                        color: "#8B7355"
                        font.pixelSize: 12
                    }

                    Rectangle {
                        width: 327; height: 44
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#D4AF37"

                        TextInput {
                            id: editPrecio
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            color: "white"
                            font.pixelSize: 14
                            validator: IntValidator {}
                        }
                    }

                    Text {
                        text: "Duracion (minutos)"
                        color: "#8B7355"
                        font.pixelSize: 12
                    }

                    Rectangle {
                        width: 327; height: 44
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#D4AF37"

                        TextInput {
                            id: editDuracion
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            color: "white"
                            font.pixelSize: 14
                            validator: IntValidator {}
                        }
                    }

                    Text {
                        text: "Categoria"
                        color: "#8B7355"
                        font.pixelSize: 12
                    }

                    Row {
                        spacing: 8

                        Rectangle {
                            width: 100; height: 36
                            radius: 18
                            color: editCategoria.text === "corte" ? "#D4AF37" : "#1A1A1A"
                            border.width: 1
                            border.color: editCategoria.text === "corte" ? "#D4AF37" : "#333"

                            Text {
                                text: "Corte"
                                font.pixelSize: 12
                                color: editCategoria.text === "corte" ? "#0D0D0D" : "#666"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: editCategoria.text = "corte"
                            }
                        }

                        Rectangle {
                            width: 100; height: 36
                            radius: 18
                            color: editCategoria.text === "color" ? "#D4AF37" : "#1A1A1A"
                            border.width: 1
                            border.color: editCategoria.text === "color" ? "#D4AF37" : "#333"

                            Text {
                                text: "Color"
                                font.pixelSize: 12
                                color: editCategoria.text === "color" ? "#0D0D0D" : "#666"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: editCategoria.text = "color"
                            }
                        }

                        Rectangle {
                            width: 100; height: 36
                            radius: 18
                            color: editCategoria.text === "tratamiento" ? "#D4AF37" : "#1A1A1A"
                            border.width: 1
                            border.color: editCategoria.text === "tratamiento" ? "#D4AF37" : "#333"

                            Text {
                                text: "Tratamiento"
                                font.pixelSize: 12
                                color: editCategoria.text === "tratamiento" ? "#0D0D0D" : "#666"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: editCategoria.text = "tratamiento"
                            }
                        }
                    }

                    TextInput {
                        id: editCategoria
                        visible: false
                        text: "corte"
                    }

                    Text {
                        text: "Icono"
                        color: "#8B7355"
                        font.pixelSize: 12
                    }

                    Row {
                        spacing: 8

                        Repeater {
                            model: ["✂️", "💇", "💇‍♀️", "🎨", "🌈", "🎯", "🌅", "💆", "✨", "🌸", "💖"]
                            delegate: Rectangle {
                                width: 40; height: 40
                                radius: 8
                                color: editIcono.text === modelData ? "#D4AF37" : "#1A1A1A"

                                Text {
                                    text: modelData
                                    font.pixelSize: 18
                                    anchors.centerIn: parent
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: editIcono.text = modelData
                                }
                            }
                        }
                    }

                    TextInput {
                        id: editIcono
                        visible: false
                        text: "✂️"
                    }

                    Text {
                        text: "URLs de fotos (una por linea)"
                        color: "#8B7355"
                        font.pixelSize: 12
                    }

                    Rectangle {
                        width: 327; height: 80
                        radius: 10
                        color: "#141414"
                        border.width: 1
                        border.color: "#D4AF37"

                        TextEdit {
                            id: editFotos
                            width: 307; height: 60
                            x: 10; y: 10
                            color: "white"
                            font.pixelSize: 12
                            verticalAlignment: TextEdit.AlignTop
                        }
                    }

                    Row {
                        spacing: 12
                        y: 20

                        Rectangle {
                            width: 150; height: 44
                            radius: 22
                            color: "#E53935"

                            Text {
                                text: "ELIMINAR"
                                color: "white"
                                font.bold: true
                                font.pixelSize: 12
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (parent.parent.parent.parent.editingServicioId !== "") {
                                        window.dataLayer.deleteServicio(parent.parent.parent.parent.editingServicioId)
                                        parent.parent.parent.parent.editingServicioId = ""
                                        parent.parent.parent.parent.isEditing = false
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: 150; height: 44
                            radius: 22
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#D4AF37" }
                                GradientStop { position: 1.0; color: "#8B7355" }
                            }

                            Text {
                                text: "GUARDAR"
                                color: "#0D0D0D"
                                font.bold: true
                                font.pixelSize: 12
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    var fotosArray = editFotos.text.split('\n').filter(function(line) { return line.trim() !== "" })
                                    var servicio = {
                                        id: parent.parent.parent.parent.editingServicioId,
                                        nombre: editNombre.text,
                                        precio: parseInt(editPrecio.text) || 0,
                                        duracion: parseInt(editDuracion.text) || 30,
                                        categoria: editCategoria.text,
                                        icono: editIcono.text,
                                        descripcion: editNombre.text,
                                        fotos: fotosArray
                                    }
                                    window.dataLayer.updateServicio(servicio.id, servicio)
                                    parent.parent.parent.parent.isEditing = false
                                    parent.parent.parent.parent.editingServicioId = ""
                                }
                            }
                        }
                    }
                }
            }

            Column {
                y: 60
                visible: !parent.isEditing

                ListView {
                    width: 375
                    height: 600
                    model: window.dataLayer.servicios
                    delegate: Rectangle {
                        width: 375
                        height: 70
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Row {
                            x: 16; y: 15
                            spacing: 12

                            Rectangle {
                                width: 40; height: 40
                                radius: 10
                                color: "#1A1A1A"

                                Text {
                                    text: modelData.icono
                                    font.pixelSize: 18
                                    anchors.centerIn: parent
                                }
                            }

                            Column {
                                y: 2
                                Text {
                                    text: modelData.nombre
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "white"
                                }
                                Row {
                                    spacing: 6
                                    Text {
                                        text: "$" + modelData.precio
                                        font.pixelSize: 12
                                        color: "#D4AF37"
                                    }
                                    Text {
                                        text: "-"
                                        color: "#4A4A4A"
                                    }
                                    Text {
                                        text: modelData.duracion + " min"
                                        font.pixelSize: 12
                                        color: "#666"
                                    }
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var listView = parent.parent.parent.parent
                                listView.editingServicioId = modelData.id
                                listView.isEditing = true
                                window.dataLayer.servicioActual = modelData
                            }
                        }
                    }
                }

                Rectangle {
                    width: 335; height: 50
                    radius: 25
                    x: 20
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }

                    Text {
                        text: "+ AGREGAR SERVICIO"
                        color: "#0D0D0D"
                        font.bold: true
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var newId = "serv" + (window.dataLayer.servicios.length + 1)
                            parent.parent.parent.parent.editingServicioId = newId
                            parent.parent.parent.parent.isEditing = true
                            editNombre.text = ""
                            editPrecio.text = ""
                            editDuracion.text = ""
                            editCategoria.text = "corte"
                            editIcono.text = "✂️"
                        }
                    }
                }
            }

            Rectangle {
                y: 710
                width: 335
                x: 20
                height: 80
                radius: 12
                color: "#141414"
                border.width: 1
                border.color: "#252525"

                Column {
                    x: 16; y: 12
                    spacing: 8

                    Row {
                        spacing: 8

                        Rectangle {
                            width: 8; height: 8
                            radius: 4
                            color: window.syncManager && window.syncManager.isOnline ? "#4CAF50" : "#E53935"
                        }

                        Text {
                            text: window.syncManager && window.syncManager.isOnline ? "En linea" : "Sin conexion"
                            font.pixelSize: 12
                            color: "#8B7355"
                        }
                    }

                    Text {
                        text: window.syncManager && window.syncManager.pendingChangesCount > 0
                            ? window.syncManager.pendingChangesCount + " cambios pendientes"
                            : "Todo sincronizado"
                        font.pixelSize: 11
                        color: "#555"
                    }
                }
            }
        }

        // Service Detail (with gallery)
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "serviceDetail"

            Rectangle {
                width: 375; height: 50
                color: "#0D0D0D"

                Row {
                    x: 16; y: 15
                    spacing: 8

                    Text {
                        text: "<"
                        font.pixelSize: 20
                        color: "#D4AF37"
                    }

                    Text {
                        text: selectedService ? selectedService.nombre : "Detalle"
                        font.pixelSize: 18
                        color: "white"
                    }
                }

                MouseArea {
                    width: 60; height: 50
                    onClicked: currentPage = currentUser && currentUser.rol === "admin" ? "gestionServicios" : "servicios"
                }
            }

            Column {
                y: 60
                width: 375
                spacing: 16

                ListView {
                    width: 375
                    height: 250
                    visible: selectedService && selectedService.fotos && selectedService.fotos.length > 0
                    model: selectedService ? selectedService.fotos : []
                    snapMode: ListView.SnapOneItem
                    orientation: ListView.Horizontal
                    highlightRangeMode: ListView.StrictlyEnforceRange

                    delegate: Rectangle {
                        width: 375
                        height: 250

                        Rectangle {
                            width: 343
                            height: 230
                            radius: 12
                            clip: true
                            Image {
                                source: modelData
                                width: parent.width
                                height: parent.height
                                x: 16
                                fillMode: Image.PreserveAspectCrop
                                smooth: true
                            }
                        }
                        }
                    }

                    Row {
                        x: 16
                        spacing: 8

                        Repeater {
                            model: selectedService && selectedService.fotos ? selectedService.fotos.length : 0

                            Rectangle {
                                width: 8; height: 8
                                radius: 4
                                color: "#D4AF37"
                            }
                        }
                    }

                Rectangle {
                    width: 343; height: 200
                    x: 16
                    radius: 12
                    color: "#141414"
                    visible: !(selectedService && selectedService.fotos && selectedService.fotos.length > 0)

                    Text {
                        text: "Sin fotos disponibles"
                        color: "#555"
                        anchors.centerIn: parent
                    }
                }

                Rectangle {
                    width: 343; height: 120
                    x: 16
                    radius: 12
                    color: "#141414"

                    Column {
                        x: 16; y: 12
                        spacing: 8

                        Text {
                            text: selectedService ? selectedService.nombre : ""
                            font.pixelSize: 18
                            font.bold: true
                            color: "white"
                        }

                        Row {
                            spacing: 12

                            Text {
                                text: "$" + (selectedService ? selectedService.precio : "0")
                                font.pixelSize: 16
                                color: "#D4AF37"
                            }

                            Text {
                                text: "|"
                                color: "#4A4A4A"
                            }

                            Text {
                                text: (selectedService ? selectedService.duracion : "0") + " min"
                                font.pixelSize: 14
                                color: "#8B7355"
                            }
                        }

                        Text {
                            text: selectedService ? selectedService.descripcion : ""
                            font.pixelSize: 13
                            color: "#666"
                            width: 311
                            wrapMode: Text.Wrap
                        }
                    }
                }

                Rectangle {
                    width: 300; height: 54
                    radius: 27
                    x: 20
                    visible: currentUser && currentUser.rol === "cliente"
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }

                    Text {
                        text: "RESERVAR"
                        color: "#0D0D0D"
                        font.bold: true
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                        MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            currentPage = "reserva"
                        }
                    }
                }
            }
        }

        // Servicios
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "servicios"

            Column {
                width: 375
                spacing: 16
                anchors.top: parent.top
                anchors.topMargin: 60

                Row {
                    spacing: 10
                    x: 16

                    Text {
                        text: "<"
                        font.pixelSize: 20
                        color: "#D4AF37"
                    }

                    Text {
                        text: "Servicios"
                        font.pixelSize: 18
                        color: "white"
                    }
                }

                MouseArea {
                    width: 60; height: 40
                    onClicked: window.currentPage = "inicio"
                }

                ListView {
                    width: 375
                    height: 650
                    model: window.dataLayer.servicios
                    delegate: Rectangle {
                        width: 375
                        height: 80
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Row {
                            x: 16; y: 15
                            spacing: 12

                            Rectangle {
                                width: 50; height: 50
                                radius: 10
                                color: "#1A1A1A"

                                Text {
                                    text: modelData.icono
                                    font.pixelSize: 22
                                    anchors.centerIn: parent
                                }
                            }

                            Column {
                                y: 5
                                Text {
                                    text: modelData.nombre
                                    font.pixelSize: 15
                                    font.bold: true
                                    color: "white"
                                }
                                Text {
                                    text: "$" + modelData.precio + " - " + modelData.duracion + " min"
                                    font.pixelSize: 13
                                    color: "#D4AF37"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                window.selectService(modelData)
                                window.currentPage = "serviceDetail"
                            }
                        }
                    }
                }
            }
        }

        // Reserva
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "reserva"

            Column {
                width: 375
                spacing: 20
                anchors.top: parent.top
                anchors.topMargin: 60

                Row {
                    spacing: 10
                    x: 16

                    Text {
                        text: "<"
                        font.pixelSize: 20
                        color: "#D4AF37"
                    }

                    Text {
                        text: "Nueva Reserva"
                        font.pixelSize: 18
                        color: "white"
                    }
                }

                MouseArea {
                    width: 60; height: 40
                    onClicked: window.currentPage = "servicios"
                }

                // Selected service info
                Rectangle {
                    width: 343; height: 70
                    radius: 12
                    color: "#141414"
                    border.width: 1
                    border.color: "#D4AF37"
                    x: 16
                    y: 70

                    Row {
                        x: 12; y: 10
                        spacing: 12

                        Rectangle {
                            width: 50; height: 50
                            radius: 10
                            color: "#1A1A1A"

                            Text {
                                text: window.selectedService ? window.selectedService.icono : "?"
                                font.pixelSize: 22
                                anchors.centerIn: parent
                            }
                        }

                        Column {
                            y: 5
                            Text {
                                text: window.selectedService ? window.selectedService.nombre : "Selecciona un servicio"
                                font.pixelSize: 15
                                font.bold: true
                                color: "white"
                            }
                            Text {
                                text: window.selectedService ? "$" + window.selectedService.precio + " - " + window.selectedService.duracion + " min" : ""
                                font.pixelSize: 13
                                color: "#D4AF37"
                            }
                        }
                    }
                }

                Item { height: 20 }

                Text {
                    text: "Selecciona el dia"
                    color: "white"
                    font.pixelSize: 16
                    x: 16
                    y: 160
                }

                Grid {
                    x: 16
                    y: 190
                    columns: 7
                    spacing: 8

                    Repeater {
                        model: 28
                        delegate: Rectangle {
                            width: 40; height: 40
                            radius: 20
                            color: window.selectedDia === index ? "#D4AF37" : "#141414"
                            border.width: 1
                            border.color: window.selectedDia === index ? "#D4AF37" : "#252525"

                            Text {
                                text: index + 1
                                color: window.selectedDia === index ? "#0D0D0D" : "#CCC"
                                font.pixelSize: 14
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: window.selectedDia = index
                            }
                        }
                    }
                }

                Text {
                    text: "Selecciona la hora"
                    color: "white"
                    font.pixelSize: 16
                    x: 16
                    y: 300
                }

                Grid {
                    x: 16
                    y: 330
                    columns: 4
                    spacing: 10

                    Repeater {
                        model: ["09:00", "10:00", "11:00", "12:00", "14:00", "15:00", "16:00", "17:00"]
                        delegate: Rectangle {
                            width: 75; height: 40
                            radius: 10
                            color: window.selectedHora === modelData ? "#D4AF37" : "#141414"
                            border.width: 1
                            border.color: window.selectedHora === modelData ? "#D4AF37" : "#252525"

                            Text {
                                text: modelData
                                color: window.selectedHora === modelData ? "#0D0D0D" : "#CCC"
                                font.pixelSize: 13
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: window.selectedHora = modelData
                            }
                        }
                    }
                }

                Rectangle {
                    id: confirmarBtn
                    width: 335; height: 54
                    radius: 27
                    x: 20
                    y: 480
                    color: "#333"

                    Rectangle {
                        anchors.fill: parent
                        radius: 27
                        visible: window.selectedService && window.selectedDia >= 0 && window.selectedHora
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#D4AF37" }
                            GradientStop { position: 1.0; color: "#8B7355" }
                        }
                    }

                    Text {
                        text: "CONFIRMAR RESERVA"
                        color: (window.selectedService && window.selectedDia >= 0 && window.selectedHora) ? "#0D0D0D" : "#666"
                        font.bold: true
                        font.pixelSize: 14
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (window.selectedService && window.selectedDia >= 0 && window.selectedHora) {
                                var fecha = new Date()
                                fecha.setDate(fecha.getDate() + window.selectedDia + 1)
                                var fechaStr = fecha.toISOString().split('T')[0]

                                var nuevaReserva = window.dataLayer.addReserva({
                                    usuarioId: window.currentUser.id,
                                    servicioId: window.selectedService.id,
                                    fecha: fechaStr,
                                    hora: window.selectedHora
                                })

                                console.log("Reserva creada:", nuevaReserva.id, "para usuario:", window.currentUser.id)

                                window.selectedService = null
                                window.selectedDia = -1
                                window.selectedHora = ""
                                window.currentPage = "misCitas"
                            }
                        }
                    }
                }
            }
        }

        // Mis Citas (Cliente)
        Rectangle {
            width: 375; height: 812
            color: "#0D0D0D"
            visible: currentPage === "misCitas"

            onVisibleChanged: {
                if (visible) {
                    console.log("Navegando a MisCitas, usuario:", window.currentUser ? window.currentUser.id : "sin usuario")
                    console.log("Reservas totales:", window.dataLayer.reservas.length)
                }
            }

            Column {
                width: 375
                spacing: 16
                anchors.top: parent.top
                anchors.topMargin: 60

                Row {
                    spacing: 10
                    x: 16

                    Rectangle {
                        width: 30; height: 30
                        radius: 15
                        color: "#D4AF37"

                        Text {
                            text: "<"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#0D0D0D"
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: window.currentPage = "inicio"
                        }
                    }

                    Text {
                        text: "Mis Citas"
                        font.pixelSize: 18
                        color: "white"
                        y: 4
                    }
                }

                Item { height: 10 }

                ListView {
                    width: 375
                    height: 650
                    clip: true
                    model: window.dataLayer.getReservasByUsuario(window.currentUser ? window.currentUser.id : "")

                    Component.onCompleted: {
                        console.log("MisCitas: cargando reservas para usuario:", window.currentUser ? window.currentUser.id : "sin usuario")
                    }

                    delegate: Rectangle {
                        width: 375
                        height: 90
                        color: "#141414"
                        border.width: 1
                        border.color: "#252525"

                        Row {
                            x: 16; y: 10
                            spacing: 12

                            Rectangle {
                                width: 40; height: 40
                                radius: 10
                                color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : modelData.estado === "cancelada" ? "#E53935" : "#2A2A2A"

                                Text {
                                    text: "📅"
                                    font.pixelSize: 18
                                    anchors.centerIn: parent
                                }
                            }

                            Column {
                                y: 2
                                Text {
                                    text: window.dataLayer.getServicioById(modelData.servicioId) ? window.dataLayer.getServicioById(modelData.servicioId).nombre : modelData.servicioId
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "white"
                                }
                                Row {
                                    spacing: 6
                                    Text {
                                        text: modelData.fecha + " " + modelData.hora
                                        font.pixelSize: 12
                                        color: "#CCC"
                                    }
                                }
                            }
                        }

                        Row {
                            y: 60
                            x: 16

                            Rectangle {
                                width: 80; height: 24
                                radius: 12
                                color: modelData.estado === "confirmada" ? "#4CAF50" : modelData.estado === "pendiente" ? "#D4AF37" : modelData.estado === "cancelada" ? "#E53935" : "#2196F3"

                                Text {
                                    text: modelData.estado
                                    font.pixelSize: 11
                                    color: "white"
                                    anchors.centerIn: parent
}
                }

                Text {
                                text: "Reservado el " + modelData.fechaReserva
                                font.pixelSize: 10
                                color: "#555"
                                y: 5
                                x: 10
                            }
                        }
                    }
                }

                Rectangle {
                    width: 300; height: 50
                    radius: 25
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#D4AF37" }
                        GradientStop { position: 1.0; color: "#8B7355" }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        text: "+ Nueva Reserva"
                        color: "#0D0D0D"
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: window.currentPage = "servicios"
                    }
                }
            }
        }
    }