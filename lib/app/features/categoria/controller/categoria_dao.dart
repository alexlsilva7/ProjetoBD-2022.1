import 'package:faker_dart/faker_dart.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/categoria/model/categoria.dart';

class CategoriaDao {
  static Future<List<Categoria>> getCategorias() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query('SELECT * FROM Categoria');
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

  static Future<int?> addCategoria(Categoria categoria) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Categoria (nome, descricao) VALUES (?, ?)',
      [categoria.nome, categoria.descricao],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updateCategoria(Categoria categoria) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Categoria SET nome = ?, descricao = ? WHERE id = ?',
      [categoria.nome, categoria.descricao, categoria.id],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<int?> deleteCategoria(int id) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'DELETE FROM Categoria WHERE id = ?',
      [id],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<void> seed(int quantidade) async {
    Faker faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_BR);

    List<String> nomes = [];
    while (nomes.length < quantidade) {
      var nome = '${faker.commerce.department()} ${nomes.length}';
      if (nomes.contains(nome)) {
        continue;
      }
      nomes.add(nome);
    }

    final conn = await DbHelper.getConnection();
    for (var i = 0; i < quantidade; i++) {
      await conn.query(
        'INSERT INTO Categoria (nome, descricao) VALUES (?, ?)',
        [
          nomes[i],
          faker.lorem.sentence(),
        ],
      );
    }
    await conn.close();
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM Categoria');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Categoria');
    await conn.close();
    return result.first['COUNT(*)'];
  }
}
