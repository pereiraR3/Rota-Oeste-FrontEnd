import 'package:flutter/material.dart';
import 'telas/tela_busca.dart';
import 'telas/tela_criacao_checklist.dart';
import 'telas/tela_relatorio.dart';
import 'telas/tela_login.dart'; // Importando a tela principal
import 'telas/tela_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      initialRoute: '/login', // Definindo a rota inicial como a HomeScreen
      routes: {
        '/login': (context) => const LoginScreen(), // Rota para a tela de login
        '/home': (context) => const ChecklistScreen(),
        '/telabusca': (context) => const TelaBuscaScreen(),
        '/relatorio': (context) => const RelatorioScreen(),
        '/checklist': (context) => TelaCriacaoChecklist(),
      },
    );
  }
}
