class ProdutoPedido {
  int? produtoId;
  int? pedidoId;
  double precoVendaProduto;
  int quantidade;

  ProdutoPedido({
    this.produtoId,
    this.pedidoId,
    required this.precoVendaProduto,
    required this.quantidade,
  });

  @override
  String toString() {
    return 'ProdutoPedido(produtoId: $produtoId, pedidoId: $pedidoId, precoVendaProduto: $precoVendaProduto, quantidade: $quantidade)';
  }

  ProdutoPedido copyWith({
    int? produtoId,
    int? pedidoId,
    double? precoVendaProduto,
    int? quantidade,
  }) {
    return ProdutoPedido(
      produtoId: produtoId ?? this.produtoId,
      pedidoId: pedidoId ?? this.pedidoId,
      precoVendaProduto: precoVendaProduto ?? this.precoVendaProduto,
      quantidade: quantidade ?? this.quantidade,
    );
  }
}
