import 'package:flutter/material.dart';
import 'api_service.dart'; // Asegúrate de importar el servicio

class AddPalletScreen extends StatefulWidget {
  @override
  _AddPalletScreenState createState() => _AddPalletScreenState();
}

class _AddPalletScreenState extends State<AddPalletScreen> {
  final _formKey = GlobalKey<FormState>();  // Para validar el formulario
  final ApiService apiService = ApiService('http://localhost:3000');

  // Controladores para los campos del formulario
  final TextEditingController idController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController tipoController = TextEditingController();
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController origenController = TextEditingController();
  final TextEditingController desdeEmpresaController = TextEditingController();
  final TextEditingController haciaEmpresaController = TextEditingController();

  // Función para enviar los datos al backend
  Future<void> _addPallet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Recoger los valores de los campos
        final palletData = {
          'id': idController.text,
          'fecha': fechaController.text,
          'tipo': tipoController.text,
          'estado': estadoController.text,
          'origen': origenController.text,
          'desde_empresa': desdeEmpresaController.text,
          'hacia_empresa': haciaEmpresaController.text,
        };

        // Llamar al servicio de API para agregar el pallet
        final response = await apiService.addPallet(palletData);

        // Mostrar mensaje de éxito
        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pallet agregado con éxito')));
        }
      } catch (e) {
        // Manejo de errores
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al agregar pallet')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Pallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Formulario de entrada de datos
              TextFormField(
                controller: idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tipoController,
                decoration: InputDecoration(labelText: 'Tipo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el tipo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: estadoController,
                decoration: InputDecoration(labelText: 'Estado'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el estado';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: origenController,
                decoration: InputDecoration(labelText: 'Origen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el origen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: desdeEmpresaController,
                decoration: InputDecoration(labelText: 'Desde Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la empresa de origen';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: haciaEmpresaController,
                decoration: InputDecoration(labelText: 'Hacia Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la empresa destino';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addPallet,
                child: Text('Agregar Pallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
