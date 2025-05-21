import 'package:flutter/material.dart';

void main() {
  runApp(PalletReceptionApp());
}

class PalletReceptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pallet Reception',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> pallets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pallet Reception'),
      ),
      body: ListView.builder(
        itemCount: pallets.length,
        itemBuilder: (context, index) {
          final pallet = pallets[index];
          return ListTile(
            title: Text(pallet['id'] ?? 'No ID'),
            subtitle: Text('Estado: ${pallet['estado'] ?? 'No estado'}'),
            onTap: () {
              // Acción cuando se toca un pallet
            },
          );
        },
      ),
    );
  }
}