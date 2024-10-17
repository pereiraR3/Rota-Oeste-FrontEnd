class Interacao {
  final int id;
  final int clienteId;
  final int checkListId;
  final bool status;
  final Cliente cliente;
  final CheckList checkList;
  final List<Resposta>? respostaAlternativaModels;

  Interacao({
    required this.id,
    required this.clienteId,
    required this.checkListId,
    required this.status,
    required this.cliente,
    required this.checkList,
    this.respostaAlternativaModels,
  });

  factory Interacao.fromJson(Map<String, dynamic> json) {
    return Interacao(
      id: json['id'],
      clienteId: json['clienteId'],
      checkListId: json['checkListId'],
      status: json['status'],
      cliente: Cliente.fromJson(json['cliente']),
      checkList: CheckList.fromJson(json['checkList']),
      respostaAlternativaModels: (json['respostaAlternativaModels'] as List<dynamic>?)
          ?.map((item) => Resposta.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'clienteId': clienteId,
        'checkListId': checkListId,
        'status': status,
        'cliente': cliente.toJson(),
        'checkList': checkList.toJson(),
        'respostaAlternativaModels': respostaAlternativaModels?.map((item) => item.toJson()).toList(),
      };
}
