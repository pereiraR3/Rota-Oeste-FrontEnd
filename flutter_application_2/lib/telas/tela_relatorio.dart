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
      int idcheck = item['id'];
      return {
        'titulo': titulo,
        'quantidade': quantidade,
        'dataCriacao': dataCriacao,
        'id': idcheck
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
Future<void> fetchRelatorio(int checklistId) async {
  try {
    print(checklistId);
    final response = await http.get(
      Uri.parse('${UrlBase}/checklist/relatorio-geral/${checklistId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('PDF sendo gerado...',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(24, 240, 16, 0.69)),
      );
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Não a dados no checklist ou nao foram respondidos',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 106, 16, 0.686)),
      );
    }
 
  } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('$e',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 106, 16, 0.686)),
      );
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
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0), // Alinhamento vertical

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
                                          fontWeight: FontWeight.bold),textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('Quantidade de Questões',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text('Data de Criação', 
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis),
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
  child: SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: screenSize.width < 600 ? Axis.horizontal : Axis.vertical, // Ativa rolagem horizontal para telas menores
      child: Container(
        width: screenSize.width < 600 ? screenSize.width * 1.5 : screenSize.width * 0.9, // Ajuste a largura para permitir a rolagem
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // Desativa a rolagem interna para que o SingleChildScrollView cuide disso
          itemCount: (currentPage + 1) * itemsPerPage > filteredRelatorios.length
              ? filteredRelatorios.length - (currentPage * itemsPerPage)
              : itemsPerPage,
          itemBuilder: (context, index) {
            int actualIndex = currentPage * itemsPerPage + index;
            return Column(
              children: [
                SizedBox(height: 15), // Espaçamento acima do item
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          filteredRelatorios[actualIndex]['titulo'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${filteredRelatorios[actualIndex]['quantidade'].toString()} Questões',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          filteredRelatorios[actualIndex]['dataCriacao'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: IconButton(
                          icon: Icon(Icons.picture_as_pdf),
                          color: Colors.black,
                          onPressed: () => fetchRelatorio(filteredRelatorios[actualIndex]['id']),
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
    ),
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
                                child: SizedBox(
                                  width: 50,

                                      child: Text(
                                          'Anterior',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ),
                                    Text(
                                        'Pág ${currentPage + 1} de ${((filteredRelatorios.length - 1) / itemsPerPage).ceil()}'),
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
                                      
                                      child: SizedBox(
                                        width: 50,
                                    child: Text(
                                          'Próxima',
                                          
                                          textAlign: TextAlign.center,
                                        ),
                                )
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
