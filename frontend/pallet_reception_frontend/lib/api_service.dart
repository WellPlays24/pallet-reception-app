import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Método para obtener los pallets
  Future<List<Map<String, dynamic>>> getPallets() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pallets'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((pallet) => pallet as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load pallets');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Método para agregar un nuevo pallet
Future<Map<String, dynamic>?> addPallet(Map<String, dynamic> palletData) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/pallets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(palletData),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add pallet');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}


// Método para actualizar el estado de un pallet
Future<Map<String, dynamic>?> updatePalletEstado(String id, Map<String, dynamic> palletData) async {
  try {
    final response = await http.patch(
      Uri.parse('$baseUrl/pallets/$id/estado'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(palletData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update pallet status');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}



}
