import 'package:flutter/material.dart';

//foto de perfil
class fotoPerfil extends StatefulWidget {
  const fotoPerfil({super.key});

  @override
  State<fotoPerfil> createState() => _fotoPerfilState();
}

class _fotoPerfilState extends State<fotoPerfil> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: const Color.fromRGBO(68, 68, 68, 1),
      width: 200,
      height: 200,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
            "https://stockcake.com/i/innovative-technology-presentation_1323963_1075486"),
      ),
    );
  }
}

//
//
//
//
//
//
//
//
//botoes da side bar
class botoes extends StatefulWidget {
  const botoes({super.key});

  @override
  State<botoes> createState() => _botoesState();
}

class _botoesState extends State<botoes> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Home"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(60, 60, 60, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.white12)),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("CheckLists"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(60, 60, 60, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.white12)),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Relatório"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(60, 60, 60, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.white12)),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Contatos"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromRGBO(60, 60, 60, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.white12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//
//
//
//
//
//
//
//
//botão sair da side bar
class botaoSair extends StatefulWidget {
  const botaoSair({super.key});

  @override
  State<botaoSair> createState() => _botaoSairState();
}

class _botaoSairState extends State<botaoSair> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () {},
        child: Text("Sair"),
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Color.fromRGBO(240, 231, 16, 1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      ),
    );
  }
}