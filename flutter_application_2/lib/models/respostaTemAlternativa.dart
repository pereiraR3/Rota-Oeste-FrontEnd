import 'package:flutter_application_2/models/alternativa.dart';
import 'package:flutter_application_2/models/resposta.dart';

class RespostaTemAlternativa {
  final int respostaId;
  final int alternativaId;
  final Resposta resposta;
  final Alternativa alternativa;

  RespostaTemAlternativa({
    required this.respostaId,
    required this.alternativaId,
    required this.resposta,
    required this.alternativa,
  });

  factory RespostaTemAlternativa.fromJson(Map<String, dynamic> json) {
    return RespostaTemAlternativa(
      respostaId: json['respostaId'],
      alternativaId: json['alternativaId'],
      resposta: Resposta.fromJson(json['resposta']),
      alternativa: Alternativa.fromJson(json['alternativa']),
    );
  }

  Map<String, dynamic> toJson() => {
        'respostaId': respostaId,
        'alternativaId': alternativaId,
        'resposta': resposta.toJson(),
        'alternativa': alternativa.toJson(),
      };
}
