import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navegar para a tela de login ao clicar no botão
            Navigator.pushNamed(context, '/login');
          },
          child: const Text('Ir para a Tela de Login'),
        ),
      ),
    );
  }
}
