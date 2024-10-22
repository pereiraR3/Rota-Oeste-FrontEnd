import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Adicionar dependência
import '../telas/tela_inicial.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Exibir mensagem de erro se os campos estiverem vazios
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5092/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String token = data['accessToken'];
        // Salva o token em SharedPreferences para uso posterior
       final prefs = await SharedPreferences.getInstance();
       await prefs.setString('token', token);

        // Navegar para a tela inicial passando o token
       Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => ClientChecklistScreen(token: token),
  ),
);

      } else {
        // Exibir mensagem de erro caso o login falhe
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login falhou. Verifique suas credenciais.')),
        );
      }
    } catch (e) {
      // Exibir mensagem de erro em caso de exceção
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao conectar ao servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImgLogin(),
            SizedBox(width: 100),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(55, 55, 55, 1),
              ),
              width: 400,
              height: 600,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImgLogo(),
                  TextosTelaLogin(),
                  InputsLogin(
                    usernameController: usernameController,
                    passwordController: passwordController,
                  ),
                  BotaoLogin(
                    usernameController: usernameController,
                    passwordController: passwordController,
                    loginFunction: login,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Componentes da tela de login
class ImgLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        "img/login.jpg",
        width: 500,
        height: 600,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ImgLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: SizedBox(
        child: Image.asset("img/logo.png"),
      ),
    );
  }
}

class TextosTelaLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Bem vindo de volta!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Faça login para continuar",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InputsLogin extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const InputsLogin({
    super.key,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5),
            child: Text(
              "Usuário:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(240, 231, 16, 80),
                hintText: "Digite seu nome",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5),
            child: Text(
              "Senha:",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              controller: passwordController,
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
          ),
        ],
      ),
    );
  }
}

class BotaoLogin extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function loginFunction;

  const BotaoLogin({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.loginFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => loginFunction(),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Color.fromRGBO(240, 231, 16, 1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        fixedSize: MaterialStateProperty.all(Size(140, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Text("Entrar"),
    );
  }
}
