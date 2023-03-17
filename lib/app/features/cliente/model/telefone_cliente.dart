class TelefoneCliente {
  int? clienteId;
  String telefone;

  TelefoneCliente({this.clienteId, required this.telefone});

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'telefone': telefone,
    };
  }

  static TelefoneCliente fromMap(Map<String, dynamic> map) {
    return TelefoneCliente(
      clienteId: map['clienteId'],
      telefone: map['telefone'],
    );
  }
}
