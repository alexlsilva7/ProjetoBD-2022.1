import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/armazem/controller/armazem_dao.dart';
import 'package:projeto_bd/app/features/armazem/model/armazem.dart';

class ArmazemForm extends StatefulWidget {
  final Armazem? armazem;

  const ArmazemForm({Key? key, this.armazem}) : super(key: key);

  @override
  State<ArmazemForm> createState() => _ArmazemFormState();
}

class _ArmazemFormState extends State<ArmazemForm> {
  final _formKey = GlobalKey<FormState>();
  late Armazem _armazem;
  late bool _isEditing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.armazem != null;
    _armazem = widget.armazem ??
        Armazem(
          id: 0,
          nome: '',
          endereco: '',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Armazém' : 'Novo Armazém'),
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
                initialValue: _armazem.nome,
                onSaved: (value) {
                  _armazem = _armazem.copyWith(nome: value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Endereço',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _armazem.endereco,
                onSaved: (value) {
                  _armazem = _armazem.copyWith(endereco: value);
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
                            await ArmazemDao.updateArmazem(_armazem)
                                .then((value) => Navigator.of(context).pop());
                          } else {
                            await ArmazemDao.addArmazem(_armazem)
                                .then((value) => Navigator.of(context).pop());
                          }
                          setState(() {
                            _isLoading = false;
                          });
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
