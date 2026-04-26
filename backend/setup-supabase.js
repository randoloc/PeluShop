const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const path = require('path');

const supabaseUrl = 'https://ubmjcdmzfelgmyjuowgf.supabase.co';
const supabaseKey = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVibWpjZG16ZmVsZ215anVvd2dmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzcwNjU3MzQsImV4cCI6MjA5MjY0MTczNH0.SxJ0iVqTp1DItbDQ4YUuysK1gg_6n3HCmT4KtPtMFkE';

const supabase = createClient(supabaseUrl, supabaseKey);

async function setupTables() {
  console.log('🎨 Setting up PeluShop tables in Supabase...\n');

  // Try to create tables using raw SQL via pg
  // Note: This requires service_role key with admin privileges
  
  const tables = [
    {
      name: 'negocios',
      sql: `CREATE TABLE IF NOT EXISTS public.negocios (
        id TEXT PRIMARY KEY,
        nombre TEXT NOT NULL,
        direccion TEXT,
        telefono TEXT,
        email TEXT,
        logo_url TEXT,
        horario TEXT,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`
    },
    {
      name: 'usuarios', 
      sql: `CREATE TABLE IF NOT EXISTS public.usuarios (
        id TEXT PRIMARY KEY,
        negocio_id TEXT REFERENCES public.negocios(id),
        nombre TEXT NOT NULL,
        email TEXT,
        telefono TEXT,
        birthday TEXT,
        rol TEXT DEFAULT 'cliente',
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`
    },
    {
      name: 'servicios',
      sql: `CREATE TABLE IF NOT EXISTS public.servicios (
        id TEXT PRIMARY KEY,
        negocio_id TEXT REFERENCES public.negocios(id),
        nombre TEXT NOT NULL,
        categoria TEXT,
        precio INTEGER,
        duracion INTEGER,
        descripcion TEXT,
        icono TEXT,
        fotos TEXT[],
        activo BOOLEAN DEFAULT true,
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`
    },
    {
      name: 'reservas',
      sql: `CREATE TABLE IF NOT EXISTS public.reservas (
        id TEXT PRIMARY KEY,
        negocio_id TEXT REFERENCES public.negocios(id),
        usuario_id TEXT REFERENCES public.usuarios(id),
        servicio_id TEXT REFERENCES public.servicios(id),
        fecha TEXT NOT NULL,
        hora TEXT NOT NULL,
        estado TEXT DEFAULT 'pendiente',
        notas TEXT,
        fecha_reserva TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
      );`
    }
  ];

  for (const table of tables) {
    console.log(`Creating table: ${table.name}...`);
    
    try {
      // Use REST API to insert dummy record - if it fails, table doesn't exist
      const { error } = await supabase
        .from(table.name)
        .insert([{ id: 'test', nombre: 'test' }])
        .select();

      if (error && error.message.includes('does not exist')) {
        console.log(`❌ Table '${table.name}' does not exist.`);
        console.log(`   Please run this SQL in Supabase SQL Editor:`);
        console.log(`   ${table.sql}\n`);
      } else {
        console.log(`✅ Table '${table.name}' exists`);
      }
    } catch (e) {
      console.log(`⚠️  ${e.message}`);
    }
  }

  // Insert demo data
  console.log('\n📦 Inserting demo data...');
  
  const { error: negocioError } = await supabase
    .from('negocios')
    .upsert([{ id: 'pelu1', nombre: 'PeluShop Demo', telefono: '+34 600 000 000' }]);

  if (negocioError) {
    console.log('⚠️  Could not insert demo negocio:', negocioError.message);
  } else {
    console.log('✅ Demo negocio created');
  }

  // Insert demo services
  const servicios = [
    { id: 'corte1', negocio_id: 'pelu1', nombre: 'Corte Clasico', categoria: 'corte', precio: 45, duracion: 45, icono: '✂️' },
    { id: 'corte2', negocio_id: 'pelu1', nombre: 'Corte Capas', categoria: 'corte', precio: 55, duracion: 60, icono: '💇' },
    { id: 'color1', negocio_id: 'pelu1', nombre: 'Mechas', categoria: 'color', precio: 120, duracion: 180, icono: '🎨' },
    { id: 'trat1', negocio_id: 'pelu1', nombre: 'Hidratacion', categoria: 'tratamiento', precio: 40, duracion: 45, icono: '💆' }
  ];

  const { error: serviciosError } = await supabase
    .from('servicios')
    .upsert(servicios);

  if (serviciosError) {
    console.log('⚠️  Could not insert servicios:', serviciosError.message);
  } else {
    console.log('✅ Demo servicios created');
  }

  console.log('\n🎉 Setup complete!');
}

setupTables().catch(console.error);