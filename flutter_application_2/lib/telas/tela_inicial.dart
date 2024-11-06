import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_2/componentes/side_bar.dart'; // Mudou o nome do componente para SideMenu
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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
  final String UrlBase = 'https://bb21-200-129-242-3.ngrok-free.app';
 int _currentPageChecklists = 0;
  int _currentPageClientes = 0;
  final int _itemsPerPage = 5;
  
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
 
  String formatarData(String? dataCriacao) {
  if (dataCriacao == null) return 'Data Desconhecida';
  
  try {
    final data = DateTime.parse(dataCriacao);
    final formatador = DateFormat('dd/MM/yyyy');
    return formatador.format(data);
  } catch (e) {
    return 'Data Inválida';
  }
}

  Future<List<dynamic>> fetchClientes() async {
    
    // Simulando a busca de clientes
    final response = await http.get(
      Uri.parse('${UrlBase}/cliente/buscarTodos'),
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

  Future<List<dynamic>> fetchChecklists() async {
    // Simulando a busca de checklists
    final response = await http.get(
      Uri.parse('${UrlBase}/checklist/buscarTodos'),
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
  
  Future<List<dynamic>> fetchInteracao() async {
    // Simulando a busca de checklists
    final response = await http.get(
      Uri.parse('${UrlBase}/interacao/buscarTodos'),
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


 
 Future<List<Map<String, dynamic>>> fetchClientesFiltrados() async {
  final clientes = await fetchClientes();
  final interacoes = await fetchInteracao();
  final checklists = await fetchChecklists();

  // Cria um mapa para acesso rápido ao nome do checklist pelo ID
  final checklistsMap = {
    for (var checklist in checklists) checklist['id']: checklist['nome']
  };

  // Cria um mapa para acesso rápido aos dados do cliente pelo ID
  final clientesMap = {
    for (var cliente in clientes) cliente['id']: cliente
  };

  // Mapeia todas as interações para retornar os dados necessários
  return interacoes.map((interacao) {
    final cliente = clientesMap[interacao['clienteId']];
    final checklistNome = checklistsMap[interacao['checkListId']] ?? 'Checklist não disponível';

    return {
      'nome': cliente?['nome'] ?? 'Nome não disponível',
      'telefone': cliente?['telefone'] ?? 'Telefone não disponível',
      'checklist': checklistNome,
    };
  }).toList();
}

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(token: widget.token),
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
                 
                  const SizedBox(height: 5),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: fetchClientesFiltrados(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text("Erro ao carregar clientes"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Nenhum cliente encontrado"));
                        } else {
                          final totalItems = snapshot.data!.length;
                          final totalPages = (totalItems / _itemsPerPage).ceil();
                          final itemsToShow = snapshot.data!.skip(_currentPageClientes * _itemsPerPage).take(_itemsPerPage).toList();

                          return 
                       Column(
  children: [
    Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            // Cabeçalho
            Row(
              children: [
                 ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Define o arredondamento das bordas
                  child: Container(
                  
                  color: Color.fromRGBO(240, 231, 16, 1),
                    padding: EdgeInsets.all(8.0),
                  width: 800, // Defina uma largura que coincida com a lista de dados abaixo
                  child: Row(
                    
                    children: [
                      Expanded(child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Telefone', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Checklist', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                )
              ],
            ),
            // Lista de dados
            SizedBox(
              width: 800, // Largura para coincidir com o cabeçalho
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: itemsToShow.length,
                itemBuilder: (context, index) {
                  var cliente = itemsToShow[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.person),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  cliente['nome'] ?? 'Nome não disponível',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.phone),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  cliente['telefone'] ?? 'Telefone não disponível',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.checklist),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  cliente['checklist'] ?? 'Checklist não disponível',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    // Paginação
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(240, 231, 16, 1), // Fundo amarelo
          ),
          onPressed: _currentPageClientes > 0
              ? () {
                  setState(() {
                    _currentPageClientes--;
                  });
                }
              : null,
          child: Text(
            'Ant',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Text('Página ${_currentPageClientes + 1} de $totalPages'),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(240, 231, 16, 1), // Fundo amarelo
          ),
          onPressed: _currentPageClientes < totalPages - 1
              ? () {
                  setState(() {
                    _currentPageClientes++;
                  });
                }
              : null,
          child: Text(
            'Próx',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  ],
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
                  
                  const SizedBox(height: 5),
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
                          final totalItems = snapshot.data!.length;
                          final totalPages = (totalItems / _itemsPerPage).ceil();
                          final itemsToShow = snapshot.data!.skip(_currentPageChecklists * _itemsPerPage).take(_itemsPerPage).toList();

                          return 
                         Column(
  children: [
    Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            // Cabeçalho
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Define o arredondamento das bordas
                  child: Container(
                  
                  color: Color.fromRGBO(240, 231, 16, 1),
                    padding: EdgeInsets.all(8.0),
                  width: 800, // Defina uma largura que coincida com a lista de dados abaixo
                  child: Row(
                    
                    children: [
                      Expanded(child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Quantidade de Questões', style: TextStyle(fontWeight: FontWeight.bold))),
                      Expanded(child: Text('Data de Criação', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                )
              ],
            
            ),
            // Lista de dados
            SizedBox(
              width: 800, // Largura para coincidir com o cabeçalho
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: itemsToShow.length,
                itemBuilder: (context, index) {
                  var checklist = itemsToShow[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.checklist),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  checklist['nome'] ?? 'Nome não disponível',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.numbers),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  "${checklist['quantityQuestoes']} questões",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.date_range),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  formatarData(checklist['dataCriacao']),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    // Paginação
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(240, 231, 16, 1), // Fundo amarelo
          ),
          onPressed: _currentPageChecklists > 0
              ? () {
                  setState(() {
                    _currentPageChecklists--;
                  });
                }
              : null,
          child: Text(
            'Ant',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
        Text('Página ${_currentPageChecklists + 1} de $totalPages'),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(240, 231, 16, 1), // Fundo amarelo
          ),
          onPressed: _currentPageChecklists < totalPages - 1
              ? () {
                  setState(() {
                    _currentPageChecklists++;
                  });
                }
              : null,
          child: Text(
            'Próx',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  ],
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
