import QtQuick 2.15

QtObject {
    id: syncManager

    property bool isOnline: false
    property bool isSyncing: false
    property bool isSupabaseConnected: false
    property bool initialized: false
    property int syncInterval: 60000
    property string lastSyncTime: ""
    property int pendingChangesCount: 0
    property string storageFile: "localStorageData.json"

    property var localStorageDataData: ({ syncQueue: [], servicios: [], usuarios: [], reservas: [] })

    property string supabaseUrl: "https://ubmjcdmzfelgmyjuowgf.supabase.co"
    property string supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVibWpjZG16ZmVsZ215anVvd2dmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcwNjU3MzQsImV4cCI6MjA5MjY0MTczNH0.SxJ0iVqTp1DItbDQ4YUuysK1gg_6n3HCmT4KtPtMFkE"

    signal onlineStatusChanged(bool online)
    signal syncStarted()
    signal syncCompleted(bool success, string message)
    signal supabaseStatusChanged(bool connected)
    signal negocioCheckCompleted(bool tieneNegocio, string negocioId)

    Component.onCompleted: {
        console.log("SyncManager: Component loaded")
        checkNegocioConfigurado()
    }

    function checkNegocioConfigurado() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/negocios?select=id,nombre", true)
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                initialized = true
                if (xhr.status === 200) {
                    var data = JSON.parse(xhr.responseText)
                    if (data && data.length > 0) {
                        window.hasNegocio = true
                        window.currentNegocioId = data[0].id
                        if (dataLayer) dataLayer.setNegocioId(data[0].id)
                        window.currentPage = "login"
                        negocioCheckCompleted(true, data[0].id)
                        console.log("Negocio configurado:", data[0].nombre)
                    } else {
                        window.hasNegocio = false
                        window.currentNegocioId = ""
                        window.currentPage = "crearNegocio"
                        negocioCheckCompleted(false, "")
                        console.log("No hay negocio, mostrar crearNegocio")
                    }
                } else {
                    window.hasNegocio = false
                    window.currentNegocioId = ""
                    window.currentPage = "crearNegocio"
                    negocioCheckCompleted(false, "")
                }
            }
        }

        xhr.send()
    }

    function crearNegocio(nombre, telefono, direccion, callback) {
        var negocioId = "negocio_" + Date.now()
        var negocioData = {
            id: negocioId,
            nombre: nombre,
            telefono: telefono || "",
            direccion: direccion || ""
        }

        var xhr = new XMLHttpRequest()
        xhr.open("POST", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/negocios", true)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 201) {
                    window.hasNegocio = true
                    window.currentNegocioId = negocioId
                    if (dataLayer) dataLayer.setNegocioId(negocioId)
                    console.log("Negocio creado:", negocioId)
                    if (callback) callback(true, negocioId)
                } else {
                    console.log("Error creando negocio:", xhr.status, xhr.responseText)
                    if (callback) callback(false, null)
                }
            }
        }

