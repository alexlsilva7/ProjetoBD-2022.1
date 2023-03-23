import 'package:flutter/material.dart';
import 'package:projeto_bd/app/core/controller/app_controller.dart';
import 'package:projeto_bd/app/core/view/main_screen.dart';
import 'package:projeto_bd/app/features/armazem/model/armazem.dart';
import 'package:projeto_bd/app/features/armazem/view/armazem_form.dart';
import 'package:projeto_bd/app/features/categoria/model/categoria.dart';
import 'package:projeto_bd/app/features/categoria/view/categoria_form.dart';
import 'package:projeto_bd/app/features/cliente/view/cliente_form.dart';
import 'package:projeto_bd/app/features/cliente/view/cliente_screen.dart';
import 'package:projeto_bd/app/features/consultas/view/consulta_screen.dart';
import 'package:projeto_bd/app/features/fornecedor/model/fornecedor.dart';
import 'package:projeto_bd/app/features/fornecedor/view/fornecedor_form.dart';
import 'package:projeto_bd/app/features/pedido/model/pedido.dart';
import 'package:projeto_bd/app/features/pedido/view/pedido_form.dart';
import 'package:projeto_bd/app/features/pedido/view/pedido_screen.dart';
import 'package:projeto_bd/app/features/pedido/view/selecionar_produto_screen.dart';
import 'package:projeto_bd/app/features/produto/model/produto.dart';
import 'package:projeto_bd/app/features/produto/view/produto_screen.dart';
import 'package:projeto_bd/app/features/produto/view/produto_form.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MainApp(
    savedThemeMode: savedThemeMode,
  ));
}

class MainApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MainApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppController()),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) {
          return MaterialApp(
            home: const MainScreen(),
            routes: {
              '/add-product': (context) => const ProdutoForm(),
              '/edit-product': (context) => ProdutoForm(
                  produto:
                      ModalRoute.of(context)!.settings.arguments as Produto),
              '/add-fornecedor': (context) => const FornecedorForm(),
              '/edit-fornecedor': (context) => FornecedorForm(
                  fornecedor:
                      ModalRoute.of(context)!.settings.arguments as Fornecedor),
              '/add-categoria': (context) => const CategoriaForm(),
              '/edit-categoria': (context) => CategoriaForm(
                  categoria:
                      ModalRoute.of(context)!.settings.arguments as Categoria),
              '/produto': (context) => ProdutoScreen(
                  id: ModalRoute.of(context)!.settings.arguments as int),
              '/add-armazem': (context) => const ArmazemForm(),
              '/edit-armazem': (context) => ArmazemForm(
                  armazem:
                      ModalRoute.of(context)!.settings.arguments as Armazem),
              '/add-cliente': (context) => const ClienteForm(),
              '/edit-cliente': (context) => ClienteForm(
                  clienteId: ModalRoute.of(context)!.settings.arguments as int),
              '/pedido': (context) => PedidoScreen(
                    id: ModalRoute.of(context)!.settings.arguments as int,
                  ),
              '/add-pedido': (context) => const PedidoForm(),
              '/edit-pedido': (context) => PedidoForm(
                    pedido:
                        ModalRoute.of(context)!.settings.arguments as Pedido,
                  ),
              '/selecionar-produto': (context) =>
                  const SelecionaProdutoScreen(),
              '/cliente': (context) => ClienteScreen(
                    id: ModalRoute.of(context)!.settings.arguments as int,
                  ),
              '/consulta': (context) => ConsultaScreen(
                    id: ModalRoute.of(context)!.settings.arguments as int,
                  ),
            },
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: darkTheme,
          );
        },
      ),
    );
  }
}
