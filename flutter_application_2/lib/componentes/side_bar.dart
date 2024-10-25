import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final String token;

  const SideBar({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isExpanded = MediaQuery.of(context).size.width > 600; // Controle de largura da tela

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isExpanded ? 250 : 70,
          color: Colors.grey[800],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isExpanded) const fotoPerfil(), // Exibe a foto de perfil apenas se expandido
              const SizedBox(height: 20),
              botoes(token: token, isExpanded: isExpanded),
              const Spacer(),
              if (isExpanded)
                const botaoSair()
              else
                IconButton(
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

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

class botoes extends StatelessWidget {
  final String token;
  final bool isExpanded;

  const botoes({super.key, required this.token, required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildButton(context, "Home", Icons.home, '/home'),
        _buildButton(context, "CheckLists", Icons.list, '/checklist'),
        _buildButton(context, "Relatório", Icons.insert_drive_file, '/relatorio'),
        _buildButton(context, "Contatos", Icons.contact_page, '/telabusca'),
        _buildButton(context, "Cadastro", Icons.person_add, '/cadastro'),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, IconData icon, String route) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22),
        label: isExpanded ? Text(label , overflow: TextOverflow.ellipsis, // Adiciona reticências se o texto ultrapassar
              maxLines: 1, ) : const SizedBox.shrink(),
        onPressed: () {
          Navigator.pushReplacementNamed(context, route, arguments: token);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color.fromRGBO(60, 60, 60, 1),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(color: Colors.white12)),
        ),
      ),
    );
  }
}

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
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
      ),
    );
  }
}
