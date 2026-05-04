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

        