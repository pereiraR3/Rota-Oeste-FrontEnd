import 'package:flutter/material.dart';
import 'package:flutter_application_2/service/loginService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final LoginService _loginService = LoginService(); // Instância do serviço

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 100),
            // Container com os elementos de login
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromRGBO(55, 55, 55, 1),
              ),
              width: 400,
              height: 600,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Campo de Telefone
                  TextField(
                    controller: _telefoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(240, 231, 16, 80),
                      hintText: "Digite o telefone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  // Campo de Senha
                  TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromRGBO(240, 231, 16, 80),
                      hintText: "Digite a senha",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  // Botão de Login
                  ElevatedButton(
                    onPressed: _realizarLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color.fromRGBO(240, 231, 16, 1),
                      foregroundColor: Colors.black,
                      fixedSize: const Size(140, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text("Entrar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _realizarLogin() {
    // Coleta os dados dos campos de input
    String telefone = _telefoneController.text;
    String senha = _senhaController.text;

    // Chama o serviço para processar o login
    _loginService.processarLogin(telefone, senha);
  }
}