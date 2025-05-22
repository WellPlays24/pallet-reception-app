import 'package:flutter/material.dart';
import 'add_pallet.dart';
import 'pallet_detail.dart';
import 'api_service.dart';

void main() {
  runApp(PalletReceptionApp());
}

class PalletReceptionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recepción de Pallets',
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
        title: Text('Recepción de Pallets'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Spinner de carga
          : Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla de agregar pallet y pasar el callback
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPalletScreen(
                          refreshList: _fetchPallets, // Pasar la función refreshList
                        ),
                      ),
                    );
                  },
                  child: Text('Agregar Nuevo Pallet'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pallets.length,
                    itemBuilder: (context, index) {
                      final pallet = pallets[index];
                      return ListTile(
                        title: Text(pallet['id'] ?? 'No ID'),
                        subtitle: Text('Estado: ${pallet['estado'] ?? 'No estado'}'),
                        onTap: () {
                          // Navegar a la pantalla de detalles y pasar refreshList
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PalletDetailScreen(
                                pallet: pallet,
                                refreshList: _fetchPallets,  // Pasar la función refreshList
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
