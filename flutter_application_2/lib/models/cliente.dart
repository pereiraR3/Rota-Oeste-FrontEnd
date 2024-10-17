class Cliente {
  final int usuarioId;
  final String nome;
  final String telefone;
  final String foto;

  const Cliente({
    required this.usuarioId,
    required this.nome,
    required this.telefone,
    required this.foto
  });

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
    usuarioId: json['usuarioId'],
    nome: json['nome'],
    telefone: json['telefone'], 
    foto: json['foto'],
  );
}