import '../API/apiHandler.dart';
import '../models/cliente.dart'; // Modelo de Cliente

class ClienteService {
  final ApiHandler apiHandler = ApiHandler();

  // Buscar todos os clientes
  Future<List<Cliente>> getClientes() async {
    return apiHandler.get('cliente/buscarTodos', (json) => Cliente.fromJson(json));
  }

  // Adicionar um novo cliente
  Future<Cliente> adicionarCliente(Cliente cliente) async {
    return apiHandler.post('cliente/adicionar', cliente.toJson(), (json) => Cliente.fromJson(json));
  }

  // Atualizar um cliente existente
  Future<void> atualizarCliente(int id, Cliente cliente) async {
    return apiHandler.put('/clientes', id, cliente.toJson());
  }

  // Deletar um cliente
  Future<void> deletarCliente(int id) async {
    return apiHandler.delete('/clientes', id);
  }
}
