import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/main_drawer.dart';
import 'package:projeto_bd/app/features/consultas/controller/consultas_controller.dart';
import 'package:projeto_bd/app/features/consultas/view/components/consulta_list_tile.dart';

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  ConsultasController controller = ConsultasController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:
          MediaQuery.of(context).size.width <= 500 ? const MainDrawer() : null,
      appBar: AppBar(
        title: const Text('Consultas'),
      ),
      body: ListView.builder(
        itemCount: controller.consultas.length,
        itemBuilder: (context, index) {
          return ConsultaListTile(
            consulta: controller.getConsultaMapById(index + 1)['title'],
            id: index + 1,
          );
        },
      ),
    );
  }
}
