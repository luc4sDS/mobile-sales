import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

enum MenuOption {
  pdf,
  enviar,
  cancelar,
  email,
  atualizarPrecos,
}

class PedidoOptionsButton extends StatefulWidget {
  final String vndEnviado;
  final Function(MenuOption) onSelect;

  const PedidoOptionsButton({
    super.key,
    required this.vndEnviado,
    required this.onSelect,
  });

  @override
  State<PedidoOptionsButton> createState() => _PedidoOptionsButtonState();
}

class _PedidoOptionsButtonState extends State<PedidoOptionsButton> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: widget.onSelect,
      itemBuilder: (context) => <PopupMenuEntry<MenuOption>>[
        PopupMenuItem(
          enabled: widget.vndEnviado == 'N',
          value: MenuOption.enviar,
          child: const Row(
            spacing: 10,
            children: [
              Icon(Icons.upload, color: AppColors.lightEnviadoText),
              Text('Enviar'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: widget.vndEnviado == 'N',
          value: MenuOption.atualizarPrecos,
          child: const Row(
            spacing: 10,
            children: [
              Icon(Icons.currency_exchange),
              Text('Atualizar Preços'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuOption.email,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.email),
              Text('Enviar Email'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: MenuOption.pdf,
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.description),
              Text('PDF'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: widget.vndEnviado == 'N',
          value: MenuOption.cancelar,
          child: const Row(
            spacing: 10,
            children: [
              Icon(
                Icons.cancel,
                color: AppColors.lightCanceladoText,
              ),
              Text('Cancelar'),
            ],
          ),
        ),
      ],
    );
  }
}
