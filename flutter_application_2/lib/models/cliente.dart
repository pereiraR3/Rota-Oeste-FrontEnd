import 'package:flutter_application_2/models/clienteCheckList.dart';
import 'package:flutter_application_2/models/interacao.dart';
import 'package:flutter_application_2/models/usuario.dart';


class Cliente {
  final int id;
  final int? usuarioId;
  final String? nome;
  final String? telefone;
  final String? foto;
  final Usuario? usuario;
  final List<Interacao>? interacoes;
  final List<ClienteRespondeCheckList>? clienteResponde;

  Cliente({
    required this.id,
    this.usuarioId,
    this.nome,
    this.telefone,
    this.foto,
    this.usuario,
    this.interacoes,
    this.clienteResponde,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? 0, // Tratamento para evitar null em id
      usuarioId: json['usuarioId'] as int?,
      nome: json['nome'] as String?,
      telefone: json['telefone'] as String?,
      foto: json['foto'] as String?,
      usuario: json['usuario'] != null ? Usuario.fromJson(json['usuario']) : null,
      interacoes: (json['interacoes'] as List<dynamic>?)
          ?.map((item) => Interacao.fromJson(item as Map<String, dynamic>))
          .toList(),
      clienteResponde: (json['clienteResponde'] as List<dynamic>?)
          ?.map((item) => ClienteRespondeCheckList.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'usuarioId': usuarioId,
        'nome': nome,
        'telefone': telefone,
        'foto': foto,
        'usuario': usuario?.toJson(), // Garantir que seja null-safe
        'interacoes': interacoes?.map((item) => item.toJson()).toList() ?? [], // Null-safe e lista vazia se for null
        'clienteResponde': clienteResponde?.map((item) => item.toJson()).toList() ?? [], // Null-safe e lista vazia se for null
      };
}
