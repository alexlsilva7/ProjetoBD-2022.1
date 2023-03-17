import 'package:faker_dart/faker_dart.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';
import 'package:projeto_bd/app/features/cliente/model/email_cliente.dart';
import 'package:projeto_bd/app/features/cliente/model/telefone_cliente.dart';

class ClienteDao {
  static Future<List<Cliente>> getClientes() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query('SELECT * FROM Cliente');
    final clientes = results
        .map((row) => Cliente(
              id: row['id'],
              nome: row['nome'],
              pais: row['pais'],
              estado: row['estado'],
              cidade: row['cidade'],
              limiteCredito: row['limiteCredito'],
              dataCadastro: row['dataCadastro'],
            ))
        .toList();
    await conn.close();
    return clientes;
  }

  static Future<int?> addCliente(Cliente cliente) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Cliente (nome, pais, estado, cidade, limiteCredito, dataCadastro) VALUES (?, ?, ?, ?, ?, ?)',
      [
        cliente.nome,
        cliente.pais,
        cliente.estado,
        cliente.cidade,
        cliente.limiteCredito,
        cliente.dataCadastro.toIso8601String(),
      ],
    );
    final id = result.insertId;

    for (int i = 0; i < cliente.telefones!.length; i++) {
      await conn.query(
          'INSERT INTO TelefoneCliente (clienteId, telefone) VALUES (?, ?)',
          [id, cliente.telefones![i].telefone]);
    }

    for (int i = 0; i < cliente.emails!.length; i++) {
      await conn.query(
          'INSERT INTO EmailCliente (clienteId, email) VALUES (?, ?)',
          [id, cliente.emails![i].email]);
    }

    await conn.close();
    return id;
  }

  static Future<int?> updateCliente(Cliente cliente) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Cliente SET nome = ?, pais = ?, estado = ?, cidade = ?, limiteCredito = ? WHERE id = ?',
      [
        cliente.nome,
        cliente.pais,
        cliente.estado,
        cliente.cidade,
        cliente.limiteCredito,
        cliente.id,
      ],
    );

    await conn
        .query('DELETE FROM TelefoneCliente WHERE clienteId = ?', [cliente.id]);
    await conn
        .query('DELETE FROM EmailCliente WHERE clienteId = ?', [cliente.id]);

    for (int i = 0; i < cliente.telefones!.length; i++) {
      await conn.query(
          'INSERT INTO TelefoneCliente (clienteId, telefone) VALUES (?, ?)',
          [cliente.id, cliente.telefones![i].telefone]);
    }
    for (int i = 0; i < cliente.emails!.length; i++) {
      await conn.query(
          'INSERT INTO EmailCliente (clienteId, email) VALUES (?, ?)',
          [cliente.id, cliente.emails![i].email]);
    }
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<Cliente> getCliente(int id) async {
    final conn = await DbHelper.getConnection();
    final results =
        await conn.query('SELECT * FROM Cliente WHERE id = ?', [id]);
    final clientes = results
        .map((row) => Cliente(
              id: row['id'],
              nome: row['nome'],
              pais: row['pais'],
              estado: row['estado'],
              cidade: row['cidade'],
              limiteCredito: row['limiteCredito'],
              dataCadastro: row['dataCadastro'],
            ))
        .toList();

    final telefones = await conn.query(
        'SELECT telefone FROM TelefoneCliente WHERE clienteId = ?', [id]);
    final emails = await conn
        .query('SELECT email FROM EmailCliente WHERE clienteId = ?', [id]);
    //add telefones and emails
    clientes[0].telefones = telefones
        .map((row) => TelefoneCliente(
              clienteId: id,
              telefone: row['telefone'],
            ))
        .toList();
    clientes[0].emails = emails
        .map((row) => EmailCliente(
              clienteId: id,
              email: row['email'],
            ))
        .toList();

    await conn.close();

    if (clientes.isEmpty) return Future.error('Cliente não encontrado');
    return clientes.first;
  }

  static Future<int?> deleteCliente(int id) async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM TelefoneCliente WHERE clienteId = ?', [id]);
    await conn.query('DELETE FROM EmailCliente WHERE clienteId = ?', [id]);
    final result = await conn.query('DELETE FROM Cliente WHERE id = ?', [id]);
    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<void> seed(
      int quantidade, void Function(String) onProgress) async {
    Faker faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_BR);
    final conn = await DbHelper.getConnection();
    for (int i = 0; i < quantidade; i++) {
      onProgress('Criando cliente ${i + 1} de $quantidade');
      final nome = faker.name.fullName();
      final pais = faker.address.country();
      final estado = faker.address.state();
      final cidade = faker.address.city();
      final limiteCredito = faker.datatype.number(min: 100, max: 10000);
      final dataCadastro = faker.date.between(
        DateTime(2010, 1, 1),
        DateTime(2021, 1, 1),
      );
      final result = await conn.query(
        'INSERT INTO Cliente (nome, pais, estado, cidade, limiteCredito, dataCadastro) VALUES (?, ?, ?, ?, ?, ?)',
        [
          nome,
          pais,
          estado,
          cidade,
          limiteCredito,
          dataCadastro.toIso8601String(),
        ],
      );
      final id = result.insertId;
      int qtdTelefones = faker.datatype.number(min: 1, max: 3);
      for (int j = 0; j < qtdTelefones; j++) {
        await conn.query(
          'INSERT INTO TelefoneCliente (clienteId, telefone) VALUES (?, ?)',
          [id, faker.phoneNumber.phoneNumber(format: '###########')],
        );
      }
      int qtdEmails = faker.datatype.number(min: 1, max: 3);
      for (int j = 0; j < qtdEmails; j++) {
        await conn.query(
          'INSERT INTO EmailCliente (clienteId, email) VALUES (?, ?)',
          [id, faker.internet.email()],
        );
      }
    }
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM TelefoneCliente');
    await conn.query('DELETE FROM EmailCliente');
    await conn.query('DELETE FROM Cliente');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Cliente');
    await conn.close();
    return result.first['COUNT(*)'];
  }
}
