import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/main_drawer.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({Key? key}) : super(key: key);

  @override
  State<ProdutosScreen> createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  List<Produto> _produtos = [];

  bool _isLoading = false;
  String msgSeed = '';
  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final produtos = await ProdutoDao.getProdutos();
      setState(() {
        _produtos = produtos;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _produtos = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          MediaQuery.of(context).size.width <= 500 ? const MainDrawer() : null,
      appBar: AppBar(
        title: const Text('Produtos'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'seed',
                child: Text('Seed'),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('DROP *'),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'seed':
                  try {
                    var q = TextEditingController();
                    final quantidade = await showDialog<int>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Popular o Banco de Dados'),
                        content: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantidade',
                          ),
                          controller: q,
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
                              final quantidade = int.tryParse(q.text) ?? 0;
                              Navigator.of(context).pop(quantidade);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                    if (quantidade != null) {
                      setState(() {
                        _isLoading = true;
                      });
                      await ProdutoDao.seed(quantidade, (msg) {
                        setState(() {
                          msgSeed = msg;
                        });
                      });
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                  _loadProdutos();
                  break;
                case 'clear':
                  try {
                    await ProdutoDao.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                  _loadProdutos();
                  break;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add-product').then(
                    (_) => _loadProdutos(),
                  );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(msgSeed),
              ],
            ))
          : ListView.builder(
              itemCount: _produtos.length,
              itemBuilder: ((context, index) {
                final produto = _produtos[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.shopping_bag_rounded),
                    ),
                    title: Text(produto.nome),
                    subtitle: Text(produto.descricao),
                    trailing: Text('${produto.precoVenda}'),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/produto', arguments: produto.id)
                          .then((_) => _loadProdutos());
                    },
                    onLongPress: () async {
                      try {
                        await ProdutoDao.deleteProduto(produto.id);
                        _loadProdutos();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Não é possivel excluir o produto, pois ele está vinculado a uma venda\n\n${e.toString()}"),
                          ),
                        );
                      }
                    },
                  ),
                );
              }),
            ),
    );
  }
}
