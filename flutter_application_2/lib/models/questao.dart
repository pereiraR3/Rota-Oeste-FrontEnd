import 'package:flutter_application_2/models/alternativa.dart';
import 'package:flutter_application_2/models/checklist.dart';
import 'package:flutter_application_2/models/resposta.dart';

class Questao {
  final int id;
  final int checkListId;
  final String titulo;
  final int tipo;
  final CheckList checkList;
  final List<Resposta>? respostaModels;
  final List<Alternativa>? alternativaModels;

  Questao({
    required this.id,
    required this.checkListId,
    required this.titulo,
    required this.tipo,
    required this.checkList,
    this.respostaModels,
    this.alternativaModels,
  });

  factory Questao.fromJson(Map<String, dynamic> json) {
    return Questao(
      id: json['id'],
      checkListId: json['checkListId'],
      titulo: json['titulo'],
      tipo: json['tipo'],
      checkList: CheckList.fromJson(json['checkList']),
      respostaModels: (json['respostaModels'] as List<dynamic>?)
          ?.map((item) => Resposta.fromJson(item))
          .toList(),
      alternativaModels: (json['alternativaModels'] as List<dynamic>?)
          ?.map((item) => Alternativa.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'checkListId': checkListId,
        'titulo': titulo,
        'tipo': tipo,
        'checkList': checkList.toJson(),
        'respostaModels': respostaModels?.map((item) => item.toJson()).toList(),
        'alternativaModels': alternativaModels?.map((item) => item.toJson()).toList(),
      };
}
