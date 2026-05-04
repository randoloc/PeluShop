-- ================================================
-- PELUSHOP - SQL PARA SUPABASE
-- Copia y pega en: https://supabase.com/dashboard → SQL Editor
-- ================================================

-- 1. Deshabilitar RLS (desarrollo)
ALTER TABLE IF EXISTS public.negocios DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.servicios DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.reservas DISABLE ROW LEVEL SECURITY;

-- 2. Crear tablas
CREATE TABLE IF NOT EXISTS public.negocios (
    id TEXT PRIMARY KEY,
    nombre TEXT NOT NULL,
    direccion TEXT,
    telefono TEXT,
    email TEXT,
    logo_url TEXT,
    horario TEXT,
    hora_apertura TEXT DEFAULT '09:00',
    hora_cierre TEXT DEFAULT '18:00',
    dias_laborales TEXT DEFAULT 'lunes,martes,miercoles,jueves,viernes',
    duracion_cita INTEGER DEFAULT 45,
    descripcion TEXT,
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.usuarios (
    id TEXT PRIMARY KEY,
    negocio_id TEXT,
    nombre TEXT NOT NULL,
    email TEXT,
    telefono TEXT,
    birthday TEXT,
    rol TEXT DEFAULT 'cliente',
    password TEXT,
    must_change_password BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.servicios (
    id TEXT PRIMARY KEY,
    negocio_id TEXT,
    nombre TEXT NOT NULL,
    categoria TEXT,
    precio INTEGER,
    duracion INTEGER,
    descripcion TEXT,
    icono TEXT,
    fotos TEXT[],
    activo BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.reservas (
    id TEXT PRIMARY KEY,
    negocio_id TEXT,
    usuario_id TEXT,
    servicio_id TEXT,
    fecha TEXT NOT NULL,
    hora TEXT NOT NULL,
    estado TEXT DEFAULT 'pendiente',
    notas TEXT,
    fecha_reserva TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Insertar datos demo
INSERT INTO public.negocios (id, nombre, telefono)
VALUES ('pelu1', 'PeluShop Demo', '+34 600 000 000')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.servicios (id, negocio_id, nombre, categoria, precio, duracion, icono)
VALUES
    ('corte1', 'pelu1', 'Corte Clasico', 'corte', 45, 45, '✂️'),
    ('corte2', 'pelu1', 'Corte Capas', 'corte', 55, 60, '💇'),
    ('corte3', 'pelu1', 'Corte Bob', 'corte', 50, 45, '👩'),
    ('color1', 'pelu1', 'Mechas', 'color', 120, 180, '🎨'),
    ('color2', 'pelu1', 'Balayage', 'color', 150, 210, '🌈'),
    ('trat1', 'pelu1', 'Hidratacion', 'tratamiento', 40, 45, '💆'),
    ('trat2', 'pelu1', 'Keratina', 'tratamiento', 80, 120, '✨')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.usuarios (id, nombre, email, rol)
VALUES
    ('admin1', 'Admin Principal', 'admin@beautybook.com', 'admin'),
    ('user1', 'Ana Garcia', 'ana@email.com', 'cliente'),
    ('user2', 'Carlos Lopez', 'carlos@email.com', 'cliente')
ON CONFLICT (id) DO NOTHING;