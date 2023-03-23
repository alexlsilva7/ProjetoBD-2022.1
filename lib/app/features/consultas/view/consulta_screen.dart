import 'package:flutter/material.dart';
import 'package:projeto_bd/app/features/consultas/controller/consultas_controller.dart';
import 'package:projeto_bd/app/features/consultas/view/components/data_source_data_table.dart';

class ConsultaScreen extends StatefulWidget {
  final int id;
  const ConsultaScreen({super.key, required this.id});

  @override
  State<ConsultaScreen> createState() => _ConsultaScreenState();
}

class _ConsultaScreenState extends State<ConsultaScreen> {
  final ConsultasController _controller = ConsultasController();

  List<Map<String, dynamic>>? _rows;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta ${widget.id}'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Query'),
                  content: Text(
                    _controller.getConsultaMapById(widget.id)['query'],
                    textAlign: TextAlign.justify,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Fechar'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text(
              _controller.getConsultaMapById(widget.id)['title'],
              maxLines: 10,
              textAlign: TextAlign.justify,
              style: const TextStyle(
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
                  try {
                    final rows = await _controller.getConsulta(widget.id);
                    setState(() {
                      _rows = rows;
                      _isLoading = false;
                    });
                  } catch (e) {
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao executar a consulta: $e'),
                      ),
                    );
                  }
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
                            PaginatedDataTable(
                              columns: [
                                ..._rows!.first.keys
                                    .map((e) => DataColumn(label: Text(e)))
                                    .toList()
                              ],
                              columnSpacing: 16,
                              showFirstLastButtons: true,
                              rowsPerPage: 20,
                              source: DataTableSourceImp(_rows!),
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
