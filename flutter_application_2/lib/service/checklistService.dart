import '../API/apiHandler.dart';
import '../models/checklist.dart'; // Modelo de Cliente

class Checklistservice {
  final ApiHandler apiHandler = ApiHandler();

  // Buscar todos os clientes
  Future<List<CheckList>> getClientes() async {
    return apiHandler.get('checklist/buscarTodos', (json) => CheckList.fromJson(json));
  }

  // Adicionar um novo cliente
  Future<CheckList> adicionarCliente(CheckList checklist) async {
    return apiHandler.post('', checklist.toJson(), (json) => CheckList.fromJson(json));
  }

  // Atualizar um cliente existente
  Future<void> atualizarCliente(int id, CheckList checklist) async {
    return apiHandler.put('/check', id, checklist.toJson());
  }

  // Deletar um cliente
  Future<void> deletarCliente(int id) async {
    return apiHandler.delete('/check', id);
  }
}
