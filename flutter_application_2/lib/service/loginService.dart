import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LoginService {
  Future<http.Response> processarLogin(String telefone, String senha) async {
    final url = Uri.parse(
        'https://run.mocky.io/v3/ce6daca2-0973-4ba4-bc2e-a1bc1dc4b3e7');
    final corpo = {
      'telefone': telefone,
      'senha': senha,
    };
    try {
      final response = await http.post(url, body: corpo);

      return response;
    } catch (e) {
      throw Exception('Erro ao enviar requição : $e');
    }
  }
}