xhr.send(JSON.stringify(negocioData))
    }

    function crearNegocioCompleto(datos, callback) {
        var negocioId = "negocio_" + Date.now()
        var negocioData = {
            id: negocioId,
            nombre: datos.nombre || "",
            telefono: datos.telefono || "",
            direccion: datos.direccion || "",
            descripcion: datos.descripcion || "",
            hora_apertura: datos.horaApertura || "09:00",
            hora_cierre: datos.horaCierre || "18:00",
            dias_laborales: datos.diasLaborales || "lunes,martes,miercoles,jueves,viernes",
            duracion_cita: datos.duracionCita || 45,
            notas: datos.notas || "",
            logo_url: datos.logoPath || ""
        }

        var xhr = new XMLHttpRequest()
        xhr.open("POST", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/negocios", true)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 201) {
                    window.hasNegocio = true
                    window.currentNegocioId = negocioId
                    if (dataLayer) dataLayer.setNegocioId(negocioId)
                    console.log("Negocio completo creado:", negocioId)
                    if (callback) callback(true, negocioId)
                } else {
                    console.log("Error creando negocio completo:", xhr.status, xhr.responseText)
                    if (callback) callback(false, null)
                }
            }
        }

        xhr.send(JSON.stringify(negocioData))
    }

    function fetchServiciosForNegocio(negocioId, callback) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/servicios?negocio_id=eq." + negocioId + "&select=*", false)
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        try {
            xhr.send()
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                for (var i = 0; i < data.length; i++) {
                    data[i] = normalizeToCamelCase(data[i])
                }
                if (callback) callback(true, data)
                return data
            }
        } catch (e) {
            console.log("Error fetching servicios:", e)
        }
        if (callback) callback(false, [])
        return []
    }

    function fetchUsuariosForNegocio(negocioId, callback) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/usuarios?negocio_id=eq." + negocioId + "&select=*", false)
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        try {
            xhr.send()
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                for (var i = 0; i < data.length; i++) {
                    data[i] = normalizeToCamelCase(data[i])
                }
                if (callback) callback(true, data)
                return data
            }
        } catch (e) {
            console.log("Error fetching usuarios:", e)
        }
        if (callback) callback(false, [])
        return []
    }

    function loginUsuario(negocioId, email, callback) {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/usuarios?negocio_id=eq." + encodeURIComponent(negocioId) + "&email=eq." + encodeURIComponent(email) + "&select=*", true)
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    var data = JSON.parse(xhr.responseText)
                    if (data && data.length > 0) {
                        var usuario = normalizeToCamelCase(data[0])
                        if (callback) callback(true, usuario)
                    } else {
                        if (callback) callback(false, null)
                    }
                } else {
                    if (callback) callback(false, null)
                }
            }
        }

        xhr.send()
    }

    function changePassword(userId, newPassword, callback) {
        // TODO: Implement when Supabase has password columns
        console.log("Password change requested for:", userId)
        if (callback) callback(true)
    }

    function crearUsuario(negocioId, nombre, email, rol, callback) {
        var usuarioId = "user_" + Date.now()
        var usuarioData = {
            id: usuarioId,
            negocio_id: negocioId,
            nombre: nombre,
            email: email,
            rol: rol || "cliente",
            telefono: "",
            birthday: ""
        }

        var xhr = new XMLHttpRequest()
        xhr.open("POST", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/usuarios", true)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 201) {
                    console.log("Usuario creado en Supabase:", usuarioId)
                    try {
                        var response = JSON.parse(xhr.responseText)
                        var userData = Array.isArray(response) ? response[0] : response
                        if (callback) callback(true, normalizeToCamelCase(userData))
                    } catch(e) {
                        console.log("Error parsing usuario response:", e, xhr.responseText)
                        if (callback) callback(true, normalizeToCamelCase(usuarioData))
                    }
                } else {
                    console.log("Error creando usuario:", xhr.status, xhr.responseText)
                    if (callback) callback(false, null)
                }
            }
        }

        xhr.send(JSON.stringify(usuarioData))
    }

    function loadFromStorage() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", storageFile, false)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText)
                    localStorageData = data
                    console.log("SyncManager: Loaded from local storage")
                } catch (e) {
                    console.log("SyncManager: Error parsing storage", e)
                }
            }
        }

        try {
            xhr.send()
        } catch(e) {
            console.log("SyncManager: No existing storage, using defaults")
        }

        if (localStorageData.servicios.length === 0 && dataLayer) {
            localStorageData.servicios = dataLayer.servicios || []
        }
        if (localStorageData.usuarios.length === 0 && dataLayer) {
            localStorageData.usuarios = dataLayer.usuarios || []
        }
        if (localStorageData.reservas.length === 0 && dataLayer) {
            localStorageData.reservas = dataLayer.reservas || []
        }

        reloadDataLayer()
    }

    function saveToStorage() {
        var xhr = new XMLHttpRequest()
        xhr.open("PUT", storageFile, false)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                console.log("SyncManager: Saved to local storage")
            }
        }

        try {
            xhr.send(JSON.stringify(localStorageData))
        } catch(e) {
            console.log("SyncManager: Error saving", e)
        }
    }

    function reloadDataLayer() {
        if (!dataLayer) return

        dataLayer.servicios = localStorageData.servicios || []
        dataLayer.usuarios = localStorageData.usuarios || []
        dataLayer.reservas = localStorageData.reservas || []

        console.log("SyncManager: DataLayer reloaded from local storage")
    }

    function startNetworkMonitor() {
        var networkTimer = Qt.createQmlObject('import QtQuick 2.15; Timer { id: networkTimer }', syncManager)
        networkTimer.interval = syncInterval
        networkTimer.repeat = true
        networkTimer.triggered.connect(checkConnection)
        networkTimer.start()

        checkConnection()
        console.log("SyncManager: Network monitor started (1 min interval)")
    }

    function checkConnection() {
        var wasOnline = isOnline

        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://www.google.com", false)
        xhr.timeout = 3000

        try {
            xhr.send()
            isOnline = (xhr.status === 200)
        } catch(e) {
            isOnline = false
        }

        if (isOnline !== wasOnline) {
            onlineStatusChanged(isOnline)
            console.log("SyncManager: Online status:", isOnline)

            if (isOnline) {
                checkSupabaseConnection()
            }
        }

        pendingChangesCount = localStorageData.syncQueue ? localStorageData.syncQueue.length : 0
    }

    function checkSupabaseConnection() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/servicios?select=count", false)
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        try {
            xhr.send()
            isSupabaseConnected = (xhr.status === 200 || xhr.status === 401)
        } catch(e) {
            isSupabaseConnected = false
        }

        supabaseStatusChanged(isSupabaseConnected)
        console.log("SyncManager: Supabase:", isSupabaseConnected)

        if (isSupabaseConnected && localStorageData.syncQueue.length > 0) {
            syncToSupabase()
        }
    }

    function syncToSupabase() {
        if (localStorageData.syncQueue.length === 0) {
            console.log("SyncManager: No pending changes to sync")
            return
        }

        isSyncing = true
        syncStarted()

        console.log("SyncManager: Syncing", localStorageData.syncQueue.length, "changes to Supabase...")

        for (var i = 0; i < localStorageData.syncQueue.length; i++) {
            var change = localStorageData.syncQueue[i]
            console.log("SyncManager: Syncing:", change.operation, change.table, change.id)

            var success = simulateSupabaseSync(change)

            if (success) {
                localStorageData.syncQueue.splice(i, 1)
                i--
            }
        }

        lastSyncTime = new Date().toISOString()
        saveToStorage()

        isSyncing = false
        syncCompleted(true, "Sincronizacion completa")
        console.log("SyncManager: Sync completed")
    }

    function simulateSupabaseSync(change) {
        var xhr = new XMLHttpRequest()
        var baseUrl = "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/"

        switch (change.table) {
            case "servicios":
                baseUrl += "servicios"
                break
            case "reservas":
                baseUrl += "reservas"
                break
            case "usuarios":
                baseUrl += "usuarios"
                break
            default:
                return false
        }

        var method = change.operation === "create" ? "POST" : change.operation === "update" ? "PATCH" : "DELETE"
        xhr.open(method, baseUrl, false)
        xhr.setRequestHeader("Content-Type", "application/json")
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        try {
            xhr.send(JSON.stringify(normalizeToSnakeCase(change.data)))
            return xhr.status === 200 || xhr.status === 201
        } catch (e) {
            console.log("SyncManager: Supabase error:", e)
            return false
        }
    }

    function fetchAllDataFromSupabase() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/servicios?select=*", false)
        xhr.setRequestHeader("apikey", supabaseKey)
        xhr.setRequestHeader("Authorization", "Bearer " + supabaseKey)

        try {
            xhr.send()
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                if (Array.isArray(data)) {
                    for (var i = 0; i < data.length; i++) {
                        data[i] = normalizeToCamelCase(data[i])
                    }
                }
                localStorageData.servicios = data || []
                saveToStorage()
                reloadDataLayer()
                return true
            }
        } catch (e) {
            console.log("SyncManager: fetchAllData error:", e)
        }
        return false
    }

    function queueChange(table, id, operation, data) {
        localStorageData.syncQueue.push({
            table: table,
            id: id,
            operation: operation,
            data: data,
            createdAt: new Date().toISOString()
        })

        saveToStorage()
        pendingChangesCount = localStorageData.syncQueue.length
        console.log("SyncManager: Queued:", operation, table, id)

        if (isSupabaseConnected) {
            syncToSupabase()
        }
    }

    function normalizeToSnakeCase(data) {
        var result = {}
        for (var key in data) {
            var snakeKey = key.replace(/([A-Z])/g, function(m) { return "_" + m.toLowerCase(); })
            result[snakeKey] = data[key]
        }
        return result
    }

    function normalizeToCamelCase(data) {
        var result = {}
        for (var key in data) {
            var camelKey = key.replace(/_([a-z])/g, function(m) { return m[1].toUpperCase(); })
            result[camelKey] = data[key]
        }
        return result
    }

    function addServicio(servicio) {
        localStorageData.servicios.push(servicio)
        queueChange("servicios", servicio.id, "create", servicio)
        reloadDataLayer()
    }

    function updateServicio(servicio) {
        for (var i = 0; i < localStorageData.servicios.length; i++) {
            if (localStorageData.servicios[i].id === servicio.id) {
                localStorageData.servicios[i] = servicio
                break
            }
        }
        queueChange("servicios", servicio.id, "update", servicio)
        reloadDataLayer()
    }

    function deleteServicio(servicioId) {
        for (var i = 0; i < localStorageData.servicios.length; i++) {
            if (localStorageData.servicios[i].id === servicioId) {
                localStorageData.servicios.splice(i, 1)
                break
            }
        }
        queueChange("servicios", servicioId, "delete", {})
        reloadDataLayer()
    }

    function addReserva(reserva) {
        localStorageData.reservas.push(reserva)
        queueChange("reservas", reserva.id, "create", reserva)
        reloadDataLayer()
    }

    function updateUsuario(usuario) {
        for (var i = 0; i < localStorageData.usuarios.length; i++) {
            if (localStorageData.usuarios[i].id === usuario.id) {
                localStorageData.usuarios[i] = usuario
                break
            }
        }
        queueChange("usuarios", usuario.id, "update", usuario)
        reloadDataLayer()
    }
}
