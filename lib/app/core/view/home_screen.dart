// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/main_drawer.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAllStats();
  }

  Future<void> _loadAllStats({bool isRefresh = false}) async {
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
    return Scaffold(
      drawer: const MainDrawer(routeName: '/home'),
      appBar: AppBar(
        title: const Text('Projeto BD - Home'),
      ),
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
                                    leading: const Icon(Icons.shopping_bag),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      _loadAllStats(isRefresh: true);
                                    },
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                            ListTile(
                              title: Text(
                                  'Fornecedores Cadastrados: $quantidadeFornecedores'),
                              leading: const Icon(Icons.shopping_cart),
                            ),
                            ListTile(
                              title: Text(
                                  'Categorias Cadastradas: $quantidadeCategorias'),
                              leading: const Icon(Icons.category),
                            ),
                            ListTile(
                              title: Text(
                                  'Armazens Cadastrados: $quantidadeArmazens'),
                              leading: const Icon(Icons.store),
                            ),
                            ListTile(
                              title: Text(
                                  'Estoques Cadastrados: $quantidadeEstoques'),
                              leading: const Icon(Icons.storage),
                            ),
                            ListTile(
                              title: Text(
                                  'Clientes Cadastrados: $quantidadeClientes'),
                              leading: const Icon(Icons.person),
                            ),
                            ListTile(
                              title: Text(
                                  'Pedidos Cadastrados: $quantidadePedidos'),
                              leading: const Icon(Icons.list_alt_rounded),
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
