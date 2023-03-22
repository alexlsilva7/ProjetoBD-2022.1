import 'package:faker_dart/faker_dart.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/pedido/controller/produto_pedido_dao.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';

class PedidoDao {
  static Future<List<Pedido>> getPedidos() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query('SELECT * FROM Pedido');
    final pedidos = results
        .map((row) => Pedido(
              id: row['id'],
              data: row['data'],
              modoEncomenda: row['modoEncomenda'] == 'Retirada'
                  ? ModoEncomenda.Retirada
                  : ModoEncomenda.Entrega,
              status: row['status'] == 'Em Preparação'
                  ? Status.emPreparacao
                  : row['status'] == 'Em Transporte'
                      ? Status.emTransporte
                      : row['status'] == 'Entregue'
                          ? Status.entregue
                          : row['status'] == 'Aguardando Pagamento'
                              ? Status.aguardandoPagamento
                              : Status.pagamentoConfirmado,
              prazoEntrega: row['prazoEntrega'],
              clienteId: row['clienteId'],
            ))
        .toList();

    await conn.close();
    return pedidos;
  }

  static Future<List<Pedido>> getPedidosByClienteId(int clienteId) async {
    final conn = await DbHelper.getConnection();
    final results = await conn
        .query('SELECT * FROM Pedido WHERE clienteId = ?', [clienteId]);
    final pedidos = results
        .map((row) => Pedido(
              id: row['id'],
              data: row['data'],
              modoEncomenda: row['modoEncomenda'] == 'Retirada'
                  ? ModoEncomenda.Retirada
                  : ModoEncomenda.Entrega,
              status: row['status'] == 'Em Preparação'
                  ? Status.emPreparacao
                  : row['status'] == 'Em Transporte'
                      ? Status.emTransporte
                      : row['status'] == 'Entregue'
                          ? Status.entregue
                          : row['status'] == 'Aguardando Pagamento'
                              ? Status.aguardandoPagamento
                              : Status.pagamentoConfirmado,
              prazoEntrega: row['prazoEntrega'],
              clienteId: row['clienteId'],
            ))
        .toList();
    for (var pedido in pedidos) {
      final pedido = pedidos.isEmpty ? null : pedidos.first;

      if (pedido != null) {
        pedido.produtosPedido =
            await ProdutoPedidoDAO.getProdutosPedido(pedido);
      }
    }

    await conn.close();
    return pedidos;
  }

  static Future<List<dynamic>> getIdsWhereProdutoPedidoIsNull() async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT id FROM Pedido WHERE id NOT IN (SELECT pedidoId FROM ProdutoPedido)',
    );
    final ids = results.map((row) => row['id']).toList();
    await conn.close();
    return ids;
  }

  static Future<int?> addPedido(Pedido pedido) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'INSERT INTO Pedido (data, modoEncomenda, status, prazoEntrega, clienteId) VALUES (?, ?, ?, ?, ?)',
      [
        pedido.data.toUtc(),
        pedido.modoEncomenda == ModoEncomenda.Retirada ? 'Retirada' : 'Entrega',
        pedido.status == Status.emPreparacao
            ? 'Em preparação'
            : pedido.status == Status.emTransporte
                ? 'Em transporte'
                : pedido.status == Status.entregue
                    ? 'Entregue'
                    : pedido.status == Status.pagamentoConfirmado
                        ? 'Pagamento confirmado'
                        : 'Aguardando pagamento',
        pedido.prazoEntrega.toUtc(),
        pedido.clienteId,
      ],
    );
    final id = result.insertId;
    await conn.close();
    return id;
  }

  static Future<int?> updatePedido(Pedido pedido, Pedido old) async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query(
      'UPDATE Pedido SET data = ?, modoEncomenda = ?, status = ?, prazoEntrega = ?, clienteId = ? WHERE id = ?',
      [
        pedido.data.toUtc(),
        pedido.modoEncomenda == ModoEncomenda.Retirada ? 'Retirada' : 'Entrega',
        pedido.status == Status.emPreparacao
            ? 'Em preparação'
            : pedido.status == Status.emTransporte
                ? 'Em transporte'
                : pedido.status == Status.entregue
                    ? 'Entregue'
                    : pedido.status == Status.pagamentoConfirmado
                        ? 'Pagamento confirmado'
                        : 'Aguardando pagamento',
        pedido.prazoEntrega.toUtc(),
        pedido.clienteId,
        pedido.id,
      ],
    );

    final oldProdutosPedido = old.produtosPedido;
    final newProdutosPedido = pedido.produtosPedido;

    for (var oldProdutoPedido in oldProdutosPedido!) {
      var isItInNew = false;
      for (var newProdutoPedido in newProdutosPedido!) {
        if (oldProdutoPedido.produtoId == newProdutoPedido.produtoId) {
          isItInNew = true;
          if (oldProdutoPedido.quantidade != newProdutoPedido.quantidade) {
            await ProdutoPedidoDAO.updateProdutoPedido(newProdutoPedido);
          }
          break;
        }
      }
      if (!isItInNew) {
        await ProdutoPedidoDAO.deleteProdutoPedido(oldProdutoPedido);
      }
    }

    for (var newProdutoPedido in newProdutosPedido!) {
      var isItInOld = false;
      for (var oldProdutoPedido in oldProdutosPedido) {
        if (oldProdutoPedido.produtoId == newProdutoPedido.produtoId) {
          isItInOld = true;
          break;
        }
      }
      if (!isItInOld) {
        await ProdutoPedidoDAO.addProdutoPedido(newProdutoPedido);
      }
    }

    final rowsAffected = result.affectedRows;
    await conn.close();
    return rowsAffected;
  }

  static Future<Pedido?> getPedido(int id) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT * FROM Pedido WHERE id = ?',
      [id],
    );
    final pedidos = results
        .map((row) => Pedido(
              id: row['id'],
              data: row['data'],
              modoEncomenda: row['modoEncomenda'] == 'Retirada'
                  ? ModoEncomenda.Retirada
                  : ModoEncomenda.Entrega,
              status: row['status'] == 'Em preparação'
                  ? Status.emPreparacao
                  : row['status'] == 'Em transporte'
                      ? Status.emTransporte
                      : row['status'] == 'Entregue'
                          ? Status.entregue
                          : row['status'] == 'Aguardando pagamento'
                              ? Status.aguardandoPagamento
                              : Status.pagamentoConfirmado,
              prazoEntrega: row['prazoEntrega'],
              clienteId: row['clienteId'],
            ))
        .toList();

    await conn.close();

    final pedido = pedidos.isEmpty ? null : pedidos.first;

    if (pedido != null) {
      pedido.produtosPedido = await ProdutoPedidoDAO.getProdutosPedido(pedido);
    }
    return pedido;
  }

  static Future<int?> deletePedido(int id) async {
    final conn = await DbHelper.getConnection();

    final result = await conn.query(
      'DELETE FROM Pedido WHERE id = ?',
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
    onProgress('Obtendo clientes');
    final clientes = await ClienteDao.getClientes();
    final conn = await DbHelper.getConnection();

    for (var i = 0; i < quantidade; i++) {
      final data = faker.date.between(
        DateTime(2015, 1, 1),
        DateTime(2027, 12, 12),
      );
      final modoEncomenda = faker.datatype.boolean()
          ? ModoEncomenda.Retirada
          : ModoEncomenda.Entrega;

      final prazoEntrega = data.add(const Duration(days: 3));

      final clienteId =
          clientes[faker.datatype.number(min: 0, max: clientes.length - 1)].id!;
      final intStatus = faker.datatype.number(min: 1, max: 5);
      var status = Status.emPreparacao;
      switch (intStatus) {
        case 1:
          status = Status.emPreparacao;
          break;
        case 2:
          status = Status.emTransporte;
          break;
        case 3:
          status = Status.entregue;
          break;
        case 4:
          status = Status.aguardandoPagamento;
          break;
        case 5:
          status = Status.pagamentoConfirmado;
          break;
      }
      onProgress('Criando pedido $i de $quantidade');
      await conn.query(
        'INSERT INTO Pedido (data, modoEncomenda, status, prazoEntrega, clienteId) VALUES (?, ?, ?, ?, ?)',
        [
          data.toUtc(),
          modoEncomenda == ModoEncomenda.Retirada ? 'Retirada' : 'Entrega',
          status == Status.emPreparacao
              ? 'Em Preparação'
              : status == Status.emTransporte
                  ? 'Em Transporte'
                  : status == Status.entregue
                      ? 'Entregue'
                      : status == Status.aguardandoPagamento
                          ? 'Aguardando Pagamento'
                          : 'Pagamento Confirmado',
          prazoEntrega.toUtc(),
          clienteId,
        ],
      );
    }
    onProgress('Obtendo pedidos');
    final pedidosIds = await PedidoDao.getIdsWhereProdutoPedidoIsNull();
    onProgress('Obtendo produtos');
    final produtos = await ProdutoDao.getProdutos();
    int index = 1;
    for (var pedidoId in pedidosIds) {
      List<Produto> produtosPedido = [];
      final quantidadeProdutos = faker.datatype.number(min: 1, max: 5);
      for (var i = 0; i < quantidadeProdutos; i++) {
        final produto = produtos[faker.datatype.number(
          min: 0,
          max: produtos.length - 1,
        )];
        if (produtosPedido.contains(produto)) {
          i--;
          continue;
        }
        produtosPedido.add(produto);
      }

      for (var i = 0; i < quantidadeProdutos; i++) {
        onProgress(
            'Criando produto pedido ${i + 1} de $quantidadeProdutos para o pedido $index');
        final removeProductAt = faker.datatype.number(
          min: 0,
          max: produtosPedido.length > 1 ? produtosPedido.length - 1 : 1,
        );
        final produto = produtosPedido.removeAt(removeProductAt);
        final quantidade = faker.datatype.number(min: 1, max: 10);
        await conn.query(
          'INSERT INTO ProdutoPedido (pedidoId, produtoId, quantidade, precoVendaProduto) VALUES (?, ?, ?, ?)',
          [
            pedidoId,
            produto.id,
            quantidade,
            produto.precoVenda,
          ],
        );
      }
      index++;
    }
    await conn.close();
  }

  static Future<void> clear() async {
    final conn = await DbHelper.getConnection();
    await conn.query('DELETE FROM ProdutoPedido');
    await conn.query('DELETE FROM Pedido');
    await conn.close();
  }

  static Future<int> count() async {
    final conn = await DbHelper.getConnection();
    final result = await conn.query('SELECT COUNT(*) FROM Pedido');
    final count = result.first.values!.first as int;
    await conn.close();
    return count;
  }
}
