// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/armazem/controller/armazem_dao.dart';
import 'package:projeto_bd/app/features/armazem/model/armazem.dart';
import 'package:projeto_bd/app/features/categoria/controller/categoria_dao.dart';
import 'package:projeto_bd/app/features/categoria/model/categoria.dart';
import 'package:projeto_bd/app/features/fornecedor/controller/fornecedor_dao.dart';
import 'package:projeto_bd/app/features/fornecedor/model/fornecedor.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_categoria_dao.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';

class ProdutoForm extends StatefulWidget {
  final Produto? produto;

  const ProdutoForm({super.key, this.produto});

  @override
  State<ProdutoForm> createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<ProdutoForm> {
  final _formKey = GlobalKey<FormState>();
  late Produto _produto;
  late bool _isEditing;

  bool _isLoading = false;

  List<Fornecedor> _fornecedores = [];
  List<Categoria> _categorias = [];
  List<Armazem> _armazens = [];

  Categoria? _categoriaSelecionada;
  Armazem? _armazemSelecionado;

  int _quantidadeInicial = 0;

  late TextEditingController _precoCustoController;
  late TextEditingController _precoVendaController;
  late TextEditingController _precoVendaMinController;
  final TextEditingController _quantidadeInicialController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    _isEditing = widget.produto != null;
    _produto = widget.produto ??
        Produto(
          id: 0,
          nome: '',
          descricao: '',
          dataGarantia: DateTime.now(),
          status: StatusProduto.Ativo,
          precoCusto: 0.0,
          precoVenda: 0.0,
          precoVendaMin: 0.0,
          fornecedorId: 0,
        );
    _loadFornecedores();
    if (_isEditing) {
      _precoCustoController = TextEditingController(
        text: _produto.precoCusto.toStringAsFixed(2),
      );
      _precoVendaController = TextEditingController(
        text: _produto.precoVenda.toStringAsFixed(2),
      );
      _precoVendaMinController = TextEditingController(
        text: _produto.precoVendaMin.toStringAsFixed(2),
      );
    } else {
      _loadCategorias();
      _loadArmazens();
      _precoCustoController = TextEditingController();
      _precoVendaController = TextEditingController();
      _precoVendaMinController = TextEditingController();
    }
  }

  void _loadFornecedores() async {
    final fornecedores = await FornecedorDao.getFornecedores();
    setState(() {
      _fornecedores = fornecedores;
      if (_fornecedores.isNotEmpty && _produto.fornecedorId == 0) {
        _produto = _produto.copyWith(fornecedorId: _fornecedores.first.id);
      }
    });
  }

