import 'package:projeto_bd/app/features/categoria/model/categoria.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';

class ProdutoCategoriaDAO {
  static Future<void> addProdutoCategoria(
      int produtoId, int categoriaId) async {
    final conn = await DbHelper.getConnection();
    await conn.query(
      'INSERT INTO ProdutoCategoria (produtoId, categoriaId) VALUES (?, ?)',
      [produtoId, categoriaId],
    );
    await conn.close();
  }

  static Future<void> deleteProdutoCategoria(
      int produtoId, int categoriaId) async {
    final conn = await DbHelper.getConnection();
    await conn.query(
      'DELETE FROM ProdutoCategoria WHERE produtoId = ? AND categoriaId = ?',
      [produtoId, categoriaId],
    );
    await conn.close();
  }

  static Future<List<Categoria>> getCategoriasProduto(int produtoId) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT c.* FROM Categoria c INNER JOIN ProdutoCategoria pc ON c.id = pc.categoriaId WHERE pc.produtoId = ?',
      [produtoId],
    );
    final categorias = results
        .map((row) => Categoria(
              id: row['id'],
              nome: row['nome'],
              descricao: row['descricao'],
            ))
        .toList();
    await conn.close();
    return categorias;
  }

  static Future<void> deleteCategoriasProduto(int produtoId) async {
    final conn = await DbHelper.getConnection();
    await conn.query(
      'DELETE FROM ProdutoCategoria WHERE produtoId = ?',
      [produtoId],
    );
    await conn.close();
  }
}
