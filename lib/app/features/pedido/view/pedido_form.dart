// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';
import 'package:projeto_bd/app/features/pedido/controller/pedido_dao.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';
import 'package:projeto_bd/app/features/pedido/model/produto_pedido.dart';
import 'package:projeto_bd/app/features/pedido/view/selecionar_produto_screen.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:select_dialog/select_dialog.dart';

class PedidoForm extends StatefulWidget {
  final Pedido? pedido;

  const PedidoForm({Key? key, this.pedido}) : super(key: key);

  @override
  State createState() => _PedidoFormState();
}

class _PedidoFormState extends State<PedidoForm> {
  final _formKey = GlobalKey<FormState>();
  late Pedido _pedido;
  late bool _isEditing;

  bool _isSaving = false;

  List<Produto> produtos = [];

  List<Cliente> clientes = [];

  Cliente? _cliente;

  Future<void> _loadClientes() async {
    clientes = await ClienteDao.getClientes();
    if (_pedido.clienteId != -1) {
      setState(() {
        _cliente = clientes.firstWhere((cliente) {
          return cliente.id == _pedido.clienteId;
        });
      });
    }
  }

  Future<void> _loadProdutos() async {
    produtos = await ProdutoDao.getProdutos();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _isEditing = widget.pedido != null;
    _pedido = widget.pedido != null
        ? widget.pedido!.copyWith()
        : Pedido(
            id: null,
            data: DateTime.now(),
            modoEncomenda: ModoEncomenda.Retirada,
            status: Status.aguardandoPagamento,
            prazoEntrega: DateTime.now().add(const Duration(days: 7)),
            clienteId: -1,
            produtosPedido: [],
          );
    _loadClientes();
    _loadProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Pedido' : 'Novo Pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Data do Pedido',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy').format(_pedido.data),
                      ),
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _pedido.data,
                          firstDate: DateTime(2006, 8),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 365 * 10)),
                        );
                        if (date != null) {
                          setState(() {
                            _pedido = _pedido.copyWith(data: date);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Prazo de Entrega',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: DateFormat('dd/MM/yyyy')
                            .format(_pedido.prazoEntrega),
                      ),
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: _pedido.prazoEntrega,
                          firstDate: DateTime(2006, 8),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 365 * 10)),
                        );
                        if (date != null) {
                          setState(() {
                            _pedido = _pedido.copyWith(prazoEntrega: date);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<ModoEncomenda>(
                      value: _pedido.modoEncomenda,
                      decoration: const InputDecoration(
                        labelText: 'Modo de Encomenda',
                      ),
                      items: ModoEncomenda.values.map((modo) {
                        return DropdownMenuItem<ModoEncomenda>(
                          value: modo,
                          child: Text(modo.toString().split('.')[1]),
                        );
                      }).toList(),
                      onChanged: (modo) {
                        setState(() {
                          _pedido = _pedido.copyWith(modoEncomenda: modo!);
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<Status>(
                      value: _pedido.status,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                      ),
                      items: Status.values.map((status) {
                        return DropdownMenuItem<Status>(
                          value: status,
                          child: Text(status.toString().split('.')[1]),
                        );
                      }).toList(),
                      onChanged: (status) {
                        setState(() {
                          _pedido = _pedido.copyWith(status: status!);
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cliente: ${_cliente?.nome ?? 'Nenhum selecionado'}'),
                  const SizedBox(width: 16),
                  ElevatedButton(
                      onPressed: () {
                        SelectDialog.showModal(
                          context,
                          label: "Clientes",
                          items: clientes,
                          itemBuilder: (BuildContext context, Cliente cliente,
                              bool isSelected) {
                            return ListTile(
                              title: Text(cliente.nome),
                              trailing: isSelected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : const Icon(Icons.add),
                            );
                          },
                          onChange: (Cliente cliente) {
                            setState(() {
                              _pedido =
                                  _pedido.copyWith(clienteId: cliente.id!);
                              _cliente = cliente;
                            });
                          },
                          onFind: (text) {
                            if (text.isEmpty) {
                              return Future(() => clientes);
                            } else {
                              return Future(() => clientes
                                  .where((e) =>
                                      e.nome
                                          .toLowerCase()
                                          .contains(text.toLowerCase()) ||
                                      e.pais
                                          .toLowerCase()
                                          .contains(text.toLowerCase()) ||
                                      e.estado
                                          .toLowerCase()
                                          .contains(text.toLowerCase()) ||
                                      e.cidade
                                          .toLowerCase()
                                          .contains(text.toLowerCase()) ||
                                      e.id.toString().contains(text))
                                  .toList());
                            }
                          },
                        );
                      },
                      child: const Text('Selecionar Cliente')),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Produtos: ${_pedido.produtosPedido!.length} item(s)'),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelecionaProdutoScreen(),
                        ),
                      ).then((value) {
                        if (value != null) {
                          if (_pedido.produtosPedido!
                              .where((element) => element.produtoId == value.id)
                              .isEmpty) {
                            _pedido.produtosPedido!.add(ProdutoPedido(
                              produtoId: value.id!,
                              pedidoId: _pedido.id,
                              precoVendaProduto: value.precoVenda,
                              quantidade: 1,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Produto já adicionado'),
                              ),
                            );
                          }
                        }
                      });
                      setState(() {});
                    },
                    child: const Text('Adicionar Produto'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (produtos.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final ProdutoPedido produtoPedido =
                          _pedido.produtosPedido![index];
                      final Produto produto = produtos.firstWhere(
                          (element) => element.id == produtoPedido.produtoId);
                      return Card(
                        child: ListTile(
                          title: Text(produto.nome),
                          subtitle: Text(
                            '${produtoPedido.quantidade} x ${produtoPedido.precoVendaProduto.toStringAsFixed(2)} = R\$ ${(produtoPedido.quantidade * produtoPedido.precoVendaProduto).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          //alterar quantidade with buttons, and cant be less than 1
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (produtoPedido.quantidade > 1) {
                                    setState(() {
                                      _pedido.produtosPedido![index] = _pedido
                                          .produtosPedido![index]
                                          .copyWith(
                                              quantidade:
                                                  produtoPedido.quantidade - 1);
                                    });
                                  }
                                },
                              ),
                              Text(produtoPedido.quantidade.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    _pedido.produtosPedido![index] =
                                        _pedido.produtosPedido![index].copyWith(
                                            quantidade:
                                                produtoPedido.quantidade + 1);
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    _pedido.produtosPedido!.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: _pedido.produtosPedido!.length,
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Total: R\$ ${_pedido.produtosPedido!.fold(0.0, (previousValue, element) => previousValue + (element.quantidade * element.precoVendaProduto)).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (_pedido.prazoEntrega
                                    .isBefore(_pedido.data)) {
                                  ScaffoldMessenger.of(context).setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Prazo de entrega inválido, deve ser maior que a data do pedido'),
                                      ),
                                    );
                                  });
                                } else if (_pedido.produtosPedido!.isEmpty) {
                                  ScaffoldMessenger.of(context).setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Pedido deve conter pelo menos um produto'),
                                      ),
                                    );
                                  });
                                } else if (_pedido.clienteId == -1) {
                                  ScaffoldMessenger.of(context).setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Pedido deve conter um cliente'),
                                      ),
                                    );
                                  });
                                } else {
                                  setState(() {
                                    _isSaving = true;
                                  });
                                  if (widget.pedido != null) {
                                    await PedidoDao.updatePedido(
                                        _pedido, widget.pedido!);
                                  } else {
                                    await PedidoDao.addPedido(_pedido);
                                  }
                                  setState(() {
                                    _isSaving = false;
                                  });
                                  Navigator.of(context).pop(_pedido);
                                }
                              }
                            },
                      child: _isSaving
                          ? const CircularProgressIndicator()
                          : Text(widget.pedido != null
                              ? 'Editar Pedido'
                              : 'Adicionar Pedido'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