  void _loadCategorias() async {
    final categorias = await CategoriaDao.getCategorias();
    if (categorias.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre uma categoria antes de cadastrar um produto'),
        ),
      );
      Navigator.of(context).pop();
    }
    setState(() {
      _categorias = categorias;
      _categoriaSelecionada = _categorias.first;
    });
  }

  void _loadArmazens() async {
    final armazens = await ArmazemDao.getArmazens();
    if (armazens.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastre um armazém antes de cadastrar um produto'),
        ),
      );
      Navigator.of(context).pop();
    }
    setState(() {
      _armazens = armazens;
      _armazemSelecionado = _armazens.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Novo Produto'),
      ),
      body: SingleChildScrollView(
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _produto.nome,
                onSaved: (value) {
                  _produto = _produto.copyWith(nome: value);
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                maxLines: 3,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _produto.descricao,
                onSaved: (value) {
                  _produto = _produto.copyWith(descricao: value);
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precoCustoController,
                      decoration: const InputDecoration(
                        labelText: 'Preço de custo',
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (double.tryParse(value) == 0) {
                          return 'O preço de custo não pode ser igual a 0';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          value = value.replaceAll(RegExp(r'[^\d.]'), '');
                          _precoCustoController.text = value;
                          _precoCustoController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: value.length),
                          );
                        }
                      },
                      onSaved: (value) {
                        _produto =
                            _produto.copyWith(precoCusto: double.parse(value!));
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _precoVendaController,
                      decoration: const InputDecoration(
                        labelText: 'Preço de venda',
                      ),
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (double.tryParse(value)! == 0) {
                          return 'O preço de venda não pode ser igual a 0';
                        } else if (_precoCustoController.text.isNotEmpty &&
                            double.tryParse(value)! <=
                                double.tryParse(_precoCustoController.text)!) {
                          return 'O preço de venda não pode ser menor ou igual que o preço de custo';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          value = value.replaceAll(RegExp(r'[^\d.]'), '');
                          _precoVendaController.text = value;
                          _precoVendaController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: value.length),
                          );
                        }
                      },
                      onSaved: (value) {
                        _produto =
                            _produto.copyWith(precoVenda: double.parse(value!));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _precoVendaMinController,
                decoration: const InputDecoration(
                  labelText: 'Preço de venda mínimo',
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (double.tryParse(value)! == 0) {
                    return 'O preço de venda mínimo não pode ser igual a 0';
                  } else if (_precoVendaController.text.isNotEmpty &&
                      double.tryParse(value)! >=
                          double.tryParse(_precoVendaController.text)!) {
                    return 'O preço de venda mínimo não pode ser maior ou igual que o preço de venda';
                  } else if (_precoCustoController.text.isNotEmpty &&
                      double.tryParse(value)! <=
                          double.tryParse(_precoCustoController.text)!) {
                    return 'O preço de venda mínimo não pode ser menor ou igual que o preço de custo';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    value = value.replaceAll(RegExp(r'[^\d.]'), '');
                    _precoVendaMinController.text = value;
                    _precoVendaMinController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: value.length),
                    );
                  }
                },
                onSaved: (value) {
                  _produto =
                      _produto.copyWith(precoVendaMin: double.parse(value!));
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _produto.dataGarantia,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _produto = _produto.copyWith(dataGarantia: date);
                          });
                        }
                      },
                      child: Text(
                        'Data de garantia\n${_produto.dataGarantia.day}/${_produto.dataGarantia.month}/${_produto.dataGarantia.year}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: StatusProdutoDropdownButton(
                      status: _produto.status,
                      onChanged: (status) {
                        _produto = _produto.copyWith(status: status);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (_fornecedores.isNotEmpty)
                DropdownButtonFormField<Fornecedor>(
                  decoration: const InputDecoration(
                    labelText: 'Fornecedor',
                  ),
                  value: _fornecedores.firstWhere(
                    (fornecedor) => fornecedor.id == _produto.fornecedorId,
                    orElse: () => _fornecedores.first,
                  ),
                  items: _fornecedores
                      .map(
                        (fornecedor) => DropdownMenuItem<Fornecedor>(
                          value: fornecedor,
                          child: Text(fornecedor.nome),
                        ),
                      )
                      .toList(),
                  onChanged: (fornecedor) {
                    _produto = _produto.copyWith(fornecedorId: fornecedor!.id);
                  },
                ),
              const SizedBox(height: 16.0),
              if (_categorias.isNotEmpty && !_isEditing)
                DropdownButtonFormField<Categoria>(
                  decoration: const InputDecoration(
                    labelText: 'Categoria Inicial',
                  ),
                  value: _categorias.first,
                  items: _categorias
                      .map(
                        (categoria) => DropdownMenuItem<Categoria>(
                          value: categoria,
                          child: Text(categoria.nome),
                        ),
                      )
                      .toList(),
                  onChanged: (categoria) {
                    _categoriaSelecionada = categoria;
                  },
                ),
              const SizedBox(height: 16.0),
              if (_armazens.isNotEmpty && !_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantidadeInicialController,
                        decoration: const InputDecoration(
                          labelText: 'Quantidade Inicial',
                        ),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo obrigatório';
                          } else if (int.tryParse(value)! == 0) {
                            return 'A quantidade inicial não pode ser igual a 0';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            value = value.replaceAll(RegExp(r'[^\d]'), '');
                            _quantidadeInicialController.text = value;
                            _quantidadeInicialController.selection =
                                TextSelection.fromPosition(
                              TextPosition(offset: value.length),
                            );
                          }
                        },
                        onSaved: (value) {
                          _quantidadeInicial = int.parse(value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: DropdownButtonFormField<Armazem>(
                        decoration: const InputDecoration(
                          labelText: 'Armazem Inicial',
                        ),
                        value: _armazens.first,
                        items: _armazens
                            .map(
                              (armazem) => DropdownMenuItem<Armazem>(
                                value: armazem,
                                child: Text(armazem.nome),
                              ),
                            )
                            .toList(),
                        onChanged: (armazem) {
                          _armazemSelecionado = armazem;
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            if (_isEditing) {
                              await ProdutoDao.updateProduto(_produto)
                                  .then((value) => Navigator.of(context).pop());
                            } else if (_categoriaSelecionada != null &&
                                _armazemSelecionado != null) {
                              _produto = _produto.copyWith(
                                id: await ProdutoDao.addProduto(
                                  _produto,
                                  _quantidadeInicial,
                                  _armazemSelecionado!.id!,
                                ),
                              );

                              await ProdutoCategoriaDAO.addProdutoCategoria(
                                      _produto.id, _categoriaSelecionada!.id!)
                                  .then((value) => Navigator.of(context).pop());
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
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
                    ? const CircularProgressIndicator()
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusProdutoDropdownButton extends StatelessWidget {
  final StatusProduto status;
  final ValueChanged<StatusProduto> onChanged;

  const StatusProdutoDropdownButton({
    super.key,
    required this.status,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<StatusProduto>(
      decoration: const InputDecoration(
        labelText: 'Status',
      ),
      value: status,
      items: StatusProduto.values
          .map(
            (status) => DropdownMenuItem<StatusProduto>(
              value: status,
              child: Text(status.toString().split('.').last),
            ),
          )
          .toList(),
      onChanged: (value) => onChanged(value!),
    );
  }
}
