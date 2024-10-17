class Resposta {
  final int id;
  final int questaoId;
  final int interacaoId;
  final String? foto;
  final Questao questao;
  final Interacao interacao;
  final List<RespostaTemAlternativa>? respostaTemAlternativa;

  Resposta({
    required this.id,
    required this.questaoId,
    required this.interacaoId,
    this.foto,
    required this.questao,
    required this.interacao,
    this.respostaTemAlternativa,
  });

  factory Resposta.fromJson(Map<String, dynamic> json) {
    return Resposta(
      id: json['id'],
      questaoId: json['questaoId'],
      interacaoId: json['interacaoId'],
      foto: json['foto'],
      questao: Questao.fromJson(json['questao']),
      interacao: Interacao.fromJson(json['interacao']),
      respostaTemAlternativa: (json['respostaTemAlternativa'] as List<dynamic>?)
          ?.map((item) => RespostaTemAlternativa.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'questaoId': questaoId,
        'interacaoId': interacaoId,
        'foto': foto,
        'questao': questao.toJson(),
        'interacao': interacao.toJson(),
        'respostaTemAlternativa': respostaTemAlternativa?.map((item) => item.toJson()).toList(),
      };
}
