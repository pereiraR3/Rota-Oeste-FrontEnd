import 'package:flutter_application_2/models/clienteCheckList.dart';
import 'package:flutter_application_2/models/interacao.dart';
import 'package:flutter_application_2/models/usuario.dart';

class Cliente {
  final int id;
  final int usuarioId;
  final String? nome;
  final String? telefone;
  final String? foto;
  final Usuario usuario;
  final List<Interacao>? interacoes;
  final List<ClienteRespondeCheckList>? clienteResponde;

  Cliente({
    required this.id,
    required this.usuarioId,
    this.nome,
    this.telefone,
    this.foto,
    required this.usuario,
    this.interacoes,
    this.clienteResponde,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      usuarioId: json['usuarioId'],
      nome: json['nome'],
      telefone: json['telefone'],
      foto: json['foto'],
      usuario: Usuario.fromJson(json['usuario']),
      interacoes: (json['interacoes'] as List<dynamic>?)
          ?.map((item) => Interacao.fromJson(item))
          .toList(),
      clienteResponde: (json['clienteResponde'] as List<dynamic>?)
          ?.map((item) => ClienteRespondeCheckList.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'nome': nome,
        'telefone': telefone,
        'foto': foto,
        'usuario': usuario.toJson(),
        'interacoes': interacoes?.map((item) => item.toJson()).toList(),
        'clienteResponde': clienteResponde?.map((item) => item.toJson()).toList(),
      };
}
