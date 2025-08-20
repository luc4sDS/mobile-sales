import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile_sales/view/pages/clientes_page.dart';
import 'package:mobile_sales/view/pages/pedidos_page.dart';
import 'package:mobile_sales/view/pages/produtos_page.dart';
import 'package:mobile_sales/view/widgets/custom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Páginas mantidas em memória para melhor performance
  final List<Widget> _pages = const [
    PedidosPage(),
    ClientesPage(),
    ProdutosPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Desabilita scroll manual
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
          // _pageController.jumpToPage(index);
          // Ou para animação suave:
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
        tabs: const [
          GButton(
            icon: Icons.assignment,
            text: 'Pedidos',
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          GButton(
            icon: Icons.person,
            text: 'Clientes',
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          GButton(
            icon: Icons.shopping_bag,
            text: 'Produtos',
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ],
      ),
    );
  }
}
