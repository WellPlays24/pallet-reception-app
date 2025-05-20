const express = require('express');
const cors = require('cors');
require('dotenv').config();
const pool = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

// Ruta base para probar
app.get('/', (req, res) => {
  res.send('API Pallets funcionando');
});

// Obtener todos los pallets
app.get('/pallets', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM pallets ORDER BY fecha DESC');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener pallets' });
  }
});

// Obtener pallet por id
app.get('/pallets/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM pallets WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Pallet no encontrado' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al obtener pallet' });
  }
});

// Crear pallet
app.post('/pallets', async (req, res) => {
  try {
    const { id, fecha, tipo, estado, origen, desde_empresa, hacia_empresa } = req.body;
    if (!id || !fecha || !tipo || !estado || !origen || !desde_empresa || !hacia_empresa) {
      return res.status(400).json({ error: 'Faltan campos requeridos' });
    }
    // Insertar pallet
    const result = await pool.query(
      `INSERT INTO pallets (id, fecha, tipo, estado, origen, desde_empresa, hacia_empresa)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [id, fecha, tipo, estado, origen, desde_empresa, hacia_empresa]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al crear pallet' });
  }
});

// Actualizar estado (solo estado)
app.patch('/pallets/:id/estado', async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;
    if (!estado || !['POR_RECIBIR', 'RECIBIDO'].includes(estado)) {
      return res.status(400).json({ error: 'Estado inválido' });
    }
    const result = await pool.query(
      `UPDATE pallets SET estado = $1 WHERE id = $2 RETURNING *`,
      [estado, id]
    );
    if (result.rows.length === 0) return res.status(404).json({ error: 'Pallet no encontrado' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al actualizar estado' });
  }
});

// Eliminar pallet
app.delete('/pallets/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('DELETE FROM pallets WHERE id = $1 RETURNING *', [id]);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Pallet no encontrado' });
    res.json({ mensaje: 'Pallet eliminado correctamente' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error al eliminar pallet' });
  }
});

app.listen(PORT, () => {
  console.log(`Servidor escuchando en puerto ${PORT}`);
});
