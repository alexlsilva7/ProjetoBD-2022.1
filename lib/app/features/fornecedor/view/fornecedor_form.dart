import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/fornecedor/controller/fornecedor_dao.dart';
import 'package:projeto_bd/app/features/fornecedor/model/fornecedor.dart';

class FornecedorForm extends StatefulWidget {
  final Fornecedor? fornecedor;

  const FornecedorForm({Key? key, this.fornecedor}) : super(key: key);

  @override
  State<FornecedorForm> createState() => _FornecedorFormState();
}

class _FornecedorFormState extends State<FornecedorForm> {
  final _formKey = GlobalKey<FormState>();
  late Fornecedor _fornecedor;
  late bool _isEditing;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.fornecedor != null;
    _fornecedor = widget.fornecedor ??
        Fornecedor(
          id: 0,
          nome: '',
          documento: '',
          localidade: '',
          tipo: TipoFornecedor.Fisica,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Fornecedor' : 'Novo Fornecedor'),
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
                initialValue: _fornecedor.nome,
                onSaved: (value) {
                  _fornecedor = _fornecedor.copyWith(nome: value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Documento',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _fornecedor.documento,
                onSaved: (value) {
                  _fornecedor = _fornecedor.copyWith(documento: value);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Localidade',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  return null;
                },
                initialValue: _fornecedor.localidade,
                onSaved: (value) {
                  _fornecedor = _fornecedor.copyWith(localidade: value);
                },
              ),
              TipoFornecedorDropdown(
                fornecedor: _fornecedor,
                onChanged: (value) {
                  _fornecedor = _fornecedor.copyWith(tipo: value);
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
                            await FornecedorDao.updateFornecedor(_fornecedor)
                                .then((value) => Navigator.of(context).pop());
                          } else {
                            await FornecedorDao.addFornecedor(_fornecedor)
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

class TipoFornecedorDropdown extends StatefulWidget {
  final Fornecedor fornecedor;
  final ValueChanged<TipoFornecedor> onChanged;

  const TipoFornecedorDropdown({
    Key? key,
    required this.fornecedor,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<TipoFornecedorDropdown> createState() => _TipoFornecedorDropdownState();
}

class _TipoFornecedorDropdownState extends State<TipoFornecedorDropdown> {
  late TipoFornecedor _tipoFornecedor;

  @override
  void initState() {
    super.initState();
    _tipoFornecedor = widget.fornecedor.tipo;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<TipoFornecedor>(
      value: _tipoFornecedor,
      items: TipoFornecedor.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e.toString().split('.').last),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _tipoFornecedor = value!;
          widget.onChanged(value);
        });
      },
    );
  }
}
