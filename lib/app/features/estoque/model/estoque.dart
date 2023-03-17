class Estoque {
  final int id;
  final String codigo;
  final int quantidade;
  final int armazemId;
  final int produtoId;

  Estoque({
    required this.id,
    required this.codigo,
    required this.quantidade,
    required this.armazemId,
    required this.produtoId,
  });

  Estoque copyWith({
    int? id,
    String? codigo,
    int? quantidade,
    int? armazemId,
    int? produtoId,
  }) {
    return Estoque(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      quantidade: quantidade ?? this.quantidade,
      armazemId: armazemId ?? this.armazemId,
      produtoId: produtoId ?? this.produtoId,
    );
  }

  @override
  String toString() {
    return 'Estoque(id: $id, codigo: $codigo, quantidade: $quantidade, armazemId: $armazemId, produtoId: $produtoId)';
  }
}
