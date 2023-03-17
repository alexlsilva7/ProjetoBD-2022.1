import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/controller/app_controller.dart';
import 'package:provider/provider.dart';

class MainNavigationRail extends StatefulWidget {
  const MainNavigationRail({super.key});

  @override
  State<MainNavigationRail> createState() => _MainNavigationRailState();
}

class _MainNavigationRailState extends State<MainNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        return NavigationRail(
          selectedIndex: appController.selectedIndex,
          onDestinationSelected: (int index) {
            appController.selectedIndex = index;
          },
          labelType: MediaQuery.of(context).size.width > 800
              ? NavigationRailLabelType.none
              : NavigationRailLabelType.selected,
          extended: MediaQuery.of(context).size.width > 800,
          trailing: ValueListenableBuilder(
              valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
              builder: (context, mode, _) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width > 800
                              ? 200
                              : 70,
                          child: TextButton(
                              onPressed: () {
                                if (mode.isDark) {
                                  AdaptiveTheme.of(context).setLight();
                                } else {
                                  AdaptiveTheme.of(context).setDark();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(mode.isDark
                                      ? Icons.light_mode
                                      : Icons.dark_mode),
                                  if (MediaQuery.of(context).size.width > 800)
                                    const SizedBox(width: 8),
                                  if (MediaQuery.of(context).size.width > 800)
                                    const Text('Tema'),
                                ],
                              ))),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              }),
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.home),
              selectedIcon: Icon(Icons.home),
              label: Text('Home'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.shopping_bag_rounded),
              selectedIcon: Icon(Icons.shopping_bag_rounded),
              label: Text('Produtos'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people),
              selectedIcon: Icon(Icons.people),
              label: Text('Fornecedores'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.category),
              selectedIcon: Icon(Icons.category),
              label: Text('Categorias'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.store),
              selectedIcon: Icon(Icons.store),
              label: Text('Armazéns'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.person),
              selectedIcon: Icon(Icons.person),
              label: Text('Clientes'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.list),
              selectedIcon: Icon(Icons.list),
              label: Text('Pedidos'),
            ),
          ],
        );
      },
    );
  }
}
