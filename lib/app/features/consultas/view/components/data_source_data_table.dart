import 'package:flutter/material.dart';

class DataTableSourceImp extends DataTableSource {
  final List<Map<String, dynamic>> _rows;

  DataTableSourceImp(this._rows);

  @override
  DataRow getRow(int index) {
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      cells: [...row.values.map((e) => DataCell(Text(e.toString()))).toList()],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;
}
