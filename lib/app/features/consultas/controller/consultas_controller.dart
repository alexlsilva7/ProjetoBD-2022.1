import 'package:projeto_bd/app/core/helpers/db_helper.dart';

class ConsultasController {
  Future<List<Map<String, dynamic>>> getConsulta1() async {
    final conn = await DbHelper.getConnection();

    const sql = '''
      SELECT
        YEAR(p.data) AS ano,
        MONTH(p.data) AS mes,
        SUM(pp.quantidade) AS quantidade,
        prod.nome AS nomeProduto
      FROM
          Pedido p,
          ProdutoPedido pp,
          Produto prod
      WHERE
          YEAR(p.data) IN (2021, 2027, 2015) AND
          p.id = pp.pedidoId AND
          pp.produtoId = prod.id
      GROUP BY
          nomeProduto,
          ano,
          mes
      ORDER BY
          quantidade DESC;
    ''';

    final results = await conn.query(sql);
    conn.close();
    List<Map<String, dynamic>> rows = [];
    for (var result in results) {
      rows.add(result.fields);
    }

    return rows;
  }
}
