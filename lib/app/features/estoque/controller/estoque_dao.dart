import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/estoque/model/estoque.dart';

class EstoqueDao {
  static Future<List<Estoque>> getEstoques() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query('SELECT * FROM Estoque');
    final estoques = results
        .map((row) => Estoque(
              id: row['id'],
              codigo: row['codigo'],
              quantidade: row['quantidade'],
              armazemId: row['armazemId'],
              produtoId: row['produtoId'],
            ))
        .toList();
    await conn.close();
    return estoques;
  }

  static Future<int?> addEstoque(Estoque estoque) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Estoque (codigo, quantidade, armazemId, produtoId) VALUES (?, ?, ?, ?)',
      [
        estoque.codigo,
        estoque.quantidade,
        estoque.armazemId,
        estoque.produtoId
      ],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updateEstoque(Estoque estoque) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Estoque SET codigo = ?, quantidade = ?, armazemId = ?, produtoId = ? WHERE id = ?',
      [
        estoque.codigo,
        estoque.quantidade,
        estoque.armazemId,
        estoque.produtoId,
        estoque.id
      ],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<Estoque> getEstoqueByProdutoId(int produtoId) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT * FROM Estoque WHERE produtoId = ?',
      [produtoId],
    );
    final estoques = results
        .map((row) => Estoque(
              id: row['id'],
              codigo: row['codigo'],
              quantidade: row['quantidade'],
              armazemId: row['armazemId'],
              produtoId: row['produtoId'],
            ))
        .toList();
    await conn.close();
    return estoques.first;
  }

  static Future<int?> deleteEstoque(int id) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'DELETE FROM Estoque WHERE id = ?',
      [id],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM Estoque');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Estoque');
    await conn.close();
    return result.first['COUNT(*)'];
  }
}
