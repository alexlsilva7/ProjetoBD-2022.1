class EmailCliente {
  int? clienteId;
  String email;

  EmailCliente({this.clienteId, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'clienteId': clienteId,
      'email': email,
    };
  }

  static EmailCliente fromMap(Map<String, dynamic> map) {
    return EmailCliente(
      clienteId: map['clienteId'],
      email: map['email'],
    );
  }
}
