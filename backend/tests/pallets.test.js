const request = require('supertest');
const { app, server } = require('../index');  // Asegúrate de que app y server se importen correctamente
const pool = require('../db'); // Asegúrate de importar el pool de conexión

// Limpiar la tabla antes de cada test
beforeAll(async () => {
  // Inserta 5 pallets de prueba antes de ejecutar los tests
  const pallets = [
    { id: 'P123457', fecha: '2025-05-20', tipo: 'INGRESO', estado: 'POR_RECIBIR', origen: 'MACHALA', desde_empresa: 'Empresa A', hacia_empresa: 'Empresa B' },
    { id: 'P123458', fecha: '2025-05-21', tipo: 'INGRESO', estado: 'POR_RECIBIR', origen: 'HUAQUILLAS', desde_empresa: 'Empresa C', hacia_empresa: 'Empresa D' },
    { id: 'P123459', fecha: '2025-05-22', tipo: 'INGRESO', estado: 'POR_RECIBIR', origen: 'PASAJE', desde_empresa: 'Empresa E', hacia_empresa: 'Empresa F' },
    { id: 'P123460', fecha: '2025-05-23', tipo: 'INGRESO', estado: 'POR_RECIBIR', origen: 'SANTA ELENA', desde_empresa: 'Empresa G', hacia_empresa: 'Empresa H' },
    { id: 'P123461', fecha: '2025-05-24', tipo: 'INGRESO', estado: 'POR_RECIBIR', origen: 'NARANJAL', desde_empresa: 'Empresa I', hacia_empresa: 'Empresa J' }
  ];

  // Insertar los pallets de prueba en la base de datos
  for (const pallet of pallets) {
    await pool.query(
      `INSERT INTO pallets (id, fecha, tipo, estado, origen, desde_empresa, hacia_empresa) 
       VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [pallet.id, pallet.fecha, pallet.tipo, pallet.estado, pallet.origen, pallet.desde_empresa, pallet.hacia_empresa]
    );
  }
});

// Limpiar la base de datos después de todas las pruebas (opcional)
//afterAll(async () => {
//  await pool.query('DELETE FROM pallets');
//  await server.close();
//});

describe('POST /pallets', () => {
  it('debería crear un pallet con datos válidos', async () => {
    const response = await request(app)
      .post('/pallets')
      .send({
        id: 'P123462',
        fecha: '2025-05-25',
        tipo: 'INGRESO',
        estado: 'POR_RECIBIR',
        origen: 'SALMUERA',
        desde_empresa: 'Empresa K',
        hacia_empresa: 'Empresa L',
      });

    expect(response.status).toBe(201);
    expect(response.body.id).toBe('P123462');
  });

  it('debería rechazar el pallet si falta algún campo obligatorio', async () => {
    const response = await request(app)
      .post('/pallets')
      .send({
        id: 'P123463',
        fecha: '2025-05-26',
        tipo: 'INGRESO',
        // falta estado
        origen: 'SALMUERA',
        desde_empresa: 'Empresa M',
        hacia_empresa: 'Empresa N',
      });

    expect(response.status).toBe(400);
    expect(response.body.error).toBe('Todos los campos son obligatorios');
  });
});
