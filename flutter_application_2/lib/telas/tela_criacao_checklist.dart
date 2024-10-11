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
                  "Criação de checklists",
                  style: TextStyle(fontSize: 40),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 800,
                  height: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromRGBO(117, 117, 117, 1),
                  ),
                  child: Column(
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
                      ElevatedButton(
                        onPressed: addQuestion,
                        child: Text("Adicionar pergunta"),
                      ),
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
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                widget.question.questionText = value;
              },
              decoration: InputDecoration(labelText: 'Pergunta'),
            ),
            SizedBox(height: 16),
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
