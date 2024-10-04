import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class LoginService {
  Future<http.Response> processarLogin(String telefone, String senha ) async{
    final url = Uri.parse('https://url_do_back/api/login');
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
