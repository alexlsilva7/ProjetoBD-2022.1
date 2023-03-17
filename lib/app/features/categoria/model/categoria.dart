// ignore_for_file: public_member_api_docs, sort_constructors_first
class Categoria {
  final int? id;
  final String nome;
  final String descricao;

  Categoria({this.id, required this.nome, required this.descricao});

  Categoria copyWith({int? id, String? nome, String? descricao}) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  bool operator ==(covariant Categoria other) {
    if (identical(this, other)) return true;

    return other.id == id && other.nome == nome && other.descricao == descricao;
  }

  @override
  int get hashCode => id.hashCode ^ nome.hashCode ^ descricao.hashCode;
}
