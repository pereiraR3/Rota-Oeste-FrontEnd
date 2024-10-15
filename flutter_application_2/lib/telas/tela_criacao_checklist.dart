import 'package:flutter/material.dart';
import 'package:flutter_application_2/componentes/side_bar.dart';

class TelaCriacaoChecklist extends StatefulWidget {
  @override
  _TelaCriacaoChecklistState createState() => _TelaCriacaoChecklistState();
}

class _TelaCriacaoChecklistState extends State<TelaCriacaoChecklist> {
  List<Question> questions = [];

  void addQuestion() {
    setState(() {
      questions.add(Question());
    });
  }

  void removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Nome do Checklist",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 400,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text("Salvar Checklist"),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor:
                                    const Color.fromRGBO(240, 231, 16, 1),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            return QuestionCard(
                              key: UniqueKey(),
                              question: questions[index],
                              onRemove: () => removeQuestion(index),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                          onPressed: addQuestion,
                          child: Text("Adicionar pergunta"),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  const Color.fromRGBO(240, 231, 16, 1))),
                    ],
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
  String questionType = 'Objetiva'; // Tipos: Objetiva, Múltipla Escolha, Imagem
  List<String> options = [''];

  void addOption() {
    options.add('');
  }

  void removeOption(int index) {
    options.removeAt(index);
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
  bool isExpanded = true; // Agora, o estado começa como expandido
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
                    onChanged: (value) {
                      widget.question.questionText = value;
                    },
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
              Text('Respostas:'),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.question.options.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            widget.question.options[index] = value;
                          },
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
                child: Text('Adicionar resposta'),
              ),
            ] else if (selectedType == 'Imagem') ...[
              Text('Enviar imagem:'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Lógica para upload de imagem
                },
                child: Text('Selecionar imagem'),
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
