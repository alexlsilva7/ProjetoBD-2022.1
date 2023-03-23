// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:projeto_bd/app/core/components/drawer/main_drawer.dart';
import 'package:projeto_bd/app/core/helpers/db_helper.dart';
import 'package:projeto_bd/app/features/armazem/controller/armazem_dao.dart';
import 'package:projeto_bd/app/features/categoria/controller/categoria_dao.dart';
import 'package:projeto_bd/app/features/cliente/controller/cliente_dao.dart';
import 'package:projeto_bd/app/features/estoque/controller/estoque_dao.dart';
import 'package:projeto_bd/app/features/fornecedor/controller/fornecedor_dao.dart';
import 'package:projeto_bd/app/features/pedido/controller/pedido_dao.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int quantidadeProdutos = 0;
  int quantidadeFornecedores = 0;
  int quantidadeCategorias = 0;
  int quantidadeArmazens = 0;
  int quantidadeEstoques = 0;
  int quantidadeClientes = 0;
  int quantidadePedidos = 0;

  bool isLoading = false;
  bool configIsOk = false;

  @override
  void initState() {
    super.initState();
    _loadAllStats();
  }

  Future<void> _loadAllStats({bool isRefresh = false}) async {
    try {
      if (!configIsOk) {
        await DbHelper.initConfig();
      }
      setState(() {
        isLoading = true;
      });
      try {
        await _loadQuantidadeProdutos();
        await _loadQuantidadeFornecedores();
        await _loadQuantidadeCategorias();
        await _loadQuantidadeArmazens();
        await _loadQuantidadeEstoques();
        await _loadQuantidadeClientes();
        await _loadQuantidadePedidos();
        setState(() {});
        if (isRefresh) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dados atualizados com sucesso!'),
            ),
          );
        }
      } catch (e) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao carregar dados: $e'),
            ),
          );
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      await configDialog();
    }
  }

  Future<void> configDialog() async {
    ConnectionSettings settings = await DbHelper.getConfig();
    showDialog(
      context: context,
      builder: (context) {
        GlobalKey<FormState> formDatabaseKey = GlobalKey<FormState>();
        return AlertDialog(
          title: const Text('Configuração do banco de dados'),
          content: Form(
            key: formDatabaseKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: settings.host,
                  decoration: const InputDecoration(
                    labelText: 'Host',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o host';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    settings.host = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: settings.port.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Porta',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a porta';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    settings.port = int.parse(value!);
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: settings.user,
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o usuário';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    settings.user = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: settings.password,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe a senha';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    settings.password = value!;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  initialValue: settings.db,
                  decoration: const InputDecoration(
                    labelText: 'Banco de dados',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o banco de dados';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    settings.db = value!;
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
              onPressed: () async {
                if (formDatabaseKey.currentState!.validate()) {
                  formDatabaseKey.currentState!.save();
                  DbHelper.setConfig(settings);
                  Navigator.of(context).pop();
                  configIsOk = true;
                  _loadAllStats();
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadQuantidadeProdutos() async {
    quantidadeProdutos = await ProdutoDao.count();
  }

  Future<void> _loadQuantidadeFornecedores() async {
    quantidadeFornecedores = await FornecedorDao.count();
  }

  Future<void> _loadQuantidadeCategorias() async {
    quantidadeCategorias = await CategoriaDao.count();
  }

  Future<void> _loadQuantidadeArmazens() async {
    quantidadeArmazens = await ArmazemDao.count();
  }

  Future<void> _loadQuantidadeEstoques() async {
    quantidadeEstoques = await EstoqueDao.count();
  }

  Future<void> _loadQuantidadeClientes() async {
    quantidadeClientes = await ClienteDao.count();
  }

  Future<void> _loadQuantidadePedidos() async {
    quantidadePedidos = await PedidoDao.count();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              configDialog();
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      drawer:
          MediaQuery.of(context).size.width <= 500 ? const MainDrawer() : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: isLoading
                    ? const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()))
                    : Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                        'Produtos Cadastrados: $quantidadeProdutos'),
                                    leading: Icon(
                                      Icons.shopping_bag,
                                      color: iconColor,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _loadAllStats(isRefresh: true);
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: iconColor,
                                    ))
                              ],
                            ),
                            ListTile(
                              title: Text(
                                  'Fornecedores Cadastrados: $quantidadeFornecedores'),
                              leading: Icon(
                                Icons.shopping_cart,
                                color: iconColor,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  'Categorias Cadastradas: $quantidadeCategorias'),
                              leading: Icon(
                                Icons.category,
                                color: iconColor,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  'Armazens Cadastrados: $quantidadeArmazens'),
                              leading: Icon(
                                Icons.store,
                                color: iconColor,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  'Estoques Cadastrados: $quantidadeEstoques'),
                              leading: Icon(
                                Icons.storage,
                                color: iconColor,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  'Clientes Cadastrados: $quantidadeClientes'),
                              leading: Icon(
                                Icons.person,
                                color: iconColor,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                  'Pedidos Cadastrados: $quantidadePedidos'),
                              leading: Icon(
                                Icons.list_alt_rounded,
                                color: iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
