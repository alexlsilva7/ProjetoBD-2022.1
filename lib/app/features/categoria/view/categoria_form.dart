import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/categoria/controller/categoria_dao.dart';
import 'package:projeto_bd/app/features/categoria/model/categoria.dart';

class CategoriaForm extends StatefulWidget {
  const CategoriaForm({Key? key, this.categoria}) : super(key: key);

  final Categoria? categoria;

  @override
  State<CategoriaForm> createState() => _CategoriaFormState();
}

class _CategoriaFormState extends State<CategoriaForm> {
  final _formKey = GlobalKey<FormState>();
  late Categoria _categoria;
  late bool _isEditing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.categoria != null;
    _categoria = widget.categoria ??
        Categoria(
          nome: '',
          descricao: '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Categoria' : 'Nova Categoria'),
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
                initialValue: _categoria.nome,
                onSaved: (value) {
                  _categoria = _categoria.copyWith(nome: value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _categoria.descricao,
                onSaved: (value) {
                  _categoria = _categoria.copyWith(descricao: value);
                },
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });
                          if (_isEditing) {
                            await CategoriaDao.updateCategoria(_categoria)
                                .then((value) => Navigator.of(context).pop());
                          } else {
                            await CategoriaDao.addCategoria(_categoria)
                                .then((value) => Navigator.of(context).pop());
                          }
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                child: Text(_isEditing ? 'Salvar' : 'Adicionar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
