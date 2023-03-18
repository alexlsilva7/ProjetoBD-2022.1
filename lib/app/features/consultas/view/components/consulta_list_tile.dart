import 'package:flutter/material.dart';

class ConsultaListTile extends StatelessWidget {
  final String consulta;
  final String rota;

  const ConsultaListTile(
      {super.key, required this.consulta, required this.rota});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          consulta,
          maxLines: 10,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              fontSize: 16, height: 1.2, fontWeight: FontWeight.w600),
        ),
        onTap: () => Navigator.of(context).pushNamed(rota),
      ),
    );
  }
}
