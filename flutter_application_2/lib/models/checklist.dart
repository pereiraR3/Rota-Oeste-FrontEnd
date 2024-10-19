import 'package:flutter_application_2/models/clienteCheckList.dart';
import 'package:flutter_application_2/models/questao.dart';
import 'package:flutter_application_2/models/usuario.dart';

class CheckList {
  final int id;
  final int? usuarioId;
  final String? nome;
  final String? dataCriacao;
  final List<Questao>? questoes;
  final Usuario? usuario;
  final List<ClienteRespondeCheckList>? clienteResponde;

  CheckList({
    required this.id,
    this.usuarioId,
    this.nome,
    this.dataCriacao,
    this.questoes,
    this.usuario,
    this.clienteResponde,
  });

factory CheckList.fromJson(Map<String, dynamic> json) {
  return CheckList(
    id: json['id'] ?? 0, // Define 0 como padrão se o valor for null
    usuarioId: json['usuarioId'] != null ? json['usuarioId'] as int : null,
    nome: json['nome'] ?? '',
    dataCriacao: json['dataCriacao'],
    questoes: json['questoes'] != null
        ? (json['questoes'] as List<dynamic>)
            .map((item) => Questao.fromJson(item as Map<String, dynamic>))
            .toList()
        : [], // Lista vazia se 'questoes' for null
    usuario: json['usuario'] != null
        ? Usuario.fromJson(json['usuario'] as Map<String, dynamic>)
        : null,
    clienteResponde: json['clienteResponde'] != null
        ? (json['clienteResponde'] as List<dynamic>)
            .map((item) => ClienteRespondeCheckList.fromJson(item as Map<String, dynamic>))
            .toList()
        : [], // Lista vazia se 'clienteResponde' for null
  );
}


  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'nome': nome,
        'dataCriacao': dataCriacao,
        'questoes': questoes?.map((item) => item.toJson()).toList(),
        'usuario': usuario?.toJson(),
        'clienteResponde': clienteResponde?.map((item) => item.toJson()).toList(),
      };
}
