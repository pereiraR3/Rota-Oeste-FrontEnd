import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
class LoginService {
  void processarLogin(BuildContext context,String telefone, String senha) {
    // Neste ponto, você pode exibir os dados no console
    print('Processando login...');
    print('Telefone: $telefone');
    print('Senha: $senha');
    Navigator.pushReplacementNamed(context, '/home');
    // Aqui dentro vamos fazer requisições HTTPs
  }
}
