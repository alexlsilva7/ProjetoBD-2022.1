import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';
import 'package:projeto_bd/app/features/pedido/controller/pedido_dao.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';
import 'package:projeto_bd/app/features/pedido/model/produto_pedido.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';

class PedidoScreen extends StatefulWidget {
  final int id;
  const PedidoScreen({super.key, required this.id});

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  Pedido? pedido;
  Cliente? cliente;
  List<Produto> produtos = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    _loadPedido();
  }

  Future<void> _loadPedido() async {
    final pedido = await PedidoDao.getPedido(widget.id);
    final cliente = await ClienteDao.getCliente(pedido!.clienteId);
    for (ProdutoPedido produtoPed in pedido.produtosPedido!) {
      final produto = await ProdutoDao.getProduto(produtoPed.produtoId!);
      produtos.add(produto!);
      total += produtoPed.quantidade * produtoPed.precoVendaProduto;
    }
    setState(() {
      this.pedido = pedido;
      this.cliente = cliente;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigator.of(context)
              //     .pushNamed('/edit-product', arguments: produto)
              //     .then((_) => _loadProduto());
            },
          ),
          //delete
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await PedidoDao.deletePedido(widget.id);
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Não foi possível deletar o pedido $e'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: pedido != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido ${pedido!.id} - ${pedido!.data.day}/${pedido!.data.month}/${pedido!.data.year}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text(
                    'Cliente: ${cliente!.nome}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Modo de encomenda: ${pedido!.modoEncomenda == ModoEncomenda.Retirada ? 'Retirada' : 'Entrega'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Prazo de entrega: ${pedido!.prazoEntrega.day}/${pedido!.prazoEntrega.month}/${pedido!.prazoEntrega.year}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Status: ${pedido!.status == Status.emPreparacao ? 'Em preparação' : pedido!.status == Status.emTransporte ? 'Em transporte' : pedido!.status == Status.entregue ? 'Entregue' : pedido!.status == Status.pagamentoConfirmado ? 'Pagamento confirmado' : 'Aguardando pagamento'}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Total: R\$ ${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              produtos
                                  .where((element) =>
                                      element.id ==
                                      pedido!.produtosPedido![index].produtoId)
                                  .first
                                  .nome,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Text(
                              "${pedido!.produtosPedido![index].quantidade} x R\$ ${pedido!.produtosPedido![index].precoVendaProduto.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                      itemCount: pedido!.produtosPedido!.length,
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
