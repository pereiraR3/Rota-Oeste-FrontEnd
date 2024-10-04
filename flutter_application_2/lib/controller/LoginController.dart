import 'package:flutter/material.dart';
import 'package:flutter_application_2/service/loginService.dart'; // Importando o SideBar


class Logincontroller {
  final LoginService _loginService = LoginService(); // instanciando a classe loginservice para usar seus metodos

  //criando funcao async/await
  Future<void> realizarLogin(BuildContext context, String telefone, String senha) async {
    try {
      final response = await _loginService.processarLogin(telefone, senha); //
      if (response.statusCode == 200){
        Navigator.pushReplacementNamed(context, '/home');
      }else{
         // Se o login falhar, mostre uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao realizar login: ${response.body}')),
        );
      }
    } catch (e) {
      // Trate erros que possam ocorrer ao enviar a requisição
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao realizar login: $e')),
      );
      }

  }
}
