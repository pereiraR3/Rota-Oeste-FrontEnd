import '../API/apiHandler.dart';
import '../models/checklist.dart'; // Modelo de Cliente

class Checklistservice {
  final ApiHandler apiHandler = ApiHandler();

  // Buscar todos os clientes
  Future<List<CheckList>> getCheckList() async {
    return apiHandler.get('checklist/buscarTodos', (json) => CheckList.fromJson(json));
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
