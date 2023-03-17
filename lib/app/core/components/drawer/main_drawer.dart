import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/components/drawer/drawer_item.dart';
import 'package:projeto_bd/app/core/helpers/theme_helper.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
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
                child: AnimatedBuilder(
                    animation: ThemeHelper.instance,
                    builder: (context, child) {
                      return IconButton(
                        icon: Icon(ThemeHelper.instance.darkMode
                            ? Icons.light_mode
                            : Icons.dark_mode),
                        onPressed: () {
                          ThemeHelper.instance.changeTheme();
                        },
                      );
                    }),
              ),
            ],
          ),
          DrawerItem(
            icon: Icons.home,
            title: 'Home',
            routeName: '/home',
            isSelected: routeName == '/home' ? true : false,
          ),
          DrawerItem(
            icon: Icons.shopping_bag_rounded,
            title: 'Produtos',
            routeName: '/produtos',
            isSelected: routeName == '/produtos' ? true : false,
          ),
          DrawerItem(
            icon: Icons.shopping_cart,
            title: 'Fornecedores',
            routeName: '/fornecedores',
            isSelected: routeName == '/fornecedores' ? true : false,
          ),
          DrawerItem(
            icon: Icons.category,
            title: 'Categorias',
            routeName: '/categorias',
            isSelected: routeName == '/categorias' ? true : false,
          ),
          DrawerItem(
            icon: Icons.store,
            title: 'Armazéns',
            routeName: '/armazens',
            isSelected: routeName == '/armazens' ? true : false,
          ),
          DrawerItem(
            icon: Icons.person,
            title: 'Clientes',
            routeName: '/clientes',
            isSelected: routeName == '/clientes' ? true : false,
          ),
          DrawerItem(
            icon: Icons.list,
            title: 'Pedidos',
            routeName: '/pedidos',
            isSelected: routeName == '/pedidos' ? true : false,
          ),
        ],
      ),
    );
  }
}
