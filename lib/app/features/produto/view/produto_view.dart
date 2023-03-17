import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/armazem/controller/armazem_dao.dart';
import 'package:projeto_bd/app/features/armazem/model/armazem.dart';
import 'package:projeto_bd/app/features/categoria/controller/categoria_dao.dart';
import 'package:projeto_bd/app/features/categoria/model/categoria.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:projeto_bd/app/features/produto/model/traducao_produto.dart';
import 'package:select_dialog/select_dialog.dart';

class ProdutoView extends StatefulWidget {
  final int id;
  const ProdutoView({super.key, required this.id});

  @override
  State<ProdutoView> createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> {
  Produto? produto;

  late final List<Categoria> todasCategorias;

  final TextEditingController _idiomaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Armazem? armazem;

  @override
  void initState() {
    super.initState();
    _loadProduto();
    _loadCategorias();
  }

  Future<void> _loadProduto() async {
    produto = await ProdutoDao.getProduto(widget.id);
    await _loadArmazem();
    setState(() {});
  }

  Future<void> _loadCategorias() async {
    todasCategorias = await CategoriaDao.getCategorias();
    setState(() {});
  }

  Future<void> _loadArmazem() async {
    armazem = await ArmazemDao.getArmazem(produto!.estoque!.armazemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed('/edit-product', arguments: produto)
                  .then((_) => _loadProduto());
            },
          ),
          //delete
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              try {
                await ProdutoDao.deleteProduto(produto!.id)
                    .then((value) => Navigator.of(context).pop());
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: produto != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto!.nome,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    Text(
                      produto!.descricao,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(),
                    Text(
                      'Preço de custo: R\$ ${produto!.precoCusto.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Preço de venda: R\$ ${produto!.precoVenda.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Preço de venda mínimo: R\$ ${produto!.precoVendaMin.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Data de garantia: ${produto!.dataGarantia}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantidade em estoque: ${produto!.estoque!.quantidade}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              //TODO Alterar quantidade
                            },
                            child: const Text('Alterar Quantidade')),
                      ],
                    ),
                    Text(
                      'Código do estoque: ${produto!.estoque!.codigo}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Armazem: ${armazem?.nome}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Categorias',
                                style: TextStyle(fontSize: 18),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    SelectDialog.showModal(
                                      context,
                                      label: "Categorias",
                                      items: todasCategorias,
                                      itemBuilder: (BuildContext context,
                                          Categoria categoria,
                                          bool isSelected) {
                                        return ListTile(
                                          title: Text(categoria.nome),
                                          trailing: isSelected
                                              ? const Icon(Icons.check,
                                                  color: Colors.green)
                                              : const Icon(Icons.add),
                                        );
                                      },
                                      onChange: (Categoria categoria) {
                                        if (produto!.categorias!
                                            .contains(categoria)) {
                                          if (produto!.categorias!.length > 1) {
                                            produto!
                                                .removeCategoria(categoria)
                                                .then(
                                                    (value) => _loadProduto());
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'O produto deve ter pelo menos uma categoria'),
                                              ),
                                            );
                                          }
                                        } else {
                                          produto!
                                              .addCategoria(categoria)
                                              .then((value) => _loadProduto());
                                        }
                                      },
                                      multipleSelectedValues:
                                          produto!.categorias,
                                      onFind: (text) {
                                        if (text.isEmpty) {
                                          return Future(() => todasCategorias);
                                        } else {
                                          return Future(() => todasCategorias
                                              .where((e) => e.nome
                                                  .toLowerCase()
                                                  .contains(text.toLowerCase()))
                                              .toList());
                                        }
                                      },
                                    );
                                  },
                                  child: const Text('Adicionar Categoria')),
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
                                  children: produto!.categorias!
                                      .map(
                                        (e) => Chip(
                                          label: Text(e.nome),
                                          onDeleted: () {
                                            if (produto!.categorias!.length >
                                                1) {
                                              produto!.removeCategoria(e).then(
                                                  (value) => _loadProduto());
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'O produto deve ter pelo menos uma categoria'),
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
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Traduções',
                                style: TextStyle(fontSize: 18),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    //dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Adicionar Tradução'),
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller: _idiomaController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Idioma'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'O idioma não pode ser vazio';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  controller: _nomeController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Nome'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'O nome não pode ser vazio';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _descricaoController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Descrição'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'A descrição não pode ser vazia';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  produto!
                                                      .addTraducao(
                                                    TraducaoProduto(
                                                        produtoId: produto!.id,
                                                        idioma:
                                                            _idiomaController
                                                                .text,
                                                        nome: _nomeController
                                                            .text,
                                                        descricao:
                                                            _descricaoController
                                                                .text),
                                                  )
                                                      .then((value) {
                                                    _nomeController.clear();
                                                    _descricaoController
                                                        .clear();
                                                    _loadProduto();
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              child: const Text('Adicionar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Adicionar Tradução')),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: ListView.builder(
                              itemCount: produto!.traducoes!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading:
                                      Text(produto!.traducoes![index].idioma),
                                  title: Text(produto!.traducoes![index].nome),
                                  subtitle: Text(
                                      produto!.traducoes![index].descricao),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      produto!
                                          .removeTraducao(
                                              produto!.traducoes![index])
                                          .then((value) => _loadProduto());
                                    },
                                  ),
                                  onTap: () {
                                    _idiomaController.text =
                                        produto!.traducoes![index].idioma;
                                    _nomeController.text =
                                        produto!.traducoes![index].nome;
                                    _descricaoController.text =
                                        produto!.traducoes![index].descricao;
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Editar Tradução'),
                                          content: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  controller: _idiomaController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Idioma'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'O idioma não pode ser vazio';
                                                    }
                                                    return null;
                                                  },
                                                  enabled: false,
                                                ),
                                                TextFormField(
                                                  controller: _nomeController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText: 'Nome'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'O nome não pode ser vazio';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                TextFormField(
                                                  controller:
                                                      _descricaoController,
                                                  decoration:
                                                      const InputDecoration(
                                                          labelText:
                                                              'Descrição'),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'A descrição não pode ser vazia';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  produto!
                                                      .updateTraducao(
                                                    TraducaoProduto(
                                                        produtoId: produto!.id,
                                                        idioma:
                                                            _idiomaController
                                                                .text,
                                                        nome: _nomeController
                                                            .text,
                                                        descricao:
                                                            _descricaoController
                                                                .text),
                                                  )
                                                      .then((value) {
                                                    _nomeController.clear();
                                                    _descricaoController
                                                        .clear();
                                                    _loadProduto();
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              child: const Text('Editar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
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
      ),
    );
  }
}
