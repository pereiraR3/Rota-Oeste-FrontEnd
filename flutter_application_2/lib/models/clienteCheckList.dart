import 'package:flutter_application_2/models/checklist.dart';
import 'package:flutter_application_2/models/cliente.dart';

class ClienteRespondeCheckList {
  final int clienteId;
  final int checkListId;
  final Cliente cliente;
  final CheckList checkList;

  ClienteRespondeCheckList({
    required this.clienteId,
    required this.checkListId,
    required this.cliente,
    required this.checkList,
  });

  factory ClienteRespondeCheckList.fromJson(Map<String, dynamic> json) {
    return ClienteRespondeCheckList(
      clienteId: json['clienteId'],
      checkListId: json['checkListId'],
      cliente: Cliente.fromJson(json['cliente']),
      checkList: CheckList.fromJson(json['checkList']),
    );
  }

  Map<String, dynamic> toJson() => {
        'clienteId': clienteId,
        'checkListId': checkListId,
        'cliente': cliente.toJson(),
        'checkList': checkList.toJson(),
      };
}
