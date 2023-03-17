import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/main_drawer.dart';
import 'package:projeto_bd/app/features/armazem/model/armazem.dart';
import 'package:projeto_bd/app/features/armazem/controller/armazem_dao.dart';

class ArmazensScreen extends StatefulWidget {
  const ArmazensScreen({Key? key}) : super(key: key);

  @override
  State<ArmazensScreen> createState() => _ArmazensScreenState();
}

class _ArmazensScreenState extends State<ArmazensScreen> {
  List<Armazem> _armazens = [];

  bool _isLoading = false;
  String msgSeed = '';

  @override
  void initState() {
    super.initState();
    _loadArmazens();
  }

  Future<void> _loadArmazens() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final armazens = await ArmazemDao.getArmazens();
      setState(() {
        _armazens = armazens;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _armazens = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(routeName: '/armazens'),
      appBar: AppBar(
        title: const Text('Armazéns'),
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
                      await ArmazemDao.seed(quantidade, (msg) {
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
                  break;
                case 'clear':
                  try {
                    await ArmazemDao.clear();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                  break;
              }
              _loadArmazens();
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/add-armazem')
                    .then((value) => _loadArmazens());
              },
              icon: const Icon(Icons.add)),
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
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _armazens.length,
                    itemBuilder: (context, index) {
                      final armazem = _armazens[index];
                      return Card(
                        child: ListTile(
                            leading:
                                const CircleAvatar(child: Icon(Icons.store)),
                            title: Text(armazem.nome),
                            subtitle: Text(armazem.endereco),
                            onTap: () => Navigator.of(context)
                                .pushNamed('/edit-armazem', arguments: armazem)
                                .then((value) => _loadArmazens())),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
