import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/consultas/controller/consultas_controller.dart';

class Consulta1Screen extends StatefulWidget {
  const Consulta1Screen({super.key});

  @override
  State<Consulta1Screen> createState() => _Consulta1ScreenState();
}

class _Consulta1ScreenState extends State<Consulta1Screen> {
  final ConsultasController _controller = ConsultasController();

  List<Map<String, dynamic>>? _rows;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta 1'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Text(
              '1. Liste a quantidade de vendas realizadas nos anos 2021, 2027 e 2015, agrupada pelo nome do produto, por ano e por mês; o resultado deve ser mostrado de maneira decrescente pelo valor da soma do total de vendas do produto.',
              maxLines: 10,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 16, height: 1.2, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  final rows = await _controller.getConsulta1();
                  setState(() {
                    _rows = rows;
                    _isLoading = false;
                  });
                },
                child: const Text('Executar consulta'),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()))
                : _rows != null && _rows!.isNotEmpty
                    ? Expanded(
                        child: ListView(
                          children: [
                            Text(
                              'Resultado (${_rows!.length} registros)',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 16),
                            DataTable(
                              columns: [
                                ..._rows!.first.keys
                                    .map((e) => DataColumn(label: Text(e)))
                                    .toList()
                              ],
                              rows: [
                                for (var row in _rows ?? [])
                                  DataRow(
                                    cells: [
                                      ...row.values.map(
                                          (e) => DataCell(Text(e.toString())))
                                    ],
                                  )
                              ],
                              headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                            ),
                          ],
                        ),
                      )
                    : _rows == null
                        ? const SizedBox()
                        : const Expanded(
                            child: Center(
                              child: Text('Nenhum resultado encontrado'),
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}
