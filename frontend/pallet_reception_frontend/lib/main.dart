import 'package:flutter/material.dart';
import 'api_service.dart'; // Asegúrate de importar el servicio

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
  bool isLoading = true;

  // Crear una instancia del ApiService
  final ApiService apiService = ApiService('http://localhost:3000');

  @override
  void initState() {
    super.initState();
    _fetchPallets();
  }

  // Función para obtener los pallets
  Future<void> _fetchPallets() async {
    try {
      final List<Map<String, dynamic>> fetchedPallets = await apiService.getPallets();
      setState(() {
        pallets = fetchedPallets;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching pallets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pallet Reception'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Spinner de carga
          : ListView.builder(
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
