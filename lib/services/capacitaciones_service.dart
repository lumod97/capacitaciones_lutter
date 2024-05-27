import 'dart:convert';
import 'package:http/http.dart' as http;

class CapacitacionesService {
  final String baseUrl = 'http://56.10.3.24:8000/api/capacitaciones';

  // Método para realizar una solicitud GET
  Future<List<dynamic>> getCapacitaciones() async {
    final response = await http.get(Uri.parse('$baseUrl/get_capacitaciones'));

    if (response.statusCode == 200) {
      // Decodifica la respuesta JSON en una lista de áreas
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load capacitaciones');
    }
  }

  // // Método para realizar una solicitud POST
  // Future<void> createArea(Map<String, dynamic> areaData) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/areas'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(areaData),
  //   );

  //   if (response.statusCode != 201) {
  //     throw Exception('Failed to create area');
  //   }
  // }
}
