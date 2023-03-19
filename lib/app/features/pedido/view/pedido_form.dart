import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';
import 'package:projeto_bd/app/features/pedido/view/selecionar_produto_screen.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:select_dialog/select_dialog.dart';

class PedidoForm extends StatefulWidget {
  final Pedido? pedido;

  const PedidoForm({Key? key, this.pedido}) : super(key: key);

  @override
  _PedidoFormState createState() => _PedidoFormState();
}

class _PedidoFormState extends State<PedidoForm> {
  final _formKey = GlobalKey<FormState>();
  late Pedido _pedido;
  late bool _isEditing;

  List<Cliente> clientes = [];

  Cliente? _cliente;

  Future<void> _loadClientes() async {
    clientes = await ClienteDao.getClientes();
    if (_pedido.clienteId != 0) {
      setState(() {
        _cliente = clientes.firstWhere((cliente) {
          return cliente.id == _pedido.clienteId;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadClientes();
    _isEditing = widget.pedido != null;
    _pedido = widget.pedido ??
        Pedido(
          id: null,
          data: DateTime.now(),
          modoEncomenda: ModoEncomenda.Retirada,
          status: Status.aguardandoPagamento,
          prazoEntrega: DateTime.now().add(const Duration(days: 7)),
          clienteId: 0,
          produtosPedido: [],
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Pedido' : 'Novo Pedido'),
      ),
      body: SingleChildScrollView(
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
                          initialDate: _pedido.prazoEntrega,
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
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

              const SizedBox(height: 16),
              // select cliente
              Row(
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final Produto produto = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SelecionaProdutoScreen(),
                    ),
                  );
                  setState(() {});
                },
                child: const Text('Adicionar Produto'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.of(context).pop(_pedido);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
