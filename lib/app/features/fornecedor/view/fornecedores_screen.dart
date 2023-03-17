import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/main_drawer.dart';
import 'package:projeto_bd/app/features/fornecedor/controller/fornecedor_dao.dart';
import 'package:projeto_bd/app/features/fornecedor/model/fornecedor.dart';

class FornecedoresScreen extends StatefulWidget {
  const FornecedoresScreen({Key? key}) : super(key: key);

  @override
  State<FornecedoresScreen> createState() => _FornecedoresScreenState();
}

class _FornecedoresScreenState extends State<FornecedoresScreen> {
  List<Fornecedor> _fornecedores = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _loadFornecedores();
  }

  Future<void> _loadFornecedores() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fornecedores = await FornecedorDao.getFornecedores();
      setState(() {
        _fornecedores = fornecedores;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _fornecedores = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(routeName: '/fornecedores'),
      appBar: AppBar(
        title: const Text('Fornecedores'),
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
                      //TODO progress status bar
                      await FornecedorDao.seed(quantidade);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                  _loadFornecedores();
                  break;
                case 'clear':
                  try {
                    await FornecedorDao.clear();
                    _loadFornecedores();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                  break;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add-fornecedor').then(
                    (_) => _loadFornecedores(),
                  );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _fornecedores.length,
              itemBuilder: ((context, index) {
                final fornecedor = _fornecedores[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/edit-fornecedor', arguments: fornecedor)
                        .then(
                          (_) => _loadFornecedores(),
                        );
                  },
                  onLongPress: () async {
                    try {
                      await FornecedorDao.deleteFornecedor(fornecedor.id);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                    _loadFornecedores();
                  },
                  child: Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.people)),
                      title: Text(fornecedor.nome),
                      subtitle: Text(fornecedor.documento),
                    ),
                  ),
                );
              }),
            ),
    );
  }
}
