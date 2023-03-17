// ignore_for_file: constant_identifier_names

class Fornecedor {
  final int id;
  final String nome;
  final String localidade;
  final TipoFornecedor tipo;
  final String documento;

  Fornecedor({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.localidade,
    required this.documento,
  });

  Fornecedor copyWith({
    int? id,
    String? nome,
    String? localidade,
    TipoFornecedor? tipo,
    String? documento,
  }) {
    return Fornecedor(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      localidade: localidade ?? this.localidade,
      tipo: tipo ?? this.tipo,
      documento: documento ?? this.documento,
    );
  }

  @override
  String toString() {
    return 'Fornecedor(id: $id, nome: $nome, localidade: $localidade, tipo: $tipo, documento: $documento)';
  }
}

enum TipoFornecedor {
  Fisica,
  Juridica,
}
