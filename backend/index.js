const express = require('express');
const cors = require('cors');
require('dotenv').config();
const pool = require('./db');
const http = require('http');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('API Pallets funcionando');
});

// Crear el servidor HTTP
const server = http.createServer(app);


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

    // Validar campos requeridos
    if (!id || !fecha || !tipo || !estado || !origen || !desde_empresa || !hacia_empresa) {
      return res.status(400).json({ error: 'Todos los campos son obligatorios' });
    }

    // Validar tipo fijo
    if (tipo !== 'INGRESO') {
      return res.status(400).json({ error: 'Tipo debe ser "INGRESO"' });
    }

    // Validar estado válido
    const estadosValidos = ['POR_RECIBIR', 'RECIBIDO'];
    if (!estadosValidos.includes(estado)) {
      return res.status(400).json({ error: `Estado inválido. Debe ser uno de: ${estadosValidos.join(', ')}` });
    }

    // Validar fecha válida
    if (isNaN(Date.parse(fecha))) {
      return res.status(400).json({ error: 'Fecha inválida' });
    }

    // Insertar pallet
    const result = await pool.query(
      `INSERT INTO pallets (id, fecha, tipo, estado, origen, desde_empresa, hacia_empresa)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [id, fecha, tipo, estado, origen, desde_empresa, hacia_empresa]
    );

    res.status(201).json(result.rows[0]);

  } catch (err) {
    console.error('Error al crear el pallet:', err); // Mejor mensaje de error

    if (err.code === '23505') { // error de clave primaria duplicada
      return res.status(409).json({ error: 'El ID del pallet ya existe' });
    }
    res.status(500).json({ error: 'Error al crear pallet', details: err.message || err });
  }
});


// Actualizar pallet
app.patch('/pallets/:id/estado', async (req, res) => {
  try {
    const { id } = req.params;
    const { estado } = req.body;

    // Validar que estado esté presente
    if (!estado) {
      return res.status(400).json({ error: 'El campo estado es obligatorio' });
    }

    // Validar valores permitidos
    const estadosValidos = ['POR_RECIBIR', 'RECIBIDO'];
    if (!estadosValidos.includes(estado)) {
      return res.status(400).json({ error: `Estado inválido. Debe ser uno de: ${estadosValidos.join(', ')}` });
    }

    const result = await pool.query(
      `UPDATE pallets SET estado = $1 WHERE id = $2 RETURNING *`,
      [estado, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Pallet no encontrado' });
    }

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

// Servidor que podemos cerrar en las pruebas
if (process.env.NODE_ENV !== 'test') {
  server.listen(PORT, () => {
    console.log(`Servidor escuchando en puerto ${PORT}`);
  });
}

// Exportar app y server para pruebas
module.exports = { app, server };
