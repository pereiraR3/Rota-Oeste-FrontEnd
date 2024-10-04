import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class LoginService {
  Future<http.Response> processarLogin(String telefone, String senha ) async{
    final url = Uri.parse('https://run.mocky.io/v3/1ed80a24-e8de-4c07-a903-8363564bbb78');
    final corpo = {
      'telefone': telefone,
      'senha': senha,
    };
    try {
      final response = await http.post(url, body:corpo);
      
      return response;
    }catch (e) {
      throw Exception('Erro ao enviar requição : $e');
    }
  }
}
