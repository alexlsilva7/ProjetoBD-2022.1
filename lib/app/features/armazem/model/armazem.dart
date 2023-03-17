class Armazem {
  int? id;
  String nome;
  String endereco;

  Armazem({this.id, required this.nome, required this.endereco});

  Armazem copyWith({int? id, String? nome, String? endereco}) {
    return Armazem(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      endereco: endereco ?? this.endereco,
    );
  }
}
