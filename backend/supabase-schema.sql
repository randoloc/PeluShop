-- Tablas para Beauty Booking en Supabase

-- 1. Tabla usuarios
create table if not exists usuarios (
  id text primary key,
  nombre text not null,
  email text unique,
  rol text default 'cliente',
  birthday text,
  fecha_registro text
);

-- 2. Tabla servicios
create table if not exists servicios (
  id text primary key,
  nombre text not null,
  categoria text,
  precio numeric,
  duracion numeric,
  descripcion text,
  icono text,
  fotos text[]
);

-- 3. Tabla reservas
create table if not exists reservas (
  id text primary key,
  usuario_id text references usuarios(id),
  servicio_id text references servicios(id),
  fecha text,
  hora text,
  estado text default 'pendiente',
  fecha_reserva text
);

-- Insertar datos iniciales - Servicios
insert into servicios (id, nombre, categoria, precio, duracion, descripcion, icono) values
('corte1', 'Corte Clasico', 'corte', 45, 45, 'Corte tradicional con tijeras y peinado', '✂️'),
('corte2', 'Corte Capas', 'corte', 55, 60, 'Corte en capas con volumen y movimiento', '💇'),
('corte3', 'Corte Bob', 'corte', 50, 45, 'Corte estilo bob moderno y elegante', '👩'),
('color1', 'Mechas', 'color', 120, 180, 'Mechas californianas naturales', '🎨'),
('color2', 'Balayage', 'color', 150, 210, 'Tecnica de pintura para look natural', '🌈'),
('trat1', 'Hidratacion', 'tratamiento', 40, 45, 'Tratamiento intensivo de hidratacion profunda', '💆'),
('trat2', 'Keratina', 'tratamiento', 80, 120, 'Queratina brasileira para cabello liso', '✨')
on conflict do nothing;

-- Insertar usuario admin por defecto
insert into usuarios (id, nombre, email, rol, birthday) values
('admin1', 'Admin Principal', 'admin@beautybook.com', 'admin', '')
on conflict do nothing;