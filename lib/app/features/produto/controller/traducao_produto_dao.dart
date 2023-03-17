import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/produto/model/traducao_produto.dart';

class TraducaoProdutoDao {
  static Future<List<TraducaoProduto>> getTraducoesProduto(
      int produtoId) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT * FROM TraducaoProduto WHERE produtoId = ?',
      [produtoId],
    );
    final traducoesProduto = results
        .map((row) => TraducaoProduto(
              produtoId: row['produtoId'],
              idioma: row['idioma'],
              nome: row['nome'],
              descricao: row['descricao'],
            ))
        .toList();
    await conn.close();
    return traducoesProduto;
  }

  static Future<int?> addTraducaoProduto(
      TraducaoProduto traducaoProduto) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO TraducaoProduto (produtoId, idioma, nome, descricao) VALUES (?, ?, ?, ?)',
      [
        traducaoProduto.produtoId,
        traducaoProduto.idioma,
        traducaoProduto.nome,
        traducaoProduto.descricao,
      ],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updateTraducaoProduto(
      TraducaoProduto traducaoProduto) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE TraducaoProduto SET nome = ?, descricao = ? WHERE produtoId = ? AND idioma = ?',
      [
        traducaoProduto.nome,
        traducaoProduto.descricao,
        traducaoProduto.produtoId,
        traducaoProduto.idioma,
      ],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<int?> deleteTraducaoProduto(
      int produtoId, String idioma) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'DELETE FROM TraducaoProduto WHERE produtoId = ? AND idioma = ?',
      [produtoId, idioma],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }
}
