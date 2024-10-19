import '../API/apiHandler.dart';
import '../models/cliente.dart'; // Modelo de Cliente

class ClienteService {
  final ApiHandler apiHandler = ApiHandler();

  // Buscar todos os clientes
  Future<List<Cliente>> getClientes() async {
    return apiHandler.get('https://run.mocky.io/v3/ac84cd48-34a6-4523-8aa0-44f8fea03051', (json) => Cliente.fromJson(json));
  }

  // Adicionar um novo cliente
  Future<Cliente> adicionarCliente(Cliente cliente) async {
    return apiHandler.post('https://run.mocky.io/v3/cf41914d-c739-40cd-8c65-a74b6c2c3bb9', cliente.toJson(), (json) => Cliente.fromJson(json));
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
