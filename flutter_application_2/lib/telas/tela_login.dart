import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

//componentes da tela de login
class ImgLogin extends StatefulWidget {
  const ImgLogin({super.key});

  @override
  State<ImgLogin> createState() => _ImgLoginState();
}

class _ImgLoginState extends State<ImgLogin> {
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

//
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
class ImgLogo extends StatefulWidget {
  const ImgLogo({super.key});

  @override
  State<ImgLogo> createState() => _ImgLogoState();
}

class _ImgLogoState extends State<ImgLogo> {
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

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

class TextosTelaLogin extends StatefulWidget {
  const TextosTelaLogin({super.key});

  @override
  State<TextosTelaLogin> createState() => _TextosTelaLoginState();
}

class _TextosTelaLoginState extends State<TextosTelaLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(5),
            child: SizedBox(
              child: Text(
                "Bem vindo de volta!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: SizedBox(
              child: Text("Faça login para continuar",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none)),
            ),
          )
        ],
      ),
    );
  }
}

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////

class InputsLogin extends StatefulWidget {
  const InputsLogin({super.key});

  @override
  State<InputsLogin> createState() => _InputsLoginState();
}

class _InputsLoginState extends State<InputsLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5),
            child: Text("Telefone :",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
          ),
          SizedBox(
            width: 250,
            child: TextField(
              decoration: InputDecoration(
                  constraints: BoxConstraints(maxWidth: 100),
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
            padding: EdgeInsets.all(5),
            child: Text("Senha:",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none)),
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
      ),
    );
  }
}

////////////////////////////////
/////////////////////////////

class BotaoLogin extends StatefulWidget {
  const BotaoLogin({super.key});

  @override
  State<BotaoLogin> createState() => _BotaoLoginState();
}

class _BotaoLoginState extends State<BotaoLogin> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {Navigator.pushReplacementNamed(context, '/home')},
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Color.fromRGBO(240, 231, 16, 1)),
        foregroundColor: MaterialStateProperty.all(Colors.black),
        fixedSize: MaterialStateProperty.all(Size(140, 50)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Raio da borda arredondada
          ),
        ),
      ),
      child: Text("Entrar"),
    );
  }
}
