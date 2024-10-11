import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  List<dynamic> relatorios = [];
  List<dynamic> filteredRelatorios = [];
  int currentPage = 0;
  final int itemsPerPage = 7;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchRelatorios();
  }

  Future<void> fetchRelatorios() async {
    final response = await http.get(Uri.parse(
        'https://run.mocky.io/v3/e4375da5-4e76-4880-95bf-5b8fb34a36d3'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        relatorios = data['relatorios'];
        filteredRelatorios =
            List.from(relatorios); // Inicializa a lista filtrada
      });
    } else {
      throw Exception('Falha ao carregar relatórios');
    }
  }

  // Função para filtrar relatórios
  void filterRelatorios(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredRelatorios = List.from(relatorios);
      } else {
        filteredRelatorios = relatorios
            .where((relatorio) =>
                relatorio['titulo'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      currentPage = 0; // Resetar para a primeira página após a busca
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                  Text(
                    'Gere os relatórios aqui',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 500,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Procurar por relatório',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: filterRelatorios, // Chama a função de busca
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: screenSize.width * 0.7,
                    height: screenSize.height * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Column(
                      children: [
                        // Cabeçalho
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(240, 231, 16, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text('Nome do Relatório',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('Quantidade de Questões',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('Data de Criação',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                    child:
                                        Text('')), // Coluna vazia para o botão
                              ),
                            ],
                          ),
                        ),
                        // Divider(),
                        // Campos descritivos dos checklists
                        Expanded(
                          child: ListView.builder(
                            itemCount: (currentPage + 1) * itemsPerPage >
                                    filteredRelatorios.length
                                ? filteredRelatorios.length -
                                    (currentPage * itemsPerPage)
                                : itemsPerPage,
                            itemBuilder: (context, index) {
                              int actualIndex =
                                  currentPage * itemsPerPage + index;
                              return Column(
                                children: [
                                  SizedBox(
                                      height: 15), // Espaçamento acima do item
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            filteredRelatorios[actualIndex]
                                                ['titulo'],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '${filteredRelatorios[actualIndex]['quantidade'].toString()} Questões',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            filteredRelatorios[actualIndex]
                                                ['dataCriacao'],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Ação para abrir o relatório
                                            },
                                            style: ElevatedButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        240, 231, 16, 1),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.zero)),
                                            child: Text('Gerar'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        // Selecionador de páginas
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: currentPage > 0
                                    ? () {
                                        setState(() {
                                          currentPage--;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromRGBO(240, 231, 16, 1),
                                ),
                                child: Text('Anterior'),
                              ),
                              Text(
                                  'Página ${currentPage + 1} de ${((filteredRelatorios.length - 1) / itemsPerPage).ceil()}'),
                              ElevatedButton(
                                onPressed: (currentPage + 1) * itemsPerPage <
                                        filteredRelatorios.length
                                    ? () {
                                        setState(() {
                                          currentPage++;
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor:
                                      const Color.fromRGBO(240, 231, 16, 1),
                                ),
                                child: Text('Próxima'),
                              ),
                            ],
                          ),
                        ),
                      ],
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
