class Usuario {
  final int id;
  final String? telefone;
  final String? nome;
  final String? foto;
  final List<Cliente>? clientes;
  final List<CheckList>? checkLists;

  Usuario({
    required this.id,
    this.telefone,
    this.nome,
    this.foto,
    this.clientes,
    this.checkLists,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      telefone: json['telefone'],
      nome: json['nome'],
      foto: json['foto'],
      clientes: (json['clientes'] as List<dynamic>?)
          ?.map((item) => Cliente.fromJson(item))
          .toList(),
      checkLists: (json['checkLists'] as List<dynamic>?)
          ?.map((item) => CheckList.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'telefone': telefone,
        'nome': nome,
        'foto': foto,
        'clientes': clientes?.map((item) => item.toJson()).toList(),
        'checkLists': checkLists?.map((item) => item.toJson()).toList(),
      };
}
