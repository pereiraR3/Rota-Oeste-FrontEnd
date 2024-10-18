import 'package:flutter_application_2/models/questao.dart';
import 'package:flutter_application_2/models/respostaTemAlternativa.dart';

class Alternativa {
  final int id;
  final int questaoId;
  final String? descricao;
  final int codigo;
  final Questao questao;
  final List<RespostaTemAlternativa>? respostaTemAlternativa;

  Alternativa({
    required this.id,
    required this.questaoId,
    this.descricao,
    required this.codigo,
    required this.questao,
    this.respostaTemAlternativa,
  });

  factory Alternativa.fromJson(Map<String, dynamic> json) {
    return Alternativa(
      id: json['id'],
      questaoId: json['questaoId'],
      descricao: json['descricao'],
      codigo: json['codigo'],
      questao: Questao.fromJson(json['questao']),
      respostaTemAlternativa: (json['respostaTemAlternativa'] as List<dynamic>?)
          ?.map((item) => RespostaTemAlternativa.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'questaoId': questaoId,
        'descricao': descricao,
        'codigo': codigo,
        'questao': questao.toJson(),
        'respostaTemAlternativa': respostaTemAlternativa?.map((item) => item.toJson()).toList(),
      };
}
