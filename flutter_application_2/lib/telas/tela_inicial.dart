import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_2/componentes/side_bar.dart'; // Mudou o nome do componente para SideMenu
import 'package:shared_preferences/shared_preferences.dart';
// allChecklist: https://run.mocky.io/v3/3e078084-e58e-485e-96b0-98d8fdc5ac62
// all clientes: https://run.mocky.io/v3/45040cea-f375-4fb4-b82b-fd16e7a65fdf
class ClientChecklistScreen extends StatefulWidget {
  final String token;
  const ClientChecklistScreen({super.key, required this.token});

  @override
  _ClientChecklistScreenState createState() => _ClientChecklistScreenState();
}

class _ClientChecklistScreenState extends State<ClientChecklistScreen> {
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    token = prefs.getString('token');
  });
  print('Token carregado para requisição: $token');
}


  Future<List<dynamic>> fetchClientes() async {
    // Simulando a busca de clientes
    final response = await http.get(
      Uri.parse('https://run.mocky.io/v3/45040cea-f375-4fb4-b82b-fd16e7a65fdf'),
      headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar clientes');
    }
  }
//https://run.mocky.io/v3/4d364006-466d-4d0c-bdd9-b81db57f5255
//interacao ---  https://run.mocky.io/v3/f8ec33c1-7416-436e-be16-16ff924e5656
  Future<List<dynamic>> fetchChecklists() async {
    // Simulando a busca de checklists
    final response = await http.get(
      Uri.parse('https://run.mocky.io/v3/3e078084-e58e-485e-96b0-98d8fdc5ac62'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar checklists');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(token: widget.token), // Mudou o nome do widget para SideMenu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Clientes que receberam envios mais recentes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: fetchClientes(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("Erro ao carregar clientes"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Nenhum cliente encontrado"));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var cliente = snapshot.data![index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(cliente['nome'] ?? 'Nome não disponível'),
                                  subtitle: Text(cliente['telefone'] ?? 'Telefone não disponível'),
                                  trailing: const Text("Desgaste de Eixo"),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Checklists mais recentes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: fetchChecklists(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("Erro ao carregar checklists"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Nenhum checklist encontrado"));
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var checklist = snapshot.data![index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: const Icon(Icons.assignment),
                                  title: Text(checklist['nome'] ?? 'Nome não disponível'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${checklist['questoes'].length} questões"),
                                      Text("Data de criação: ${checklist['dataCriacao']}"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
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
