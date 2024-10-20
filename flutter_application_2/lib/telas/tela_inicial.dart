import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart'; // Importando o SideBar


// puxar 
class ChecklistScreen extends StatelessWidget {
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar - Agora usando o widget SideBar
          const SideBar(),
          // Painel principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lista de clientes que receberam envios recentes
                  const Text(
                    'Clientes que receberam envios mais recentes',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4, // Número de clientes (pode ser dinâmico)
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text("Pedro Álvares Cabral"),
                            subtitle: const Text("(66) 99222-7654"),
                            trailing: const Text("Desgaste de Eixo"),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Lista de checklists mais recentes
                  const Text(
                    'Checklist mais recentes',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4, // Número de checklists (pode ser dinâmico)
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.assignment),
                            title: const Text("Desgaste de Eixo"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("12 questões"),
                                Text("Data de criação: 10/09/2024"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
