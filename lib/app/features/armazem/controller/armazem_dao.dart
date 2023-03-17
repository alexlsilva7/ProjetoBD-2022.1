import 'package:faker_dart/faker_dart.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/armazem/model/armazem.dart';

class ArmazemDao {
  static Future<List<Armazem>> getArmazens() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query('SELECT * FROM Armazem');
    final armazens = results
        .map((row) => Armazem(
              id: row['id'],
              nome: row['nome'],
              endereco: row['endereco'],
            ))
        .toList();
    await conn.close();
    return armazens;
  }

  static Future<int?> addArmazem(Armazem armazem) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Armazem (nome, endereco) VALUES (?, ?)',
      [armazem.nome, armazem.endereco],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updateArmazem(Armazem armazem) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Armazem SET nome = ?, endereco = ? WHERE id = ?',
      [armazem.nome, armazem.endereco, armazem.id],
    );
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<Armazem?> getArmazem(int id) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT * FROM Armazem WHERE id = ?',
      [id],
    );
    final armazens = results
        .map((row) => Armazem(
              id: row['id'],
              nome: row['nome'],
              endereco: row['endereco'],
            ))
        .toList();
    await conn.close();
    return armazens.isEmpty ? null : armazens.first;
  }

  static Future<int?> deleteArmazem(int id) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'DELETE FROM Armazem WHERE id = ?',
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

    final conn = await DbHelper.getConnection();
    for (var i = 0; i < quantidade; i++) {
      onProgress('Inserindo armazém $i de $quantidade');
      await conn.query(
        'INSERT INTO Armazem (nome, endereco) VALUES (?, ?)',
        [
          faker.company.companyName(),
          faker.address.streetAddress(useFullAddress: true)
        ],
      );
    }

    await conn.close();
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM Armazem');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Armazem');
    await conn.close();
    return result.first['COUNT(*)'];
  }
}
