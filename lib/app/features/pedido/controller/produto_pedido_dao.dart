import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';
import 'package:projeto_bd/app/features/pedido/model/produto_pedido.dart';

class ProdutoPedidoDAO {
  static Future<List<ProdutoPedido>> getProdutosPedido(Pedido pedido) async {
    final conn = await DbHelper.getConnection();
    final results = await conn.query(
      'SELECT * FROM ProdutoPedido WHERE pedidoId = ?',
      [pedido.id],
    );

    final produtos = results
        .map((row) => ProdutoPedido(
              pedidoId: row['pedidoId'],
              produtoId: row['produtoId'],
              quantidade: row['quantidade'],
              precoVendaProduto: row['precoVendaProduto'],
            ))
        .toList();

    await conn.close();
    return produtos;
  }

  static Future<void> updateProdutoPedido(ProdutoPedido produtoPedido) async {
    final conn = await DbHelper.getConnection();
    await conn.query(
      'UPDATE ProdutoPedido SET quantidade = ?, precoVendaProduto = ? WHERE pedidoId = ? AND produtoId = ?',
      [
        produtoPedido.quantidade,
        produtoPedido.precoVendaProduto,
        produtoPedido.pedidoId,
        produtoPedido.produtoId,
      ],
    );
    await conn.close();
  }
}
