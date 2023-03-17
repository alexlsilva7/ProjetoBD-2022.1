import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/drawer_item.dart';
import 'package:projeto_bd/app/core/controller/app_controller.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(builder: (context, appController, _) {
      return Drawer(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircleAvatar(radius: 50, child: Text('BD')),
                        Text(
                          'Projeto BD',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: ValueListenableBuilder(
                      valueListenable:
                          AdaptiveTheme.of(context).modeChangeNotifier,
                      builder: (context, mode, _) {
                        return IconButton(
                          icon: Icon(
                              mode.isDark ? Icons.light_mode : Icons.dark_mode),
                          onPressed: () {
                            if (mode.isDark) {
                              AdaptiveTheme.of(context).setLight();
                            } else {
                              AdaptiveTheme.of(context).setDark();
                            }
                          },
                        );
                      }),
                ),
              ],
            ),
            DrawerItem(
              icon: Icons.home,
              title: 'Home',
              onTap: () {
                appController.selectedIndex = 0;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 0 ? true : false,
            ),
            DrawerItem(
              icon: Icons.shopping_bag_rounded,
              title: 'Produtos',
              onTap: () {
                appController.selectedIndex = 1;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 1 ? true : false,
            ),
            DrawerItem(
              icon: Icons.people,
              title: 'Fornecedores',
              onTap: () {
                appController.selectedIndex = 2;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 2 ? true : false,
            ),
            DrawerItem(
              icon: Icons.category,
              title: 'Categorias',
              onTap: () {
                appController.selectedIndex = 3;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 3 ? true : false,
            ),
            DrawerItem(
              icon: Icons.store,
              title: 'Armazéns',
              onTap: () {
                appController.selectedIndex = 4;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 4 ? true : false,
            ),
            DrawerItem(
              icon: Icons.person,
              title: 'Clientes',
              onTap: () {
                appController.selectedIndex = 5;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 5 ? true : false,
            ),
            DrawerItem(
              icon: Icons.list,
              title: 'Pedidos',
              onTap: () {
                appController.selectedIndex = 6;
                Navigator.of(context).pop();
              },
              isSelected: appController.selectedIndex == 6 ? true : false,
            ),
          ],
        ),
      );
    });
  }
}
