import 'package:faker_dart/faker_dart.dart';
import 'package:projeto_bd/app/features/armazem/controller/armazem_dao.dart';
import 'package:projeto_bd/app/features/categoria/controller/categoria_dao.dart';
import 'package:projeto_bd/app/features/estoque/controller/estoque_dao.dart';
import 'package:projeto_bd/app/features/fornecedor/controller/fornecedor_dao.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_categoria_dao.dart';
import 'package:projeto_bd/app/features/produto/controller/traducao_produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';

class ProdutoDao {
  static Future<List<Produto>> getProdutos() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query('SELECT * FROM Produto');
    final produtos = results
        .map((row) => Produto(
              id: row['id'],
              nome: row['nome'],
              descricao: row['descricao'],
              precoCusto: row['precoCusto'],
              precoVenda: row['precoVenda'],
              precoVendaMin: row['precoVendaMin'],
              dataGarantia: row['dataGarantia'],
              status: row['status'] == 'Ativo'
                  ? StatusProduto.Ativo
                  : StatusProduto.Inativo,
              fornecedorId: row['fornecedorId'],
            ))
        .toList();
    await conn.close();
    return produtos;
  }

  static Future<int?> addProduto(Produto produto) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Produto (nome, descricao, dataGarantia, status, precoCusto, precoVenda, precoVendaMin, fornecedorId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        produto.nome,
        produto.descricao,
        produto.dataGarantia.toUtc(),
        produto.status.name,
        produto.precoCusto,
        produto.precoVenda,
        produto.precoVendaMin,
        produto.fornecedorId
      ],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updateProduto(Produto produto) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Produto SET nome = ?, descricao = ?, dataGarantia = ?, status = ?, precoCusto = ?, precoVenda = ?, precoVendaMin = ?, fornecedorId = ? WHERE id = ?',
      [
        produto.nome,
        produto.descricao,
        produto.dataGarantia.toUtc(),
        produto.status.name,
        produto.precoCusto,
        produto.precoVenda,
        produto.precoVendaMin,
        produto.fornecedorId,
        produto.id
      ],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<Produto?> getProduto(int id) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT * FROM Produto WHERE id = ?',
      [id],
    );
    final produtos = results
        .map((row) => Produto(
              id: row['id'],
              nome: row['nome'],
              descricao: row['descricao'],
              precoCusto: row['precoCusto'],
              precoVenda: row['precoVenda'],
              precoVendaMin: row['precoVendaMin'],
              dataGarantia: row['dataGarantia'],
              status: row['status'] == 'Ativo'
                  ? StatusProduto.Ativo
                  : StatusProduto.Inativo,
              fornecedorId: row['fornecedorId'],
            ))
        .toList();

    await conn.close();

    final produto = produtos.isEmpty ? null : produtos.first;
    if (produto != null) {
      produto.categorias =
          await ProdutoCategoriaDAO.getCategoriasProduto(produto.id);
      produto.traducoes =
          await TraducaoProdutoDao.getTraducoesProduto(produto.id);
      produto.estoque = await EstoqueDao.getEstoqueByProdutoId(produto.id);
    }
    return produto;
  }

  static Future<int?> deleteProduto(int id) async {
    await ProdutoCategoriaDAO.deleteCategoriasProduto(id);
    for (final traducao in await TraducaoProdutoDao.getTraducoesProduto(id)) {
      await TraducaoProdutoDao.deleteTraducaoProduto(
          traducao.produtoId, traducao.idioma);
    }
    final estoque = await EstoqueDao.getEstoqueByProdutoId(id);
    await EstoqueDao.deleteEstoque(estoque.id);
    final conn = await DbHelper.getConnection();

    final result = await conn.query(
      'DELETE FROM Produto WHERE id = ?',
      [id],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<void> seed(
      int quantidade, void Function(String) onProgress) async {
    Faker faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_BR);
    onProgress('Obtendo fornecedores...');
    final fornecedores = await FornecedorDao.getFornecedores();
    if (fornecedores.isEmpty) {
      throw Exception('É necessário ter fornecedores cadastrados');
    }
    final fornecedoresIds = fornecedores.map((f) => f.id).toList();
    onProgress('Obtendo categorias...');
    final categoriasIds = await CategoriaDao.getCategorias().then((categorias) {
      if (categorias.isEmpty) {
        throw Exception('É necessário ter categorias cadastradas');
      }
      return categorias.map((c) => c.id).toList();
    });
    final armazens = await ArmazemDao.getArmazens();
    if (armazens.isEmpty) {
      throw Exception('É necessário ter armazens cadastrados');
    }

    final conn = await DbHelper.getConnection();
    for (int i = 0; i < quantidade; i++) {
      onProgress('Inserindo produto $i de $quantidade...');
      await conn.query(
        'INSERT INTO Produto (nome, descricao, dataGarantia, status, precoCusto, precoVenda, precoVendaMin, fornecedorId) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          faker.commerce.productName(),
          faker.lorem.sentence(),
          faker.datatype.dateTime(min: 2020, max: 2025).toUtc(),
          faker.datatype.boolean() ? 'Ativo' : 'Inativo',
          faker.datatype.number(min: 1, max: 10).toDouble(),
          faker.datatype.number(min: 21, max: 50).toDouble(),
          faker.datatype.number(min: 11, max: 20).toDouble(),
          fornecedoresIds[
              faker.datatype.number(min: 0, max: fornecedoresIds.length - 1)],
        ],
      );
    }

    final produtos = await getProdutos();
    if (categoriasIds.isNotEmpty) {
      for (var i = 0; i < produtos.length; i++) {
        final produto = produtos[i];
        onProgress(
            'Inserindo categorias do produto $i de ${produtos.length}...');
        final quantidadeCategorias = faker.datatype.number(
            min: 1, max: categoriasIds.length > 3 ? 3 : categoriasIds.length);
        var categoriasIdsCopia = [...categoriasIds];
        for (int i = 0; i < quantidadeCategorias; i++) {
          final categoriaId = categoriasIdsCopia.removeAt(faker.datatype
              .number(min: 0, max: categoriasIdsCopia.length - 1));
          await conn.query(
            'INSERT INTO ProdutoCategoria (produtoId, categoriaId) VALUES (?, ?)',
            [produto.id, categoriaId],
          );
        }
      }
    }

    //criar estoque para o produto
    for (var i = 0; i < produtos.length; i++) {
      onProgress('Inserindo estoque do produto $i de ${produtos.length}...');
      await conn.query(
        'INSERT INTO Estoque (codigo, quantidade, armazemId, produtoId) VALUES (?, ?, ?, ?)',
        [
          faker.address.zipCode(),
          faker.datatype.number(min: 1, max: 100),
          armazens[faker.datatype.number(min: 0, max: armazens.length - 1)].id,
          produtos[i].id,
        ],
      );
    }

    final idiomas = [
      'pt_BR',
      'en_US',
      'es_ES',
      'fr_FR',
      'de_DE',
      'it_IT',
      'ja_JP',
      'ko_KR',
      'ru_RU',
      'zh_CN',
      'zh_TW',
    ];
    for (var i = 0; i < produtos.length; i++) {
      final produto = produtos[i];
      onProgress('Inserindo tradução do produto $i de ${produtos.length}...');
      final numeroTraducoes = faker.datatype.number(min: 1, max: 6);
      var idiomasCopia = [...idiomas];
      for (int i = 0; i < numeroTraducoes; i++) {
        final idioma = idiomasCopia.removeAt(
            faker.datatype.number(min: 0, max: idiomasCopia.length - 1));
        await conn.query(
          'INSERT INTO TraducaoProduto (produtoId, idioma, nome, descricao) VALUES (?, ?, ?, ?)',
          [
            produto.id,
            idioma,
            faker.commerce.productName(),
            faker.lorem.sentence(),
          ],
        );
      }
    }

    await conn.close();
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query(
        'DELETE FROM TraducaoProduto WHERE produtoId IN (SELECT id FROM Produto)');
    await conn.query(
        'DELETE FROM ProdutoCategoria WHERE produtoId IN (SELECT id FROM Produto)');
    await conn.query(
        'DELETE FROM Estoque WHERE produtoId IN (SELECT id FROM Produto)');
    await conn.query('DELETE FROM Produto');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Produto');
    await conn.close();
    return result.first['COUNT(*)'];
  }
}
