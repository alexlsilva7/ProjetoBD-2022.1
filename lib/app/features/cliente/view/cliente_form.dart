import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/cliente/model/cliente.dart';
import 'package:projeto_bd/app/features/cliente/model/email_cliente.dart';
import 'package:projeto_bd/app/features/cliente/model/telefone_cliente.dart';

class ClienteForm extends StatefulWidget {
  final int? clienteId;

  const ClienteForm({Key? key, this.clienteId}) : super(key: key);

  @override
  State<ClienteForm> createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  Cliente? _cliente;
  late bool _isEditing;
  bool _isLoading = true;
  String email = '';
  String telefone = '';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.clienteId != null;
    if (_isEditing) {
      _loadCliente();
    } else {
      _cliente = Cliente(
        nome: '',
        pais: '',
        estado: '',
        cidade: '',
        limiteCredito: 0.0,
        dataCadastro: DateTime.now(),
        telefones: [],
        emails: [],
      );
    }
  }

  Future<void> _loadCliente() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final cliente = await ClienteDao.getCliente(widget.clienteId!);
      setState(() {
        _cliente = cliente;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Cliente' : 'Novo Cliente'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _cliente == null
              ? Center(
                  child: Column(children: [
                    const Text('Cliente não encontrado'),
                    ElevatedButton(
                        onPressed: () => _loadCliente(),
                        child: const Text('Tentar novamente'))
                  ]),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          initialValue: _cliente!.nome,
                          onSaved: (value) {
                            _cliente = _cliente!.copyWith(nome: value);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Cidade',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          initialValue: _cliente!.cidade,
                          onSaved: (value) {
                            _cliente = _cliente!.copyWith(cidade: value);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Estado',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          initialValue: _cliente!.estado,
                          onSaved: (value) {
                            _cliente = _cliente!.copyWith(estado: value);
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'País',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          initialValue: _cliente!.pais,
                          onSaved: (value) {
                            _cliente = _cliente!.copyWith(pais: value);
                          },
                        ),
                        //limite de credito
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Limite de Crédito',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            return null;
                          },
                          initialValue: _cliente!.limiteCredito.toString(),
                          onSaved: (value) {
                            _cliente = _cliente!.copyWith(
                              limiteCredito: double.parse(value!),
                            );
                          },
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Telefones',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Adicionar Telefone'),
                                              content: TextFormField(
                                                controller: _telefoneController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      'Telefone (com DDD)',
                                                ),
                                                keyboardType:
                                                    TextInputType.phone,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Campo obrigatório';
                                                  } else if (value.length <
                                                      11) {
                                                    return 'Telefone inválido';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  telefone = value!;
                                                },
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    var telefoneText =
                                                        _telefoneController
                                                            .text;
                                                    _cliente!.telefones!.add(
                                                      TelefoneCliente(
                                                        telefone: telefoneText,
                                                      ),
                                                    );
                                                    _telefoneController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text('Adicionar'),
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) => setState(() {}));
                                      },
                                      child: const Text('Adicionar Telefone'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _cliente!.telefones!
                                            .map(
                                              (e) => Chip(
                                                label: Text(e.telefone),
                                                onDeleted: () {
                                                  if (_cliente!
                                                          .telefones!.length >
                                                      1) {
                                                    setState(() {
                                                      _cliente!.telefones!
                                                          .remove(e);
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'O cliente deve ter pelo menos um telefone'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Emails',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Adicionar Email'),
                                              content: TextFormField(
                                                controller: _emailController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'email',
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Campo obrigatório';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  telefone = value!;
                                                },
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancelar'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    String emailText =
                                                        _emailController.text;
                                                    _cliente!.emails!.add(
                                                      EmailCliente(
                                                        email: emailText,
                                                      ),
                                                    );
                                                    _telefoneController.clear();
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text('Adicionar'),
                                                ),
                                              ],
                                            );
                                          },
                                        ).then((value) => setState(() {}));
                                      },
                                      child: const Text('Adicionar Telefone'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: _cliente!.emails!
                                            .map(
                                              (e) => Chip(
                                                label: Text(e.email),
                                                onDeleted: () {
                                                  if (_cliente!
                                                          .telefones!.length >
                                                      1) {
                                                    setState(() {
                                                      _cliente!.emails!
                                                          .remove(e);
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'O cliente deve ter pelo menos um email'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_cliente!.telefones!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'O cliente deve ter pelo menos um telefone'),
                                        ),
                                      );
                                      return;
                                    }
                                    if (_cliente!.emails!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'O cliente deve ter pelo menos um email'),
                                        ),
                                      );
                                      return;
                                    }
                                    _formKey.currentState!.save();
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      if (_isEditing) {
                                        await ClienteDao.updateCliente(
                                                _cliente!)
                                            .then((value) =>
                                                Navigator.pop(context));
                                      } else {
                                        await ClienteDao.addCliente(_cliente!)
                                            .then((value) =>
                                                Navigator.pop(context));
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                        ),
                                      );
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text('Salvar'),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
