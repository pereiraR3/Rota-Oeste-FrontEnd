import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';
import 'package:http/http.dart' as http;
import '../models/cliente.dart'; // Modelo de Cliente


class TelaBuscaScreen extends StatefulWidget {
  final String token;
  const TelaBuscaScreen({super.key, required this.token});

  @override
  _TelaBuscaScreenState createState() => _TelaBuscaScreenState();
}


class _TelaBuscaScreenState extends State<TelaBuscaScreen> {
  // Lista de seleção para o Checkbox
  List<bool> _isChecked = [];

  List<String> dropdownItems = [];
  List<dynamic> listaClientes = [];
  List<dynamic> listaChecklist = [];
  
  // Lista que guarda a opção selecionada de cada linha
  List<String?> _selectedItems = [];

  // Lista de contatos (nome da segunda coluna)
  List<String> contatos = [];

  // Controlador do campo de busca
  TextEditingController _searchController = TextEditingController();

  // Lista filtrada com base na busca
  List<String> filteredContatos = [];

  @override
  void initState() {
    super.initState();
    fetchAllClientes();
    fetchAllChecklist();
    
    
  }
bool _verificarSelecaoValida() {
  // Verifica se há pelo menos um cliente marcado e com checklist selecionado
  for (int i = 0; i < _isChecked.length; i++) {
    if (_isChecked[i] && _selectedItems[i] != null) {
      return true;
    }
  }
  return false;
}
 
  Future<void> fetchAllChecklist() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5092/checklist/buscarTodos'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List) {
          setState(() {
            listaChecklist = data.map((item) {
              String titulo = item['nome'] ?? 'Sem checklist';
              int id = item['id'];
              return {'titulo': titulo, 'id': id};
            }).toList();

            dropdownItems = listaChecklist.map((item) {
              return item['titulo'] as String;
            }).toList();
          });
        }
      }
    } catch (e) {
     
      throw Exception('Erro ao carregar checklists $e');
    }
  }

  Future<void> fetchAllClientes() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5092/cliente/buscarTodos'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List) {
          setState(() {
            listaClientes = data.map((item) {
              String nome = item['nome'] ?? 'Sem contatos';
              int id = item['id'] ?? 'vazio';
              return {'nome': nome, 'id': id};
            }).toList();

            // Atualiza a lista de contatos com os nomes
            contatos = listaClientes.map((item) {
              return item['nome'] as String;
            }).toList();

            // Inicializa as listas de controle de seleção e dropdown
            _isChecked = List<bool>.filled(contatos.length, false);
            _selectedItems = List<String?>.filled(contatos.length, null);
            
            // Inicializa a lista filtrada com todos os contatos
            filteredContatos = List.from(contatos);
          });
        }
      }
    } catch (e) {
     
      throw Exception('Erro ao carregar clientes');
    }
  }

  void _filterContatos(String query) {
    List<String> tempList = [];
    if (query.isNotEmpty) {
      tempList = contatos
          .where((contact) => contact.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      tempList = List.from(contatos);
    }
    setState(() {
      filteredContatos = tempList;
    });
  }


List<Map<String, int>> obterRelacoesClientesChecklists() {
  List<Map<String, int>> relacoes = [];

  for (int i = 0; i < _isChecked.length; i++) {
    if (_isChecked[i] && listaClientes[i]['id'] != null && _selectedItems[i] != null) {
      int clienteId = listaClientes[i]['id']; // Obtém o ID do cliente correspondente ao índice i

      // Obtém o ID do checklist selecionado com base no título do item selecionado
      int? checkListId = listaChecklist.firstWhere(
        (checklist) => checklist['titulo'] == _selectedItems[i],
        orElse: () => {'id': -1}
      )['id'];

      if (clienteId != null && checkListId != null && checkListId != -1) {
        relacoes.add({
          'clienteId': clienteId,
          'checkListId': checkListId,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: ID invalido $i"),
          backgroundColor: const Color.fromARGB(255, 201, 62, 7),
        ),
      );
      }
    }
  }

  return relacoes;
}

Future<void> enviarRelacaoClienteChecklist(int clienteId, int checkListId) async {
  final url = Uri.parse('http://localhost:5092/checklist/adicionar/clienteId/$clienteId/checklistId/$checkListId');

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Relação Cliente-Checklist criada com sucesso!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao criar a relação. Código: ${response.statusCode}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Erro ao enviar a relação: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          SideBar(token: widget.token),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 600,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    child: Center(
                      child: Text(
                        'Lista de Contatos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Container maior com o checklist e o campo de busca
                  Container(
                    width: screenSize.width * 0.8, // 80% da largura da tela
                    height: screenSize.height * 0.8, // 80% da altura da tela
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Campo de busca dentro do container
                          Container(
                            width: 500,
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Buscar contato...',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (value) {
                                _filterContatos(value); // Filtra os contatos
                              },
                            ),
                          ),
                          SizedBox(height: 20),

                          // Lista de checklists filtrada
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredContatos.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Primeira Coluna: Checkbox
                                      Checkbox(
                                        value: _isChecked[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isChecked[index] = value!;
                                          });
                                        },
                                        activeColor:
                                            Color.fromRGBO(240, 231, 16, 80),
                                      ),

                                      // Segunda Coluna: Texto (contato)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromRGBO(68, 68, 68, 1),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        height: 60,
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                filteredContatos[
                                                    index], // Texto do contato filtrado
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    overflow: TextOverflow.ellipsis,
                                                    ),
                                              ),
                                            ),

                                            // Terceira Coluna: DropdownButton
                                        // Terceira Coluna: DropdownButton
DropdownButton<String>(
  hint: MediaQuery.of(context).size.width > 300
      ? Text(
          "selecione",
          style: TextStyle(color: Colors.white),
        )
      : Icon(Icons.arrow_drop_down, color: Colors.white), // Ícone em telas menores
  value: _selectedItems[index],
  dropdownColor: Colors.grey[800],
  isExpanded: false, // Mantém o dropdown menor
  items: dropdownItems.map((String item) {
    return DropdownMenuItem<String>(
      value: item,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.3, // Define uma largura máxima
        ),
        child: Text(
          item,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis, // Adiciona reticências para texto longo
        ),
      ),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      _selectedItems[index] = newValue;
    });
  },
),



                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _verificarSelecaoValida() ? (){
                              List<Map<String, int>> relacoes = obterRelacoesClientesChecklists();

                                
                                  // Envia cada relação para o backend
                                    for (var relacao in relacoes) {
                                      enviarRelacaoClienteChecklist(relacao['clienteId']!, relacao['checkListId']!);
                                    }
                            }: null,
                            child: Text("Enviar"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromRGBO(240, 231, 16, 1),
                            ),
                          )
                        ],
                      ),
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
