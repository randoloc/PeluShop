import QtQuick 2.15

QtObject {
    id: syncManager

property bool isOnline: false
    property bool isSyncing: false
    property bool isSupabaseConnected: false
    property int syncInterval: 60000
    property string lastSyncTime: ""
    property int pendingChangesCount: 0

    signal onlineStatusChanged(bool online)
    signal syncStarted()
    signal syncCompleted(bool success, string message)
    signal supabaseStatusChanged(bool connected)

    function init() {
        console.log("SyncManager: Initializing...")
        loadFromStorage()
        startNetworkMonitor()
    }

    function loadFromStorage() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", storageFile, false)

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    var data = JSON.parse(xhr.responseText)
                    localStorage = data
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

        if (localStorage.servicios.length === 0 && dataLayer) {
            localStorage.servicios = dataLayer.servicios || []
        }
        if (localStorage.usuarios.length === 0 && dataLayer) {
            localStorage.usuarios = dataLayer.usuarios || []
        }
        if (localStorage.reservas.length === 0 && dataLayer) {
            localStorage.reservas = dataLayer.reservas || []
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
            xhr.send(JSON.stringify(localStorage))
        } catch(e) {
            console.log("SyncManager: Error saving", e)
        }
    }

    function reloadDataLayer() {
        if (!dataLayer) return

        dataLayer.servicios = localStorage.servicios || []
        dataLayer.usuarios = localStorage.usuarios || []
        dataLayer.reservas = localStorage.reservas || []

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

        pendingChangesCount = localStorage.syncQueue ? localStorage.syncQueue.length : 0
    }

    function checkSupabaseConnection() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/servicios?select=count", false)
        xhr.setRequestHeader("apikey", "YOUR_ANON_KEY_HERE")
        xhr.setRequestHeader("Authorization", "Bearer YOUR_ANON_KEY_HERE")

        try {
            xhr.send()
            isSupabaseConnected = (xhr.status === 200 || xhr.status === 401)
        } catch(e) {
            isSupabaseConnected = false
        }

        supabaseStatusChanged(isSupabaseConnected)
        console.log("SyncManager: Supabase:", isSupabaseConnected)

        if (isSupabaseConnected && localStorage.syncQueue.length > 0) {
            syncToSupabase()
        }
    }

    function syncToSupabase() {
        if (localStorage.syncQueue.length === 0) {
            console.log("SyncManager: No pending changes to sync")
            return
        }

        isSyncing = true
        syncStarted()

        console.log("SyncManager: Syncing", localStorage.syncQueue.length, "changes to Supabase...")

        for (var i = 0; i < localStorage.syncQueue.length; i++) {
            var change = localStorage.syncQueue[i]
            console.log("SyncManager: Syncing:", change.operation, change.table, change.id)

            var success = simulateSupabaseSync(change)

            if (success) {
                localStorage.syncQueue.splice(i, 1)
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
        xhr.setRequestHeader("apikey", "YOUR_ANON_KEY_HERE")
        xhr.setRequestHeader("Authorization", "Bearer YOUR_ANON_KEY_HERE")

        try {
            xhr.send(JSON.stringify(change.data))
            return xhr.status === 200 || xhr.status === 201
        } catch (e) {
            console.log("SyncManager: Supabase error:", e)
            return false
        }
    }

    function fetchAllDataFromSupabase() {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://ubmjcdmzfelgmyjuowgf.supabase.co/rest/v1/servicios?select=*", false)
        xhr.setRequestHeader("apikey", "YOUR_ANON_KEY_HERE")
        xhr.setRequestHeader("Authorization", "Bearer YOUR_ANON_KEY_HERE")

        try {
            xhr.send()
            if (xhr.status === 200) {
                var data = JSON.parse(xhr.responseText)
                localStorage.servicios = data || []
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
        localStorage.syncQueue.push({
            table: table,
            id: id,
            operation: operation,
            data: data,
            createdAt: new Date().toISOString()
        })

        saveToStorage()
        pendingChangesCount = localStorage.syncQueue.length
        console.log("SyncManager: Queued:", operation, table, id)

        if (isSupabaseConnected) {
            syncToFirebase()
        }
    }

    function addServicio(servicio) {
        localStorage.servicios.push(servicio)
        queueChange("servicios", servicio.id, "create", servicio)
        reloadDataLayer()
    }

    function updateServicio(servicio) {
        for (var i = 0; i < localStorage.servicios.length; i++) {
            if (localStorage.servicios[i].id === servicio.id) {
                localStorage.servicios[i] = servicio
                break
            }
        }
        queueChange("servicios", servicio.id, "update", servicio)
        reloadDataLayer()
    }

    function deleteServicio(servicioId) {
        for (var i = 0; i < localStorage.servicios.length; i++) {
            if (localStorage.servicios[i].id === servicioId) {
                localStorage.servicios.splice(i, 1)
                break
            }
        }
        queueChange("servicios", servicioId, "delete", {})
        reloadDataLayer()
    }

    function addReserva(reserva) {
        localStorage.reservas.push(reserva)
        queueChange("reservas", reserva.id, "create", reserva)
        reloadDataLayer()
    }

    function updateUsuario(usuario) {
        for (var i = 0; i < localStorage.usuarios.length; i++) {
            if (localStorage.usuarios[i].id === usuario.id) {
                localStorage.usuarios[i] = usuario
                break
            }
        }
        queueChange("usuarios", usuario.id, "update", usuario)
        reloadDataLayer()
    }

    Component.onCompleted: {
        init()
    }
}
