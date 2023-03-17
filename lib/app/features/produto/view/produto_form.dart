// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
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

  Categoria? _categoriaSelecionada;

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
    if (!_isEditing) {
      _loadCategorias();
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                maxLines: 3,
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Preço de custo',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _produto.precoCusto.toString(),
                onSaved: (value) {
                  _produto =
                      _produto.copyWith(precoCusto: double.parse(value!));
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Preço de venda',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _produto.precoVenda.toString(),
                onSaved: (value) {
                  _produto =
                      _produto.copyWith(precoVenda: double.parse(value!));
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Preço de venda mínimo',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (double.parse(value) > _produto.precoVenda) {
                    return 'O preço de venda mínimo não pode ser maior que o preço de venda';
                  } else if (double.parse(value) < _produto.precoCusto) {
                    return 'O preço de venda mínimo não pode ser menor que o preço de custo';
                  } else if (double.parse(value) == 0) {
                    return 'O preço de venda mínimo não pode ser igual a 0';
                  }
                  return null;
                },
                initialValue: _produto.precoVendaMin.toString(),
                onSaved: (value) {
                  _produto =
                      _produto.copyWith(precoVendaMin: double.parse(value!));
                },
              ),
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
              if (_categorias.isNotEmpty && !_isEditing)
                DropdownButtonFormField<Categoria>(
                  decoration: const InputDecoration(
                    labelText: 'Categoria Inicial',
                  ),
                  value: _categorias.firstWhere(
                    (categoria) =>
                        categoria.id ==
                        ((_produto.categorias != null &&
                                _produto.categorias!.isNotEmpty)
                            ? _produto.categorias!.first.id
                            : 0),
                    orElse: () => _categorias.first,
                  ),
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
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate() &&
                            _categoriaSelecionada != null) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            if (_isEditing) {
                              await ProdutoDao.updateProduto(_produto)
                                  .then((value) => Navigator.of(context).pop());
                            } else {
                              _produto = _produto.copyWith(
                                id: await ProdutoDao.addProduto(_produto),
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
