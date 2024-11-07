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
  List<Map<String, dynamic>> checklists = []; // Lista de checklists existentes
  int? selectedChecklistId; // ID do checklist selecionado
  final String BaseUrl = 'http://localhost:5092';
  final TextEditingController nomeCheckListController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fetchChecklists();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    print('Token carregado para requisição: $token');
  }

  Future<void> _fetchChecklists() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseUrl}/checklist/buscarTodos'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        setState(() {
          checklists = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      }
    } catch (e) {
      print("Erro ao carregar checklists: $e");
    }
  }

  void loadChecklistData(int checklistId) {
    final checklist = checklists.firstWhere((item) => item['id'] == checklistId);
    nomeCheckListController.text = checklist['nome'];
    selectedChecklistId = checklistId;
    isEditing = true;
    setState(() {});
  }

  Future<void> salvarOuAtualizarChecklist() async {
    if (isEditing) {
      await atualizarChecklist(selectedChecklistId!);
    } else {
      await Chequelist();
    }
  }

  Future<void> Chequelist() async {
    try {
      print(token);
      final response = await http.post(
        Uri.parse('${BaseUrl}/checklist/adicionar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "usuarioId": 1,
          "nome": nomeCheckListController.text,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 400) {
        final data = jsonDecode(response.body);
        var idCheckList = data['id'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Sucesso ao criar checklist',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color.fromRGBO(44, 211, 11, 0.682)),
        );
        criaQuestao(idCheckList);
      } else if (response.statusCode >= 400) {
        final data = jsonDecode(response.body);
        var e = data['message'] ?? 'Erro desconhecido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro checklista: $e',
                  style: TextStyle(color: Colors.black)),
              backgroundColor: Color.fromRGBO(211, 11, 11, 0.686)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Não foi possível carregar checklist $e',
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
        String tipoQuestao = question.questionType;
        tipoQuestaoID = tipoQuestao == 'Imagem' ? 3 : tipoQuestao == 'Múltipla Escolha' ? 2 : 1;

        final response = await http.post(
          Uri.parse('${BaseUrl}/questao/adicionar'),
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

        if (response.statusCode >= 200 && response.statusCode < 400) {
          final data = jsonDecode(response.body);
          var idQuestao = data['id'];
          criaAlternativa(idQuestao, question.options);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Sucesso ao criar questão: $idQuestao',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Color.fromRGBO(16, 240, 16, 0.69)),
          );
        } else {
          final data = jsonDecode(response.body);
          var e = data['message'] ?? 'Erro desconhecido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro questão: $e'), backgroundColor: Color.fromRGBO(240, 50, 16, 0.686)),
          );
        }
      }
    } catch (e) {
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
        final response = await http.post(
          Uri.parse('${BaseUrl}/alternativa/adicionar'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "questaoId": idQuestao,
            "descricao": alternativa,
          }),
        );

        if (response.statusCode >= 200 && response.statusCode < 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Alternativa criada com sucesso',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Color.fromRGBO(61, 240, 16, 0.69)),
          );
        } else {
          final data = jsonDecode(response.body);
          var e = data['message'] ?? 'Erro desconhecido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro alternativa: $e'), backgroundColor: Color.fromRGBO(240, 61, 16, 0.686)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Falha ao criar alternativa',
                style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(240, 231, 16, 80)),
      );
    }
  }

  Future<void> atualizarChecklist(int idChecklist) async {
    try {
      final response = await http.put(
        Uri.parse('${BaseUrl}/checklist/atualizar/$idChecklist'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "usuarioId": 1,
          "nome": nomeCheckListController.text,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Checklist atualizado com sucesso', style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(44, 211, 11, 0.682),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        var e = data['message'] ?? 'Erro desconhecido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar checklist: $e', style: TextStyle(color: Colors.black)),
            backgroundColor: Color.fromRGBO(211, 11, 11, 0.686),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Falha ao atualizar checklist', style: TextStyle(color: Colors.black)),
          backgroundColor: Color.fromRGBO(240, 231, 16, 80),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
void addQuestion() {
  setState(() {
    questions.add(Question());
  });
}

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
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: screenSize.width * 0.6,
                    height: screenSize.height * 0.75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<int>(
                            hint: Text("Selecione um checklist"),
                            value: selectedChecklistId,
                            onChanged: (int? newValue) {
                              if (newValue != null) {
                                loadChecklistData(newValue);
                              }
                            },
                            items: checklists.map((checklist) {
                              return DropdownMenuItem<int>(
                                value: checklist['id'],
                                child: Text(checklist['nome']),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Nome do Checklist",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: nomeCheckListController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color.fromRGBO(240, 231, 16, 0.8),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: salvarOuAtualizarChecklist,
                            child: Text(isEditing ? "Atualizar Checklist" : "Salvar Checklist"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color.fromRGBO(240, 231, 16, 1),
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
  onPressed: () => addQuestion(),
                                child: Text("Adicionar pergunta"),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color.fromRGBO(240, 231, 16, 1),
                              ),
                            ),
                          ),
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
