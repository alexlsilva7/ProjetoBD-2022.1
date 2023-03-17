import 'package:projeto_bd/app/features/pedido/model/produto_pedido.dart';

class Pedido {
  int? id;
  DateTime data;
  ModoEncomenda modoEncomenda;
  Status status;
  DateTime prazoEntrega;
  int clienteId;
  List<ProdutoPedido>? produtosPedido = [];

  Pedido({
    this.id,
    required this.data,
    required this.modoEncomenda,
    required this.status,
    required this.prazoEntrega,
    required this.clienteId,
    this.produtosPedido,
  });

  @override
  String toString() {
    return 'Pedido(id: $id, data: $data, modoEncomenda: $modoEncomenda, status: $status, prazoEntrega: $prazoEntrega, clienteId: $clienteId)';
  }

  Pedido copyWith({
    int? id,
    DateTime? data,
    ModoEncomenda? modoEncomenda,
    Status? status,
    DateTime? prazoEntrega,
    int? clienteId,
    List<ProdutoPedido>? produtosPedido,
  }) {
    return Pedido(
      id: id ?? this.id,
      data: data ?? this.data,
      modoEncomenda: modoEncomenda ?? this.modoEncomenda,
      status: status ?? this.status,
      prazoEntrega: prazoEntrega ?? this.prazoEntrega,
      clienteId: clienteId ?? this.clienteId,
      produtosPedido: produtosPedido ?? this.produtosPedido,
    );
  }
}

// ignore: constant_identifier_names
enum ModoEncomenda { Retirada, Entrega }

enum Status {
  emPreparacao,
  emTransporte,
  entregue,
  aguardandoPagamento,
  pagamentoConfirmado,
}
