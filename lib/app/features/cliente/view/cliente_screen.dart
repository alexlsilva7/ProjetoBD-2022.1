// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';

class ClienteScreen extends StatefulWidget {
  final int id;
  const ClienteScreen({super.key, required this.id});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  Cliente? cliente;

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

    setState(() {
      this.cliente = cliente;
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
          //delete
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
      body: !isLoading
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nome: ${cliente!.nome}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cidade: ${cliente!.cidade}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estado: ${cliente!.estado}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'País: ${cliente!.pais}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  //telefones
                  Text(
                    'Telefones: ${cliente!.telefones!.map((e) => e.telefone).join(', ')}',
                    style: const TextStyle(fontSize: 18),
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
