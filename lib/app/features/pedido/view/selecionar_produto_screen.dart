import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/produto/controller/produto_dao.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:projeto_bd/app/features/produto/view/produto_form.dart';

class SelecionaProdutoScreen extends StatefulWidget {
  const SelecionaProdutoScreen({Key? key}) : super(key: key);

  @override
  _SelecionaProdutoScreenState createState() => _SelecionaProdutoScreenState();
}

class _SelecionaProdutoScreenState extends State<SelecionaProdutoScreen> {
  List<Produto> _produtos = [];

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    final List<Produto> produtos = await ProdutoDao.getProdutos();
    setState(() {
      _produtos = produtos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Produto'),
      ),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (BuildContext context, int index) {
          final Produto produto = _produtos[index];
          return ListTile(
            title: Text(produto.nome),
            subtitle: Text('R\$ ${produto.precoVenda.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.pop(context, produto);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Produto produto = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ProdutoForm(),
            ),
          );
          _produtos.add(produto);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
