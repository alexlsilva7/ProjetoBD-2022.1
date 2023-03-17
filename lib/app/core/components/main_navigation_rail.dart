import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/helpers/theme_helper.dart';
import 'package:provider/provider.dart';

class MainNavigationRail extends StatefulWidget {
  int selectedIndex;
  Function(int) onSelected;

  MainNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<MainNavigationRail> createState() => _MainNavigationRailState();
}

class _MainNavigationRailState extends State<MainNavigationRail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          widget.selectedIndex = index;
        });
        widget.onSelected(index);
      },
      labelType: MediaQuery.of(context).size.width > 800
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      extended: MediaQuery.of(context).size.width > 800,
      trailing: Consumer<ThemeHelper>(builder: (context, themeHelper, _) {
        return Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                    themeHelper.darkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  setState(() {
                    themeHelper.changeTheme();
                  });
                },
              )
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
  }
}
