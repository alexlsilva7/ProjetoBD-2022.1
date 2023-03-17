import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/main_navigation_rail.dart';
import 'package:projeto_bd/app/core/controller/app_controller.dart';
import 'package:projeto_bd/app/core/view/home_screen.dart';
import 'package:projeto_bd/app/features/armazem/view/armazens_screen.dart';
import 'package:projeto_bd/app/features/categoria/view/categorias_screen.dart';
import 'package:projeto_bd/app/features/cliente/view/clientes_screen.dart';
import 'package:projeto_bd/app/features/fornecedor/view/fornecedores_screen.dart';
import 'package:projeto_bd/app/features/pedido/view/pedidos_screen.dart';
import 'package:projeto_bd/app/features/produto/view/produtos_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MediaQuery.of(context).size.width > 500
              ? Consumer<AppController>(builder: (context, appController, _) {
                  return MainNavigationRail(
                    selectedIndex: appController.selectedIndex,
                    onSelected: (index) {
                      appController.selectedIndex = index;
                    },
                  );
                })
              : const SizedBox.shrink(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child:
                Consumer<AppController>(builder: (context, appController, _) {
              return IndexedStack(
                index: appController.selectedIndex,
                children: const [
                  HomeScreen(),
                  ProdutosScreen(),
                  FornecedoresScreen(),
                  CategoriasScreen(),
                  ArmazensScreen(),
                  ClientesScreen(),
                  PedidosScreen(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
