import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem de login
            const ImgLogin(),
            const SizedBox(width: 100),
            // Container com o restante dos elementos da tela de login
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
                children: const [
                  ImgLogo(),
                  TextosTelaLogin(),
                  InputsLogin(),
                  BotaoLogin()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Componentes usados dentro da tela de login

class ImgLogin extends StatelessWidget {
  const ImgLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "img/login.jpg",
      width: 500,
      height: 600,
      fit: BoxFit.cover,
    );
  }
}

class ImgLogo extends StatelessWidget {
  const ImgLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
      child: Image.asset("img/logo.png"),
    );
  }
}

class TextosTelaLogin extends StatelessWidget {
  const TextosTelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Bem vindo de volta!",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
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
                decoration: TextDecoration.none),
          ),
        )
      ],
    );
  }
}

class InputsLogin extends StatelessWidget {
  const InputsLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(5),
          child: const Text(
            "Telefone :",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(240, 231, 16, 80),
                hintText: "Digite o telefone",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(5),
          child: const Text(
            "Senha:",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
        ),
        SizedBox(
          width: 250,
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromRGBO(240, 231, 16, 80),
                hintText: "Digite a senha",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
          ),
        ),
      ],
    );
  }
}

class BotaoLogin extends StatelessWidget {
  const BotaoLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Aqui você pode definir a ação do botão de login
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(const Color.fromRGBO(240, 231, 16, 1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        fixedSize: MaterialStateProperty.all(const Size(140, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: const Text("Entrar"),
    );
  }
}
