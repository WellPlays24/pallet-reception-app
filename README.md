# Pallet Reception App

## Descripción

Este proyecto es una aplicación de gestión de pallets desarrollada con **Flutter** para el frontend y **Node.js** con **PostgreSQL** para el backend. Permite a los operarios gestionar la recepción de pallets, agregar nuevos pallets, ver los detalles de los pallets, cambiar el estado de los pallets y eliminar pallets.

## Tecnologías

- Frontend: 
  - Flutter
  - Dart
- Backend: 
  - Node.js
  - Express
  - PostgreSQL
- Pruebas:
  - Jest (Backend)
  - Postman (Pruebas de API)

## Requisitos

Para ejecutar este proyecto, se necesita tener las siguientes herramientas instaladas:

- Node.js (para ejecutar el backend)
- Flutter (para ejecutar el frontend)
- PostgreSQL (para la base de datos)

## Instalación

## Backend (Node.js + PostgreSQL)

1. Clonar este repositorio:

   - git clone https://github.com/WellPlays24/pallet-reception-app.git

2. Navegar a la carpeta del backend:

    - cd .\backend\

3. Instalar las dependencias del backend:

    - npm install

4. Configurar la base de datos PostgreSQL:
    Asegurarse de tener una base de datos PostgreSQL configurada y corriendo.
    Crear una base de datos llamada palletdb 
    Asegurarse de tener la tabla de pallets creada con el siguiente esquema:

    CREATE TABLE pallets (
        id SERIAL PRIMARY KEY,
        fecha DATE NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        estado VARCHAR(50) NOT NULL,
        origen VARCHAR(50) NOT NULL,
        desde_empresa VARCHAR(50) NOT NULL,
        hacia_empresa VARCHAR(50) NOT NULL
    );

5. Ejecutar el servidor backend:

    - npm run dev
    El servidor backend estará disponible en http://localhost:3000.


## Frontend (Flutter)

1. Navegar a la carpeta del frontend:

    - cd .\frontend\pallet_reception_frontend\

2. Instalar las dependencias de Flutter:

    - flutter pub get

3. Ejecutar el frontend:

    - flutter run -d chrome
    Esto abrirá la aplicación en el navegador.


## Funcionalidades

    - Ver lista de pallets: Muestra todos los pallets registrados en la base de datos.

    - Agregar un nuevo pallet: Permite agregar un nuevo pallet proporcionando la información requerida (fecha, estado, origen, etc.).

    - Ver detalles de un pallet: Muestra información detallada sobre un pallet específico.

    - Cambiar el estado de un pallet: Permite cambiar el estado de un pallet de "POR_RECIBIR" a "RECIBIDO".

    - Eliminar un pallet: Permite eliminar un pallet de la base de datos.

    




