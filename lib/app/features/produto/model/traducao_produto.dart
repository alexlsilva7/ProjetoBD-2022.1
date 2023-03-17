class TraducaoProduto {
  final int produtoId;
  final String idioma;
  final String nome;
  final String descricao;

  TraducaoProduto({
    required this.produtoId,
    required this.idioma,
    required this.nome,
    required this.descricao,
  });

  @override
  String toString() {
    return 'TraducaoProduto(produtoId: $produtoId, idioma: $idioma, nome: $nome, descricao: $descricao)';
  }
}
