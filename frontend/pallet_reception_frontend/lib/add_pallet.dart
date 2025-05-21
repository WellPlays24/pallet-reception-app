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
  final TextEditingController estadoController = TextEditingController();
  final TextEditingController origenController = TextEditingController();
  final TextEditingController desdeEmpresaController = TextEditingController();
  final TextEditingController haciaEmpresaController = TextEditingController();

  // Variables para la selección
  String tipo = "INGRESO"; // Tipo siempre será INGRESO
  String estado = "POR_RECIBIR"; // Valor predeterminado de estado
  DateTime? selectedDate = DateTime.now();

  // Función para seleccionar la fecha usando el DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        fechaController.text = "${selectedDate!.toLocal()}".split(' ')[0];  // Formato yyyy-mm-dd
      });
  }

  // Función para enviar los datos al backend
  Future<void> _addPallet() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Recoger los valores de los campos
        final palletData = {
          'id': idController.text,
          'fecha': fechaController.text,
          'tipo': tipo,
          'estado': estado,
          'origen': origenController.text,
          'desde_empresa': desdeEmpresaController.text,
          'hacia_empresa': haciaEmpresaController.text,
        };

        // Llamar al servicio de API para agregar el pallet
        final response = await apiService.addPallet(palletData);

        // Mostrar mensaje de éxito y regresar a la lista de pallets
        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pallet agregado con éxito')));
          Navigator.pop(context); // Regresar a la pantalla anterior (lista de pallets)
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
                readOnly: true,
                onTap: () => _selectDate(context),  // Abrir el selector de fecha
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: estado,
                onChanged: (String? newValue) {
                  setState(() {
                    estado = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Estado'),
                items: <String>['POR_RECIBIR', 'RECIBIDO']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione el estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
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
