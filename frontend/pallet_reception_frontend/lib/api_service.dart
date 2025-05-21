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
}
