# Sistema de Reservación para Peluquería Femenina

## Propuesta Técnica Completa

> **Nota:** Este proyecto es para una **peluquería/salón de belleza femenino**, no barbería masculina.

---

## 1. Visión del Proyecto

**Nombre:** BeautyBook - Sistema de Reservación de Turnos  
**Tipo:** Aplicación multiplataforma (Web + Android + iOS)  
**Stack Principal:** Qt6 C++ + Firebase

### Objetivos del Negocio
- Permitir que clientas visualicen servicios especializados para mujeres
- Mostrar precios y tiempos aproximados por servicio (servicios de color duran más)
- Selección de color, mechas, técnicas especiales
- Reservas con fecha/hora disponibles
- Confirmación via SMS/WhatsApp/Email
- Multi-administrador (varias estilistas/admin pueden gestionar)
- Catálogo organizado por categorías especializadas

---

## 2. Análisis del Mercado

### Competidores Existentes
| App | Costo/Mes | Fortalezas | Debilidades |
|-----|-----------|-----------|-----------|
| **theCut** | ~$0-20 | 10M usuarios, discovery | No ofrece sistema completo sin marketplace |
| **Booksy** | $29.99+ | Completo | Caro para negocios pequeños |
| **Vagaro** | $30+ | Multi-features | Costs altos |
| **Barbercita** | $35 | Propia app en stores | Sin opciones gratuitas |

### Propuesta de Valor Diferenciada
- **Gratis** (Firebase Spark tier)
- **Propio** - Sin dependencia de marketplace
- **Control total** - Datos propios
- **Multi-admin** - Varios administradores

---

## 3. Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────┐
│                   CLIENTE (WEB/PWA)                  │
└──────────────────┬──────────────────────────────┘
                   │ HTTPS
┌──────────────────▼──────────────────────────────┐
│              FIREBASE HOSTING                   │
│  ┌─────────────┐  ┌──────────────────────┐   │
│  │ Static    │  │ Cloud Functions     │   │
│  │ Web App   │  │ (Notifications)   │   │
│  └──────────┘  └──────────────────────┘   │
│  ┌───────────────────────────────────────┐ │
│  │ Firestore (Realtime Database)          │ │
│  └───────────────────────────────────────┘ │
└──────────────────┬──────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
┌───────▼───────┐    ┌───────▼───────┐
│    Android    │    │     iOS       │
│   (Qt6)      │    │    (Qt6)     │
└──────────────┘    └──────────────┘
```

---

## 4. Stack Tecnológico

### Frontend Móvil (Qt6 C++)

| Componente | Tecnología | Versión |
|------------|------------|---------|
| **Qt Framework** | Qt6 | 6.10.0 |
| **Networking** | Qt Network Auth | Built-in |
| **JSON** | QJson | Built-in |
| **Database** | Firebase C++ SDK | Latest |
| **Notifications** | Firebase Cloud Messaging | Latest |
| **UI** | Qt Quick (QML) | Built-in |

### Backend (Firebase)

| Servicio | Uso | Tier |
|----------|-----|------|
| **Authentication** | Login admins | Gratis |
| **Firestore** | Base de datos | Gratis (1GB) |
| **Cloud Functions** | Notificaciones | Pay-per-use |
| **Hosting** | Web app | Gratis (1GB) |
| **Cloud Storage** | Imágenes servicios | Gratis (5GB) |

### Frontend Web

| Componente | Tecnología |
|------------|------------|
| **Framework** | Next.js 14 |
| **Styling** | Tailwind CSS |
| **UI** | shadcn/ui |
| **State** | React Query |

---

## 5. Estructura de Datos Firestore

### Colecciones

```javascript
// users - Administradores/peluqueros
{
  uid: string,
  nombre: string,
  telefono: string,
  email: string,
  rol: "admin" | "barbero",
  fotoPerfil: string,
  activo: boolean,
  creadoEn: timestamp
}

// servicios - Catálogo de servicios (Peluquería Femenina)
{
  id: string,
  nombre: string,                    // ej: "Corte clásicas", "Mechas completas", "Balayage"
  descripcion: string,               // Detalles del servicio
  categoria: "corte" | "color" | "tratamiento" | "peinado" | "manicure" | "otro",
  precio: number,                 // $30-200+
  duracionMinutos: number,         // 30-240 min para color
  imagenes: string[],            // Fotos del trabajo
  requiereColor: boolean,        // true para servicios de color
  requiereLargo: boolean,     // 需要 largo de pelo
  precioLargo: number | null,  // Precio extra para cabello largo
  activo: boolean,
  creadoPor: string,
  actualizadoEn: timestamp
}

// disponibilidad - Horarios disponibles por admin
{
  adminId: string,
  diaSemana: 0-6,
  horaInicio: "09:00",
  horaFin: "19:00",
  activo: boolean
}

