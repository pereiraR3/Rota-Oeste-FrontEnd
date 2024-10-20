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
//https://run.mocky.io/v3/c1241b4c-b1f7-49cc-82ef-92a8d1a32413   cliente
// https://run.mocky.io/v3/9a95e9c2-ec21-40d4-83ff-e3d6e90d5295  checklist

//coisas para fazer nesta tela: listar cliente, checklist, vincular os dois.


class _TelaBuscaScreenState extends State<TelaBuscaScreen> {
  
  // Lista de seleção para o Checkbox
  List<bool> _isChecked = [false, false, false];

  // Lista de opções para o DropdownButton
  List<String> dropdownItems = [];
  List<dynamic> listaChecklist = [];
  // Lista que guarda a opção selecionada de cada linha
  List<String?> _selectedItems = [null, null, null];

  // Lista de contatos (nome da segunda coluna)
  List<String> contatos = [];

  // Controlador do campo de busca
  TextEditingController _searchController = TextEditingController();

  // Lista filtrada com base na busca
  List<String> filteredContatos = [];

  @override
  void initState() {
    super.initState();
  }
Future<void> fetchAllChecklist() async{
  try {
     final response = await http.get(
      Uri.parse('https://run.mocky.io/v3/9a95e9c2-ec21-40d4-83ff-e3d6e90d5295'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200){
      final data = json.decode(response.body);
      if (data != null && data is List){

        setState(() {
          listaChecklist = data.map((item){
            String titulo = item['nome'] ?? 'Sem checkList';
            
            return {'titulo':titulo};
          }).toList();
           dropdownItems = listaChecklist.map((item) {
            return item['titulo'] as String;
          }).toList();
        });

      }
    }
  } catch (e) {
    print("Erro: $e");
    throw Exception('Erro ao carregar interações');
  }
}
  // Função para buscar dados do Mocky
 
  // Função que atualiza a lista de contatos com base na busca
  void _filterContatos(String query) {
    List<String> tempList = [];
    if (query.isNotEmpty) {
      tempList = contatos
          .where(
              (contact) => contact.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      tempList = contatos;
    }
    setState(() {
      filteredContatos = tempList;
    });
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
                    width: screenSize.width * 0.5, // 80% da largura da tela
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
                                        width: 600,
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
                                                    color: Colors.white),
                                              ),
                                            ),

                                            // Terceira Coluna: DropdownButton
                                            DropdownButton<String>(
                                              hint: Text(
                                                "Selecione",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              value: _selectedItems[index],
                                              dropdownColor: Colors.grey[800],
                                              items: dropdownItems
                                                  .map((String item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _selectedItems[index] =
                                                      newValue;
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
                            onPressed: () {},
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
