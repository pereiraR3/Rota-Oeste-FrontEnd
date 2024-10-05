// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_unnecessary_containers, library_private_types_in_public_api, sized_box_for_whitespace, camel_case_types, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';

class TelaBuscaScreen extends StatefulWidget {
  const TelaBuscaScreen({super.key});

  @override
  _TelaBuscaScreenState createState() => _TelaBuscaScreenState();
}

class _TelaBuscaScreenState extends State<TelaBuscaScreen> {
  // Lista de seleção para o Checkbox
  List<bool> _isChecked = [false, false, false];

  // Lista de opções para o DropdownButton
  List<String> dropdownItems = ['freio da disco', 'embreagem', 'volante'];

  // Lista que guarda a opção selecionada de cada linha
  List<String?> _selectedItems = [null, null, null];

  // Lista de contatos (nome da segunda coluna)
  List<String> contatos = ['Fulano 1', 'Fulano 2', 'Fulano 3'];

  // Controlador do campo de busca
  TextEditingController _searchController = TextEditingController();

  // Lista filtrada com base na busca
  List<String> filteredContatos = [];

  @override
  void initState() {
    super.initState();
    // Inicialmente, a lista filtrada é igual à lista original de contatos
    filteredContatos = contatos;
  }

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
    return Scaffold(
      body: Row(
        children: [
          SideBar(),
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
                    width: 800,
                    height: 550,
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
                          SizedBox(
                              height:
                                  20), // Espaço entre o campo de busca e a lista

                          // Lista de checklists filtrada
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredContatos.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                              child: Text('Enviar'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    const Color.fromRGBO(240, 231, 16, 1),
                              ))
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
