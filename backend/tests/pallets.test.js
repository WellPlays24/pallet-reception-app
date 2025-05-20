const request = require('supertest');
const { app, server } = require('../index');  // Asegúrate de que app y server se importen correctamente
const pool = require('../db'); // Asegúrate de importar el pool de conexión

// Limpiar la tabla antes de cada test
beforeEach(async () => {
  await pool.query('DELETE FROM pallets'); // Esto eliminará todos los registros de la tabla
});

describe('POST /pallets', () => {
  it('debería crear un pallet con datos válidos', async () => {
    const response = await request(app)
      .post('/pallets')
      .send({
        id: 'P123457',
        fecha: '2025-05-20',
        tipo: 'INGRESO',
        estado: 'POR_RECIBIR',
        origen: 'SALMUERA',
        desde_empresa: 'Empresa A',
        hacia_empresa: 'Empresa B',
      });

    expect(response.status).toBe(201);
    expect(response.body.id).toBe('P123457');
  });

  it('debería rechazar el pallet si falta algún campo obligatorio', async () => {
    const response = await request(app)
      .post('/pallets')
      .send({
        id: 'P123458',
        fecha: '2025-05-20',
        tipo: 'INGRESO',
        // falta estado
        origen: 'SALMUERA',
        desde_empresa: 'Empresa A',
        hacia_empresa: 'Empresa B',
      });

    expect(response.status).toBe(400);
    expect(response.body.error).toBe('Todos los campos son obligatorios');
  });
});

// Cerrar el servidor después de las pruebas
afterAll(done => {
  server.close(() => {
    done();  // Llamar a done() para asegurarse de que Jest espere el cierre del servidor
  });
});
