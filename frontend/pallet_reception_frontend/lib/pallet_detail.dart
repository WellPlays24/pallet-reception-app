import 'package:flutter/material.dart';

class PalletDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pallet;

  PalletDetailScreen({required this.pallet});

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
            Text('ID: ${pallet['id']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Fecha: ${pallet['fecha']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Tipo: ${pallet['tipo']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Estado: ${pallet['estado']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Origen: ${pallet['origen']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Desde Empresa: ${pallet['desde_empresa']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Hacia Empresa: ${pallet['hacia_empresa']}', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
