// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';
import 'package:projeto_bd/app/features/pedido/controller/pedido_dao.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';

class ClienteScreen extends StatefulWidget {
  final int id;
  const ClienteScreen({super.key, required this.id});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  Cliente? cliente;
  List<Pedido> pedidos = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCliente();
  }

  Future<void> _loadCliente() async {
    setState(() {
      isLoading = true;
    });

    final cliente = await ClienteDao.getCliente(widget.id);
    final pedidos = await PedidoDao.getPedidosByClienteId(widget.id);

    setState(() {
      this.cliente = cliente;
      this.pedidos = pedidos;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/edit-cliente',
                      arguments: cliente!.id)
                  .then((value) => _loadCliente());
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await ClienteDao.deleteCliente(widget.id);
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Não foi possível deletar o cliente $e'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: !isLoading
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                        cliente!.nome,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Informações',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              ClientItemInfo(
                                  title: 'Cidade', value: cliente!.cidade),
                              const SizedBox(height: 8),
                              ClientItemInfo(
                                  title: 'Estado', value: cliente!.estado),
                              const SizedBox(height: 8),
                              ClientItemInfo(
                                  title: 'País', value: cliente!.pais),
                              const SizedBox(height: 8),
                              ClientItemInfo(
                                title: 'Telefones',
                                value: cliente!.telefones!
                                    .map((e) => e.telefone)
                                    .join(', '),
                              ),
                              const SizedBox(height: 8),
                              ClientItemInfo(
                                title: 'Emails',
                                value: cliente!.emails!
                                    .map((e) => e.email)
                                    .join(', '),
                              ),
                              const SizedBox(height: 8),
                              if (MediaQuery.of(context).size.width < 800)
                                ClientePedidosListView(
                                    pedidos: pedidos,
                                    onRefreshPedidos: _loadCliente),
                            ],
                          ),
                        ),
                        if (MediaQuery.of(context).size.width >= 800)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: ClientePedidosListView(
                                  pedidos: pedidos,
                                  onRefreshPedidos: _loadCliente),
                            ),
                          ),
                      ],
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
      ),
    );
  }
}

class ClientItemInfo extends StatelessWidget {
  final String title;
  final String value;
  const ClientItemInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ClientePedidosListView extends StatelessWidget {
  final List<Pedido> pedidos;
  final VoidCallback onRefreshPedidos;
  const ClientePedidosListView(
      {super.key, required this.pedidos, required this.onRefreshPedidos});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Pedidos',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
        ),
        Column(
          children: [
            ...pedidos.map(
              (e) => SizedBox(
                width: double.infinity,
                child: Card(
                  child: ListTile(
                    title: Text(
                      "Pedido ${e.id}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      "${e.data.day}/${e.data.month}/${e.data.year}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/pedido', arguments: e.id)
                          .then((value) => onRefreshPedidos());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
