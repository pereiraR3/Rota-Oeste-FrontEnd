import 'package:flutter_application_2/models/clienteRcheckList.dart';
import 'package:flutter_application_2/models/questao.dart';
import 'package:flutter_application_2/models/usuario.dart';

class CheckList {
  final int id;
  final int usuarioId;
  final String? nome;
  final String? dataCriacao;
  final List<Questao>? questoes;
  final Usuario usuario;
  final List<ClienteRespondeCheckList>? clienteResponde;

  CheckList({
    required this.id,
    required this.usuarioId,
    this.nome,
    this.dataCriacao,
    this.questoes,
    required this.usuario,
    this.clienteResponde,
  });

  factory CheckList.fromJson(Map<String, dynamic> json) {
    return CheckList(
      id: json['id'],
      usuarioId: json['usuarioId'],
      nome: json['nome'],
      dataCriacao: json['dataCriacao'],
      questoes: (json['questoes'] as List<dynamic>?)
          ?.map((item) => Questao.fromJson(item))
          .toList(),
      usuario: Usuario.fromJson(json['usuario']),
      clienteResponde: (json['clienteResponde'] as List<dynamic>?)
          ?.map((item) => ClienteRespondeCheckList.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'nome': nome,
        'dataCriacao': dataCriacao,
        'questoes': questoes?.map((item) => item.toJson()).toList(),
        'usuario': usuario.toJson(),
        'clienteResponde': clienteResponde?.map((item) => item.toJson()).toList(),
      };
}
