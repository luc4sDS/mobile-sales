import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

enum MenuOption {
  buscarAtualizacoes,
  sincronizar,
  sair,
}

class MainOptionsButton extends StatelessWidget {
  const MainOptionsButton({super.key});

  void handleSelected(MenuOption option, BuildContext context) {
    switch (option) {
      case MenuOption.sincronizar:
        Navigator.pushNamed(context, '/sincronizar');

      case MenuOption.buscarAtualizacoes:
        print(option);

      case MenuOption.sair:
        print(option);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (option) => handleSelected(option, context),
      itemBuilder: (context) => <PopupMenuEntry<MenuOption>>[
        const PopupMenuItem(
          value: MenuOption.buscarAtualizacoes,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.system_update),
              Text('Buscar Atualizações'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuOption.sincronizar,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.sync),
              Text('Sincronizar'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuOption.sair,
          child: Row(
            spacing: 10,
            children: [
              Icon(
                Icons.logout,
                color: AppColors.erro,
              ),
              Text('Sair'),
            ],
          ),
        ),
      ],
    );
  }
}
