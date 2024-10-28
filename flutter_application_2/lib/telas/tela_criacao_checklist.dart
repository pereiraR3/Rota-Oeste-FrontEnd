import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TelaCriacaoChecklist extends StatefulWidget {
  final String token;
  const TelaCriacaoChecklist({super.key, required this.token});
  @override
  _TelaCriacaoChecklistState createState() => _TelaCriacaoChecklistState();
}

class _TelaCriacaoChecklistState extends State<TelaCriacaoChecklist> {
  String? token;
  List<Question> questions = [];
  final String BaseUrl = 'http://localhost:5092';
  final TextEditingController nomeCheckListController = TextEditingController();

  void addQuestion() {
    setState(() {
      questions.add(Question());
    });
    for (var q in questions) {
      print(q.questionText);
    }
  }

  void removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

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

  Future<void> Chequelist() async {
    try {
      print(token);
      // Fazendo a requisição HTTP POST
      final response = await http.post(
        Uri.parse('http://localhost:5092/checklist/adicionar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "usuarioId": 2,
          "nome": nomeCheckListController.text,
        }),
      );

      // Verificando o código de status da resposta
      if (response.statusCode >= 200 && response.statusCode < 400) {
        final data = jsonDecode(response.body);
        var idCheckList = data['id'];
        criaQuestao(idCheckList);
        print('ID do Checklist: $idCheckList');
      } else if (response.statusCode >= 400) {
        // Caso de erro
        final data = jsonDecode(response.body);
        var e = data['message'] ?? 'Erro desconhecido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro checklista: $e',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
        );
      }
    } catch (e) {
      // Tratamento de exceções de conexão ou de parsing JSON
      print('Erro na requisição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Não foi possivel carregar checklist',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
      );
    }
  }

  Future<void> criaQuestao(int idChecklist) async {
    try {
      int tipoQuestaoID;
      for (var question in questions) {
        String tituloQuestao = question.questionText;
        String tipoQuestao = question.questionType; // Conversão correta
        if (tipoQuestao == 'Imagem') {
          tipoQuestaoID = 3;
        } else if (tipoQuestao == 'Múltipla Escolha') {
          tipoQuestaoID = 2;
        } else if (tipoQuestao == 'Objetiva') {
          tipoQuestaoID = 1;
        } else {
          tipoQuestaoID = 1; // Um valor padrão, caso necessário
        }
        // Fazendo a requisição HTTP POST para cada questão
        final response = await http.post(
          Uri.parse('http://localhost:5092/questao/adicionar'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "checkListId": idChecklist,
            "titulo": tituloQuestao,
            "tipo": tipoQuestaoID
          }),
        );

        // Verificando o código de status da resposta
        if (response.statusCode >= 200 && response.statusCode < 400) {
          final data = jsonDecode(response.body);
          var idQuestao = data['id'];
          criaAlternativa(idQuestao, question.options);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro: $idQuestao',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
          );
        } else if (response.statusCode >= 400) {
          // Caso de erro
          final data = jsonDecode(response.body);
          var e = data['message'] ?? 'Erro desconhecido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro questao: $e')),
          );
        }
      }
    } catch (e) {
      // Tratamento de exceções de conexão ou de parsing JSON
      print('Erro na requisição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao se conectar com o servidor',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
      );
    }
  }

  Future<void> criaAlternativa(int idQuestao, List<String> options) async {
    try {
      for (var alternativa in options) {
        print(alternativa);

        // Enviando requisição HTTP POST para adicionar alternativa
        final response = await http.post(
          Uri.parse('http://localhost:5092/alternativa/adicionar'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "questaoId": idQuestao,
            "descricao": alternativa,
          }),
        );

        // Verificando o código de status da resposta
        if (response.statusCode >= 200 && response.statusCode < 400) {
          final data = jsonDecode(response.body);
          var idAlternativa = data['id'];
          print('ID da Alternativa: $idAlternativa');
        } else {
          final data = jsonDecode(response.body);
          var e = data['message'] ?? 'Erro desconhecido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro alternativa: $e')),
          );
        }
      }
    } catch (e) {
      print('Erro na requisição: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha ao criar alternativa',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
      );
    }
  }

  void ca() {
    int index = 0;
    for (var q in questions) {
      index += 1;
      print(q.options);
      print(q.questionText);
      print(q.questionType);
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
              children: [
                Text(
                  "Criação de checklists",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  width: screenSize.width * 0.6, // 80% da largura da tela
                  height: screenSize.height * 0.8, // 80% da altura da tela
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nome do Checklist",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 15),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Input do nome
                                  Container(
                                    width: screenSize.width < 400
                                        ? screenSize.width * 0.8
                                        : 200,
                                    child: TextField(
                                      controller: nomeCheckListController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // Botão ao lado do input em telas maiores
                                  if (screenSize.width >= 500)
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: ElevatedButton(
                                        onPressed: Chequelist,
                                        child: Text("Salvar Checklist",
                                            overflow: TextOverflow.ellipsis),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: const Color.fromRGBO(
                                              240, 231, 16, 1),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // Botão abaixo do input em telas menores
                              if (screenSize.width < 500)
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: ElevatedButton(
                                    onPressed: Chequelist,
                                    child: Text("Salvar Checklist"),
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor:
                                          const Color.fromRGBO(240, 231, 16, 1),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            return QuestionCard(
                              key: UniqueKey(),
                              question: questions[index],
                              onRemove: () => removeQuestion(index),
                            );
                          },
                        ),
                        SizedBox(height: 15),
                        Center(
                          child: ElevatedButton(
                            onPressed: addQuestion,
                            child: Text("Adicionar pergunta"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromRGBO(240, 231, 16, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

class Question {
  String questionText = '';
  List<String> options = [''];
  TextEditingController questionTextController = TextEditingController();
  String questionType = 'Objetiva'; // Tipos: Objetiva, Múltipla Escolha, Imagem
  List<TextEditingController> optionsControllers = [TextEditingController()];
  void addOption() {
    optionsControllers.add(TextEditingController());
  }

  void removeOption(int index) {
    optionsControllers.removeAt(index);
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;
  final VoidCallback onRemove;

  const QuestionCard({Key? key, required this.question, required this.onRemove})
      : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.question.questionType; // Define o tipo inicial
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.question.questionTextController,
                    decoration: InputDecoration(labelText: 'Pergunta'),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue;
                      widget.question.questionType = newValue!;
                    });
                  },
                  items: <String>['Objetiva', 'Múltipla Escolha', 'Imagem']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (selectedType == 'Objetiva' ||
                selectedType == 'Múltipla Escolha') ...[
              Text('Alternativas:'),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.question.optionsControllers.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.question.optionsControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Opção ${index + 1}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            widget.question.removeOption(index);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.question.addOption();
                  });
                },
                child: Text('Adicionar alternativa'),
              ),
            ] else if (selectedType == 'Imagem') ...[
              Text('Resposta aceita no formato de:'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Lógica para upload de imagem
                },
                child: Text('Resposta do tipo imagem'),
              ),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: widget.onRemove,
                child: Text('Remover Pergunta'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
