# BeautyBook - Guía de Compilación

## Requisitos
- Qt Creator (incluido en Qt 6.10.0)
- Android SDK Configurado

## Compilar para Android APK

### Pasos en Qt Creator:

1. **Abrir Proyecto**
   - Abrir `beauty-booking.pro` en Qt Creator

2. **Configurar Kit**
   - Ir a `Projects` → `Manage Kits`
   - Asegurarse que `Android (Qt 6.10.0)` esté configurado

3. **Seleccionar Destino**
   - En toolbar, seleccionar `Android` como destino

4. **Compilar**
   - `Build` → `Build Project "beauty-booking"`
   - o `Ctrl+B`

5. **Ejecutar**
   - `Build` → `Run` o `Ctrl+R`
   - Conectar dispositivo Android o usar emulador

### Compilar-release APK:

```
Build → Build All
```

El APK se generará en:
```
build-android/.../lib/armeabi-v7a/libbeauty-booking.so
```

---

## Compilar para Web (experimental)

### Opción 1: Qt WebAssembly

**Requisitos:**
- Emscripten SDK instalado

```bash
# Install emsdk
git clone https://github.com/emscripten-core/emsdk.git
cd emsdk
./emsdk install latest
./emsdk activate latest
source ./emsdk_env.sh

# Compile in Qt Creator
# Select "WebAssembly" as target
# Build
```

### Opción 2: PWA con Next.js (RECOMENDADO)

Dado que Qt WebAssembly requiere Emscripten y no está instalado, la alternativa más práctica es crear una PWA:

```bash
cd beauty-booking-web
npx create-next-app@latest .
# Copiar lógica de Firebase de firebase/functions/
# La app se conecta al mismo backend
```

---

## Compilar para iOS

### Requiere:
- Xcode instalado (ya disponible)

### Pasos:
1. Seleccionar `iOS` como destino en Qt Creator
2. `Build` → `Build Project`
3. Para ejecutar en device: `Build` → `Run`

---

## Estado del Proyecto

| Target | Estado | Notas |
|-------|--------|-------|
| Android | Listo para compilar | Requiere Qt Creator |
| iOS | Listo para compilar | Requiere Xcode |
| WebAssembly | Pendiente | Requiere Emscripten |
| Web (PWA) | Alternativa | Más sencillo |

---

## Problemas Comunes

### "Unknown module(s) in QT: json"
- SOLUCIONADO: Eliminado `json` de QT +=

### "QGuiApplication not found"
- El LSP muestra errores pero compilará en Qt Creator
- Son errores de Index no configurado

### Emscripten no encontrado
- Instalar: `brew install emscripten`
- O usar alternativa PWA