-- Ejecutar en Supabase Dashboard -> SQL Editor
-- Agregar columnas password y must_change_password a usuarios

ALTER TABLE IF EXISTS public.usuarios 
ADD COLUMN IF NOT EXISTS password TEXT,
ADD COLUMN IF NOT EXISTS must_change_password BOOLEAN DEFAULT false;

-- Agregar columnas faltantes a negocios para el flujo completo
ALTER TABLE IF EXISTS public.negocios 
ADD COLUMN IF NOT EXISTS hora_apertura TEXT DEFAULT '09:00',
ADD COLUMN IF NOT EXISTS hora_cierre TEXT DEFAULT '18:00',
ADD COLUMN IF NOT EXISTS dias_laborales TEXT DEFAULT 'lunes,martes,miercoles,jueves,viernes',
ADD COLUMN IF NOT EXISTS duracion_cita INTEGER DEFAULT 45,
ADD COLUMN IF NOT EXISTS descripcion TEXT,
ADD COLUMN IF NOT EXISTS notas TEXT;

-- Verificar estructura
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'usuarios' 
ORDER BY ordinal_position;
