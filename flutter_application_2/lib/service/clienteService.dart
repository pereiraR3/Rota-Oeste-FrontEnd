import '../API/apiHandler.dart';
import '../models/cliente.dart'; // Modelo de Cliente

class ClienteService {
  final ApiHandler apiHandler = ApiHandler();

  // Buscar todos os clientes
  Future<List<Cliente>> getClientes() async {
      final response = await apiHandler.get('https://run.mocky.io/v3/ac84cd48-34a6-4523-8aa0-44f8fea03051', (json) {
      
    if (json != null && json is Map<String, dynamic>) {
      return Cliente.fromJson(json);
    } else {
      throw Exception("Dados de cliente inválidos ou nulos");
    }
  });
if (response != null && response is List<Cliente>) {
    return response;
  } else {
    throw Exception("A resposta não contém uma lista de clientes válida");
  }
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
