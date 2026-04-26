import QtQuick 2.15

QtObject {
    id: dataLayer

    property string currentNegocioId: ""
    property var servicios: [
        {id: "corte1", nombre: "Corte Clasico", categoria: "corte", precio: 45, duracion: 45, descripcion: "Corte tradicional con tijeras y peinado", icono: "✂️", fotos: ["https://images.unsplash.com/photo-1562322140-8b8488b2b5b2?w=600"]},
        {id: "corte2", nombre: "Corte Capas", categoria: "corte", precio: 55, duracion: 60, descripcion: "Corte en capas con volumen y movimiento", icono: "💇", fotos: []},
        {id: "corte3", nombre: "Corte Bob", categoria: "corte", precio: 50, duracion: 45, descripcion: "Corte estilo bob moderno y elegante", icono: "👩", fotos: []},
        {id: "color1", nombre: "Mechas", categoria: "color", precio: 120, duracion: 180, descripcion: "Mechas californianas naturales", icono: "🎨", fotos: []},
        {id: "color2", nombre: "Balayage", categoria: "color", precio: 150, duracion: 210, descripcion: "Tecnica de pintura para look natural", icono: "🌈", fotos: []},
        {id: "trat1", nombre: "Hidratacion", categoria: "tratamiento", precio: 40, duracion: 45, descripcion: "Tratamiento intensivo de hidratacion profunda", icono: "💆", fotos: []},
        {id: "trat2", nombre: "Keratina", categoria: "tratamiento", precio: 80, duracion: 120, descripcion: "Queratina brasileira para cabello liso", icono: "✨", fotos: []}
    ]

    property var usuarios: [
        {id: "admin1", nombre: "Admin Principal", email: "admin@beautybook.com", rol: "admin", fechaRegistro: "2024-01-01", birthday: "", telefono: "", negocioId: "pelu1"},
        {id: "user1", nombre: "Ana Garcia", email: "ana@email.com", rol: "cliente", fechaRegistro: "2024-06-15", birthday: "1990-05-15", telefono: "", negocioId: "pelu1"},
        {id: "user2", nombre: "Carlos Lopez", email: "carlos@email.com", rol: "cliente", fechaRegistro: "2024-07-20", birthday: "", telefono: "", negocioId: "pelu1"}
    ]

    property var reservas: [
        {id: "res1", usuarioId: "user1", servicioId: "corte1", fecha: "2024-12-20", hora: "10:00", estado: "confirmada", fechaReserva: "2024-12-15", negocioId: "pelu1"},
        {id: "res2", usuarioId: "user2", servicioId: "color2", fecha: "2024-12-22", hora: "14:00", estado: "pendiente", fechaReserva: "2024-12-18", negocioId: "pelu1"},
        {id: "res3", usuarioId: "user1", servicioId: "trat1", fecha: "2024-12-18", hora: "11:00", estado: "completada", fechaReserva: "2024-12-10", negocioId: "pelu1"}
    ]

    property var horarios: ["09:00", "10:00", "11:00", "12:00", "14:00", "15:00", "16:00", "17:00"]

    function getSyncManager() {
        return syncMgr
    }

    function setNegocioId(id) {
        currentNegocioId = id
        console.log("DataLayer: Negocio configurado:", id)
    }

    function getServiciosByNegocio(negocioId) {
        if (!negocioId) return servicios
        return servicios.filter(function(s) { return s.negocioId === negocioId; })
    }

    function getUsuariosByNegocio(negocioId) {
        if (!negocioId) return usuarios
        return usuarios.filter(function(u) { return u.negocioId === negocioId; })
    }

    function getReservasByNegocio(negocioId) {
        if (!negocioId) return reservas
        return reservas.filter(function(r) { return r.negocioId === negocioId; })
    }

    // Get servicios by categoria
    function getServiciosByCategoria(cat) {
        return servicios.filter(function(s) { return s.categoria === cat; })
    }

    // Get servicio by id
    function getServicioById(id) {
        for (var i = 0; i < servicios.length; i++) {
            if (servicios[i].id === id) return servicios[i]
        }
        return null
    }

    // Get usuario by id
    function getUsuarioById(id) {
        for (var i = 0; i < usuarios.length; i++) {
            if (usuarios[i].id === id) return usuarios[i]
        }
        return null
    }

    // Get usuario by email
    function getUsuarioByEmail(email) {
        for (var i = 0; i < usuarios.length; i++) {
            if (usuarios[i].email === email) return usuarios[i]
        }
        return null
    }

    // Update usuario birthday
    function updateUsuarioBirthday(usuarioId, birthday) {
        for (var i = 0; i < usuarios.length; i++) {
            if (usuarios[i].id === usuarioId) {
                usuarios[i].birthday = birthday
                return true
            }
        }
        return false
    }

    // Update usuario telefono
    function updateUsuarioTelefono(usuarioId, telefono) {
        for (var i = 0; i < usuarios.length; i++) {
            if (usuarios[i].id === usuarioId) {
                usuarios[i].telefono = telefono
                return true
            }
        }
        return false
    }

    // Get usuario telefono
    function getUsuarioTelefono(usuarioId) {
        for (var i = 0; i < usuarios.length; i++) {
            if (usuarios[i].id === usuarioId) {
                return usuarios[i].telefono || ""
            }
        }
        return ""
    }

    // Check if user's birthday is soon (within 7 days)
    function isBirthdaySoon(birthday) {
        if (!birthday) return false
        var hoy = new Date()
        var cumple = new Date(birthday)
        var anioActual = hoy.getFullYear()
        cumple.setFullYear(anioActual)

        if (cumple < hoy) {
            cumple.setFullYear(anioActual + 1)
        }

        var diffDias = Math.ceil((cumple - hoy) / (1000 * 60 * 60 * 24))
        return diffDias >= 0 && diffDias <= 7
    }

    // Get reservas by usuario
    function getReservasByUsuario(userId) {
        return reservas.filter(function(r) { return r.usuarioId === userId; })
    }

    // Add new reserva
    function addReserva(reserva) {
        reserva.id = "res" + (reservas.length + 1)
        reserva.estado = "pendiente"
        reserva.fechaReserva = new Date().toISOString().split('T')[0]
        reservas.push(reserva)

        if (window.syncManager) {
            window.syncManager.addReserva(reserva)
        }
        return reserva
    }

    // Confirmar reserva (pendiente -> confirmada)
    function confirmarReserva(reservaId) {
        for (var i = 0; i < reservas.length; i++) {
            if (reservas[i].id === reservaId) {
                reservas[i].estado = "confirmada"
                return true
            }
        }
        return false
    }

    // Cancelar reserva (confirmada -> cancelada with message)
    function cancelarReserva(reservaId, motivo) {
        for (var i = 0; i < reservas.length; i++) {
            if (reservas[i].id === reservaId) {
                reservas[i].estado = "cancelada"
                reservas[i].motivoCancelacion = motivo
                return true
            }
        }
        return false
    }

    // Update reserva estado
    function updateReservaEstado(reservaId, nuevoEstado) {
        for (var i = 0; i < reservas.length; i++) {
            if (reservas[i].id === reservaId) {
                reservas[i].estado = nuevoEstado
                return true
            }
        }
        return false
    }

    // Add servicio
    function addServicio(servicio) {
        servicio.id = servicio.categoria.substring(0, 3) + (servicios.length + 1)
        if (!servicio.fotos) servicio.fotos = []
        servicios.push(servicio)

        if (syncMgr) {
            syncMgr.addServicio(servicio)
        }
        return servicio
    }

    // Update servicio
    function updateServicio(servicioId, servicioActualizado) {
        for (var i = 0; i < servicios.length; i++) {
            if (servicios[i].id === servicioId) {
                servicios[i] = servicioActualizado

                if (syncMgr) {
                    syncMgr.updateServicio(servicioActualizado)
                }
                return true
            }
        }
        return false
    }

    // Delete servicio
    function deleteServicio(servicioId) {
        for (var i = 0; i < servicios.length; i++) {
            if (servicios[i].id === servicioId) {
                servicios.splice(i, 1)

                if (syncMgr) {
                    syncMgr.deleteServicio(servicioId)
                }
                return true
            }
        }
        return false
    }

    // Add usuario (for registration)
    function addUsuario(usuario) {
        usuario.id = "user" + (usuarios.length + 1)
        usuario.fechaRegistro = new Date().toISOString().split('T')[0]
        if (!usuario.birthday) usuario.birthday = ""
        if (!usuario.telefono) usuario.telefono = ""
        usuarios.push(usuario)

        if (window.syncManager) {
            syncMgr.updateUsuario(usuario)
        }
        return usuario
    }

    // Check horario disponible
    function estaHorarioDisponible(fecha, hora) {
        for (var i = 0; i < reservas.length; i++) {
            if (reservas[i].fecha === fecha && reservas[i].hora === hora &&
                (reservas[i].estado === "confirmada" || reservas[i].estado === "pendiente")) {
                return false
            }
        }
        return true
    }

    // Count reservas by estado
    function countReservasByEstado(estado) {
        return reservas.filter(function(r) { return r.estado === estado }).length
    }
}