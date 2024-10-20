import 'package:flutter/material.dart';
import 'telas/tela_busca.dart';
import 'telas/tela_criacao_checklist.dart';
import 'telas/tela_relatorio.dart';
import 'telas/tela_login.dart'; // Importando a tela principal
import 'telas/tela_inicial.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // Definindo a rota inicial como a tela de login
      onGenerateRoute: (settings) {
        // Verificar qual rota está sendo chamada e passar os argumentos necessários
        switch (settings.name) {
          case '/home':
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => ClientChecklistScreen(token: token),
            );
          case '/checklist':
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => TelaCriacaoChecklist(token: token), // Assumindo que você tem um ChecklistScreen
            );
          case '/relatorio':
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => RelatorioScreen(token: token), // Assumindo que você tem um RelatorioScreen
            );
          case '/telabusca':
            final token = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => TelaBuscaScreen(token: token), // Assumindo que você tem uma TelaBuscaScreen
            );
          default:
            return MaterialPageRoute(
              builder: (context) => LoginScreen(),
            );
        }
      },
    );
  }
}