import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

//interacao ---  https://run.mocky.io/v3/f8ec33c1-7416-436e-be16-16ff924e5656

class RelatorioScreen extends StatefulWidget {
  final String token;
  const RelatorioScreen({super.key, required this.token});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  final String UrlBase = 'http://localhost:5092';  
  List<dynamic> relatorios = [];
  List<dynamic> filteredRelatorios = [];
  int currentPage = 0;
  final int itemsPerPage = 7;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fechTodosCheckLists(); // Carrega as interações após a inicialização
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
  // Função para buscar todas as interações
Future<void> fechTodosCheckLists() async {
  try {
    final response = await http.get(
      Uri.parse('${UrlBase}/checklist/buscarTodos'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      
      final data = json.decode(response.body);

if (data != null && data is List) {
  setState(() {
    relatorios = data.map((item) {
      // Acessa o nome do checklist como título
      String titulo = item['nome'] ?? 'Título Desconhecido';
      
      // Conta a quantidade de questões presentes no checklist
      int quantidade = item['quantityQuestoes'] ?? 0;
      
      // Obtém a data de criação
      String dataCriacao = formatarData(item['dataCriacao']);

      return {
        'titulo': titulo,
        'quantidade': quantidade,
        'dataCriacao': dataCriacao,
      };
    }).toList();
    filteredRelatorios = List.from(relatorios); // Inicializa a lista filtrada
  });

      } else {
        throw Exception('Formato de dados inválido');
      }
    } else {
      throw Exception('Erro ao carregar interações');
    }
  } catch (e) {
    print("Erro: $e");
    throw Exception('Erro ao carregar interações');
  }
}

  // Função para filtrar relatórios/interações
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
          SideBar(token: widget.token),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Gere os relatórios aqui',
                  style: TextStyle(fontSize: screenSize.width * 0.04, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Container(
                    width: screenSize.width * 0.8,
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
                  SizedBox(height: screenSize.height * 0.02),
                  Container(
                    width: screenSize.width * 0.9,
                    height: screenSize.height * 0.6,
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
                                          child: ElevatedButton.icon(
                                            onPressed: () {
                                              // Ação para abrir o relatório
                                            },
                                             icon: Icon(Icons.picture_as_pdf),
                                             label: Text('Gerar'),
                                            style: ElevatedButton.styleFrom(

                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    const Color.fromRGBO(
                                                        240, 231, 16, 1),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.zero)),
                                            
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
                          padding: EdgeInsets.all(screenSize.width * 0.02),
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
