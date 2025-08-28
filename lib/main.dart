import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_theme.dart';
import 'package:mobile_sales/view/pages/cadastro_usuario_page.dart';
import 'package:mobile_sales/view/pages/main_page.dart';
import 'package:mobile_sales/view/pages/novo_pedido_page.dart';
import 'package:mobile_sales/view/pages/login_page.dart';
import 'package:mobile_sales/view/pages/primeiro_acesso_page.dart';
import 'package:mobile_sales/view/pages/sincronizar_page.dart';
import 'package:mobile_sales/view/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/primeiro_acesso': (context) => const PrimeiroAcessoPage(),
        '/cadastro_usuario': (context) => const CadastroUsuarioPage(),
        '/sincronizar': (context) => const SincronizarPage(),
        '/main': (context) => const MainPage(),
        '/novo_pedido': (context) => const NovoPedidoPage(),
      },
    );
  }
}
