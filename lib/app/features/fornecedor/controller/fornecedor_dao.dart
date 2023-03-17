import 'package:faker_dart/faker_dart.dart';

import 'package:projeto_bd/app/features/fornecedor/model/fornecedor.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';

class FornecedorDao {
  static Future<List<Fornecedor>> getFornecedores() async {
    try {
      final conn = await DbHelper.getConnection();
      final results = await conn.query('SELECT * FROM Fornecedor');
      final fornecedores = results
          .map((row) => Fornecedor(
                id: row['id'],
                nome: row['nome'],
                localidade: row['localidade'],
                tipo: row['tipo'] == 'Física'
                    ? TipoFornecedor.Fisica
                    : TipoFornecedor.Juridica,
                documento: row['documento'],
              ))
          .toList();
      await conn.close();
      return fornecedores;
    } catch (e) {
      rethrow;
    }
  }

  static Future<int?> addFornecedor(Fornecedor fornecedor) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Fornecedor (nome, localidade, tipo, documento) VALUES (?, ?, ?, ?)',
      [
        fornecedor.nome,
        fornecedor.localidade,
        fornecedor.tipo.name,
        fornecedor.documento,
      ],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updateFornecedor(Fornecedor fornecedor) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Fornecedor SET nome = ?, localidade = ?, tipo = ?, documento = ? WHERE id = ?',
      [
        fornecedor.nome,
        fornecedor.localidade,
        fornecedor.tipo.name,
        fornecedor.documento,
        fornecedor.id,
      ],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<int?> deleteFornecedor(int id) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'DELETE FROM Fornecedor WHERE id = ?',
      [id],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  //seed
  static Future<void> seed(int quantidade) async {
    Faker faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_BR);

    final conn = await DbHelper.getConnection();
    for (var i = 0; i < quantidade; i++) {
      await conn.query(
        'INSERT INTO Fornecedor (nome, localidade, tipo, documento) VALUES (?, ?, ?, ?)',
        [
          faker.company.companyName(),
          '${'${faker.address.city()}, ${faker.address.state()}'}}',
          TipoFornecedor.values[i % 2].name,
          faker.internet.ip(),
        ],
      );
    }
    await conn.close();
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM Fornecedor');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Fornecedor');
    await conn.close();
    return result.first['COUNT(*)'];
  }
}
