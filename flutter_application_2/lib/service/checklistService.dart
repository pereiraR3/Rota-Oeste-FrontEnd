import '../API/apiHandler.dart';
import '../models/checklist.dart'; // Modelo de Cliente
import 'dart:convert';
import 'package:http/http.dart' as http;
class Checklistservice {
  final ApiHandler apiHandler = ApiHandler();
  
  // Buscar todos os clientes

  Future<List<CheckList>> getCheckLists() async {
    return apiHandler.get('https://run.mocky.io/v3/fdf2b852-ba1a-4525-b8df-c9ce3510a75f', (json) => CheckList.fromJson(json));
  }

  // Adicionar um novo cliente
  Future<CheckList> adicionarChecklist(CheckList checklist) async {
    return apiHandler.post('', checklist.toJson(), (json) => CheckList.fromJson(json));
  }

  // Atualizar um cliente existente
  Future<void> atualizarChecklist(int id, CheckList checklist) async {
    return apiHandler.put('/check', id, checklist.toJson());
  }

  // Deletar um cliente
  Future<void> deletarChecklist(int id) async {
    return apiHandler.delete('/check', id);
  }
}
