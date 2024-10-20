import 'package:flutter/material.dart';

// Widget completo da sidebar que inclui todos os componentes
class SideBar extends StatelessWidget {
  final String token;

  const SideBar({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto de perfil
          const fotoPerfil(),
          // Espaçamento
          const SizedBox(height: 20),
          // Botões da sidebar
          botoes(token: token),
          // Espaçamento
          const Spacer(),
          // Botão sair
          const botaoSair(),
        ],
      ),
    );
  }
}

// Foto de perfil
class fotoPerfil extends StatelessWidget {
  const fotoPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      color: const Color.fromRGBO(68, 68, 68, 1),
      width: double.infinity,
      child: const CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(
            "https://stockcake.com/i/innovative-technology-presentation_1323963_1075486"),
      ),
    );
  }
}

// Botões da sidebar
class botoes extends StatelessWidget {
  final String token;

  const botoes({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home', arguments: token);
            },
            child: const Text("Home"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.white12)),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/checklist', arguments: token);
            },
            child: const Text("CheckLists"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.white12)),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/relatorio', arguments: token);
            },
            child: const Text("Relatório"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.white12)),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/telabusca', arguments: token);
            },
            child: const Text("Contatos"),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.white12)),
            ),
          ),
        ),
      ],
    );
  }
}

// Botão sair da sidebar
class botaoSair extends StatelessWidget {
  const botaoSair({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        child: const Text("Sair"),
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: const Color.fromRGBO(240, 231, 16, 1),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      ),
    );
  }
}