// reservas - Turnos reservados
{
  id: string,
  clienteNombre: string,
  clienteTelefono: string,
  clienteEmail: string,
  servicioId: string,
  servicioNombre: string,
  color: string | null,
  adminId: string,
  fecha: timestamp,
  hora: string,
  estado: "pendiente" | "confirmada" | "completada" | "cancelada",
  notas: string,
  creadoEn: timestamp
}
```

---

## 6. Módulos y Funcionalidades

### Módulo 1: Autenticación
- [ ] Login con email/password
- [ ] Reset password
- [ ] Logout
- [ ] Protección de rutas

### Módulo 2:Catálogo de Servicios (Femenino)
- [ ] Listar servicios por categoría (corte, color, tratamiento, peinado, manicure)
- [ ] Ver detalle con imágenes del trabajo
- [ ] Filtrar por tipo/precio/duración
- [ ] Selección de largo de cabello (corto/largo)
- [ ] Selector de color (para servicios que lo requieren)
- [ ] Ver tiempo estimado total

### Módulo 3: Administración de Servicios (Admin)
- [ ] CRUD servicios
- [ ] Subir imágenes
- [ ] Configurar disponibilidad
- [ ] Gestionar reservas

### Módulo 4:Reservaciones
- [ ] Seleccionar servicio
- [ ] Seleccionar color (si aplica)
- [ ] Ver fechas disponibles
- [ ] Seleccionar horario
- [ ] Confirmar reserva

### Módulo 5: Notificaciones
- [ ] Nueva reserva → Admin
- [ ] Confirmar → Cliente (SMS/WhatsApp/Email)
- [ ] Recordatorio

### Módulo 6:Gestión Admin
- [ ] Dashboard de reservas
- [ ] Aceptar/rechazar reserva
- [ ] Ver historial clientes

---

## 7. Firebase Cloud Functions

```javascript
// functions/index.js

// Enviar notificación a admin cuando hay nueva reserva
exports.onNuevaReserva = functions.firestore
  .document('reservas/{reservaId}')
  .onCreate(async (snap, context) => {
    const reserva = snap.data();
    // Enviar push notification al admin
    // Enviar SMS via Twilio
  });

// Confirmar reserva - notificar cliente
exports.confirmarReserva = functions.https.onCall(async (data, context) => {
  // Actualizar estado
  // Notificar cliente
});
```

---

## 8. API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| GET | /api/servicios | Listar servicios |
| POST | /api/reservas | Crear reserva |
| GET | /api/reservas/{id} | Ver reserva |
| PUT | /api/reservas/{id}/confirmar | Confirmar reserva |
| GET | /api/disponibilidad | Fechas disponibles |

---

## 9. Plan de Testing

### Testing Unitario
- **Framework:** Qt Test (built-in) + Google Test
- **Coverage target:** 80%+
- **Módulos a testar:**
  - AuthManager
  - ServicioRepository
  - ReservaManager
  - DisponibilidadCalculator

### Testing de Integración
- **Firebase Emulator Suite**
- **Mock APIs** para desarrollo offline

### Testing E2E (Web)
- **Playwright**
- **Escenarios:**
  1. Usuario reserva servicio completo
  2. Admin confirma reserva
  3. Cliente recibe notificación

### Device Testing
| Dispositivo | Android | iOS |
|------------|--------|-----|
| Emulator | Qt Android | XCode Simulator |
| Real | USB Debug | USB Debug |

---

## 10. Milestones

| Milestone | Entregable | Duración |
|-----------|-----------|----------|
| **M1** | Setup proyecto + Firebase | 1 día |
| **M2** | UIbase Qt6 + Auth | 2 días |
| **M3** | Catálogo servicios | 2 días |
| **M4** | Reserva flow + Firestore | 2 días |
| **M5** | Notificaciones | 1 día |
| **M6** | Web PWA | 2 días |
| **M7** | Testing + Bugfix | 2 días |
| **Total** | **App completa** | **~12 días** |

---

## 11. Requisitos del Sistema

### Desarrollo
- macOS 12.7+ (Monterey)
- Xcode 15+ (para iOS)
- Android Studio (para Android)
- Node.js 18+
- Firebase CLI

### Build Targets
- Android APK (minSdk 24)
- iOS Simulator/Device
- Web PWA

---

## 12. Presupuesto Estimado

| Recurso | Costo |
|--------|-------|
| Firebase | $0-25/mes (depends uso) |
| Dominio | ~$10/año |
| Twilio (SMS) | $0 (creditos gratis) |
| **Total mensual** | **~$0-25** |

---

## 13. Próximos Pasos

1. ✅ Confirmar propuesta
2. ⏳ Setup Firebase proyecto
3. ⏳ Inicializar repo Git
4. ⏳ Qt6 project setup
5. ⏳ M1-M7 implementación

---

**Propuesta creada:** $(date)