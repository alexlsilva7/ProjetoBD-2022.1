// ignore_for_file: constant_identifier_names

import 'package:projeto_bd/app/features/categoria/model/categoria.dart';
import 'package:projeto_bd/app/features/estoque/model/estoque.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_categoria_dao.dart';
import 'package:projeto_bd/app/features/produto/controller/traducao_produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/traducao_produto.dart';

class Produto {
  final int id;
  final String nome;
  final String descricao;
  final DateTime dataGarantia;
  final StatusProduto status;
  final double precoCusto;
  final double precoVenda;
  final double precoVendaMin;
  final int fornecedorId;
  List<Categoria>? categorias;
  List<TraducaoProduto>? traducoes;
  Estoque? estoque;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.dataGarantia,
    required this.status,
    required this.precoCusto,
    required this.precoVenda,
    required this.precoVendaMin,
    required this.fornecedorId,
    this.categorias,
    this.traducoes,
    this.estoque,
  });

  Produto copyWith({
    int? id,
    String? nome,
    String? descricao,
    DateTime? dataGarantia,
    StatusProduto? status,
    double? precoCusto,
    double? precoVenda,
    double? precoVendaMin,
    int? fornecedorId,
  }) {
    return Produto(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      dataGarantia: dataGarantia ?? this.dataGarantia,
      status: status ?? this.status,
      precoCusto: precoCusto ?? this.precoCusto,
      precoVenda: precoVenda ?? this.precoVenda,
      precoVendaMin: precoVendaMin ?? this.precoVendaMin,
      fornecedorId: fornecedorId ?? this.fornecedorId,
      categorias: categorias,
      traducoes: traducoes,
      estoque: estoque,
    );
  }

  @override
  String toString() {
    return 'Produto(id: $id, nome: $nome, descricao: $descricao, dataGarantia: $dataGarantia, status: $status, precoCusto: $precoCusto, precoVenda: $precoVenda, precoVendaMin: $precoVendaMin, fornecedorId: $fornecedorId, categorias: $categorias)';
  }

  Future<void> addCategoria(Categoria categoria) async {
    await ProdutoCategoriaDAO.addProdutoCategoria(id, categoria.id!);
    categorias = await ProdutoCategoriaDAO.getCategoriasProduto(id);
  }

  Future<void> removeCategoria(Categoria categoria) async {
    await ProdutoCategoriaDAO.deleteProdutoCategoria(id, categoria.id!);
    categorias = await ProdutoCategoriaDAO.getCategoriasProduto(id);
  }

  Future<void> addTraducao(TraducaoProduto traducao) async {
    await TraducaoProdutoDao.addTraducaoProduto(traducao);
    traducoes = await TraducaoProdutoDao.getTraducoesProduto(id);
  }

  Future<void> updateTraducao(TraducaoProduto traducao) async {
    await TraducaoProdutoDao.updateTraducaoProduto(traducao);
    traducoes = await TraducaoProdutoDao.getTraducoesProduto(id);
  }

  Future<void> removeTraducao(TraducaoProduto traducao) async {
    await TraducaoProdutoDao.deleteTraducaoProduto(id, traducao.idioma);
    traducoes = await TraducaoProdutoDao.getTraducoesProduto(id);
  }
}

enum StatusProduto {
  Ativo,
  Inativo,
}
