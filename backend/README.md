# Beauty Booking - Backend

Express + Supabase backend para la aplicación de reserva de barbería/peluquería.

## Setup

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your Supabase anon key
npm start
```

##API Endpoints

| Método | Ruta | Descripción |
|--------|------|------------|
| GET | /api/servicios | Listar servicios |
| GET | /api/usuarios | Listar usuarios |
| GET | /api/reservas | Listar reservas |
| POST | /api/reservas | Crear reserva |
| POST | /api/usuarios | Crear usuario |
| PATCH | /api/reservas/:id | Actualizar estado |
| PATCH | /api/usuarios/:id | Actualizar usuario |

## Configuración Supabase

1. Crea un proyecto en Supabase
2. Copia la URL del proyecto: `https://ubmjcdmzfelgmyjuowgf.supabase.co`
3. En Settings > API, copia la anon key
4. Pega en `.env`

## Tablas necesarias

```sql
-- usuarios
create table usuarios (
  id text primary key,
  nombre text not null,
  email text unique,
  rol text default 'cliente',
  birthday text,
  fecha_registro text
);

-- servicios
create table servicios (
  id text primary key,
  nombre text not null,
  categoria text,
  precio numeric,
  duracion numeric,
  descripcion text,
  icono text);

-- reservas
create table reservas (
  id text primary key,
  usuario_id text references usuarios(id),
  servicio_id text references servicios(id),
  fecha text,
  hora text,
  estado text default 'pendiente',
  fecha_reserva text);
```