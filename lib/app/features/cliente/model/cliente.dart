import 'package:projeto_bd/app/features/cliente/model/email_cliente.dart';
import 'package:projeto_bd/app/features/cliente/model/telefone_cliente.dart';

class Cliente {
  int? id;
  final String nome;
  final String pais;
  final String estado;
  final String cidade;
  final double limiteCredito;
  final DateTime dataCadastro;
  List<TelefoneCliente>? telefones;
  List<EmailCliente>? emails;

  Cliente({
    this.id,
    required this.nome,
    required this.pais,
    required this.estado,
    required this.cidade,
    required this.limiteCredito,
    required this.dataCadastro,
    this.telefones,
    this.emails,
  });

  Cliente copyWith({
    int? id,
    String? nome,
    String? pais,
    String? estado,
    String? cidade,
    double? limiteCredito,
    DateTime? dataCadastro,
    List<TelefoneCliente>? telefones,
    List<EmailCliente>? emails,
  }) {
    return Cliente(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      pais: pais ?? this.pais,
      estado: estado ?? this.estado,
      cidade: cidade ?? this.cidade,
      limiteCredito: limiteCredito ?? this.limiteCredito,
      dataCadastro: dataCadastro ?? this.dataCadastro,
      telefones: telefones ?? this.telefones,
      emails: emails ?? this.emails,
    );
  }

  @override
  String toString() {
    return 'Cliente(id: $id, nome: $nome, pais: $pais, estado: $estado, cidade: $cidade, limiteCredito: $limiteCredito, dataCadastro: $dataCadastro, telefones: $telefones, emails: $emails)';
  }
}
