import 'package:flutter/material.dart';
import 'api_service.dart';  // Asegúrate de importar el servicio

class PalletDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pallet;
  final Function refreshList; // Callback para actualizar la lista de pallets

  PalletDetailScreen({required this.pallet, required this.refreshList});

  @override
  _PalletDetailScreenState createState() => _PalletDetailScreenState();
}

class _PalletDetailScreenState extends State<PalletDetailScreen> {
  late String estado;

  @override
  void initState() {
    super.initState();
    estado = widget.pallet['estado'] ?? 'POR_RECIBIR';  // Establecer el estado inicial
  }

  // Función para actualizar el estado del pallet
  Future<void> _updateEstado() async {
    try {
      final palletData = {
        'estado': estado,
      };

      // Llamar al servicio de API para actualizar el estado
      final response = await ApiService('http://localhost:3000').updatePalletEstado(widget.pallet['id'], palletData);

      // Verificar si la actualización fue exitosa
      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Estado actualizado con éxito')));
        widget.refreshList();  // Llamar al callback para actualizar la lista
        Navigator.pop(context); // Regresar a la lista de pallets
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el estado')));
    }
  }

  // Función para eliminar el pallet
  Future<void> _deletePallet() async {
    try {
      final response = await ApiService('http://localhost:3000').deletePallet(widget.pallet['id']);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pallet eliminado con éxito')));
        widget.refreshList();  // Llamar al callback para actualizar la lista
        Navigator.pop(context); // Regresar a la lista de pallets
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar el pallet')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Pallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ID: ${widget.pallet['id']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Fecha: ${widget.pallet['fecha']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Tipo: ${widget.pallet['tipo']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Estado: ${widget.pallet['estado']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Origen: ${widget.pallet['origen']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Desde Empresa: ${widget.pallet['desde_empresa']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Hacia Empresa: ${widget.pallet['hacia_empresa']}', style: TextStyle(fontSize: 16)),

            // DropdownButton para seleccionar el nuevo estado
            SizedBox(height: 20),
            DropdownButton<String>(
              value: estado,
              onChanged: (String? newValue) {
                setState(() {
                  estado = newValue!;
                });
              },
              items: <String>['POR_RECIBIR', 'RECIBIDO']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEstado,
              child: Text('Actualizar Estado'),
            ),

            // Botón para eliminar el pallet
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deletePallet,
              child: Text('Eliminar Pallet'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
