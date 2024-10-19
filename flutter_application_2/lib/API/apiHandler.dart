import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHandler {
  final String baseUrl = "https://rotaoeste.free.beeceptor.com/"; // url padrao

  // Método GET
  Future<List<T>> get<T>(String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.get(Uri.parse('$endpoint'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => fromJson(json)).toList();
    } else {
      throw Exception("Erro ao buscar dados");
    }
  }

  // Método POST
  Future<T> post<T>(String endpoint, Map<String, dynamic> data, T Function(Map<String, dynamic>) fromJson) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode == 201) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception("Erro ao enviar dados");
    }
  }

  // Método PUT
  Future<void> put(String endpoint, int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar dados");
    }
  }

  // Método DELETE
  Future<void> delete(String endpoint, int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint/$id'));
    if (response.statusCode != 204) {
      throw Exception("Erro ao deletar dados");
    }
  }
}
