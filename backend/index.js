const express = require('express');
const cors = require('cors');
const supabase = require('./supabase');

const app = express();
app.use(cors());
app.use(express.json());

// Get all servicios
app.get('/api/servicios', async (req, res) => {
  try {
    const { data, error } = await supabase.from('servicios').select('*');
    if (error) throw error;
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get usuarios
app.get('/api/usuarios', async (req, res) => {
  try {
    const { data, error } = await supabase.from('usuarios').select('*');
    if (error) throw error;
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get reservas
app.get('/api/reservas', async (req, res) => {
  try {
    const { data, error } = await supabase.from('reservas').select('*');
    if (error) throw error;
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Create reserva
app.post('/api/reservas', async (req, res) => {
  try {
    const { usuarioId, servicioId, fecha, hora, estado } = req.body;
    const { data, error } = await supabase.from('reservas').insert([
      { usuario_id: usuarioId, servicio_id: servicioId, fecha, hora, estado: estado || 'pendiente' }
    ]).select();
    if (error) throw error;
    res.json(data[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Update reserva estado
app.patch('/api/reservas/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;
    const { data, error } = await supabase.from('reservas').update({ estado }).eq('id', id).select();
    if (error) throw error;
    res.json(data[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Create usuario
app.post('/api/usuarios', async (req, res) => {
  try {
    const { nombre, email, rol, birthday } = req.body;
    const { data, error } = await supabase.from('usuarios').insert([
      { nombre, email, rol: rol || 'cliente', birthday: birthday || '' }
    ]).select();
    if (error) throw error;
    res.json(data[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Update usuario birthday
app.patch('/api/usuarios/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { birthday, nombre } = req.body;
    const { data, error } = await supabase.from('usuarios').update({ birthday, nombre }).eq('id', id).select();
    if (error) throw error;
    res.json(data[0]);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));