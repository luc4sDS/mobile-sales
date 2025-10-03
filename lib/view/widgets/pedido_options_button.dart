import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

enum PedidoMenuOption {
  pdf,
  enviar,
  cancelar,
  email,
  atualizarPrecos,
}

class PedidoOptionsButton extends StatefulWidget {
  final String vndEnviado;
  final Function(PedidoMenuOption) onSelect;

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
      itemBuilder: (context) => <PopupMenuEntry<PedidoMenuOption>>[
        PopupMenuItem(
          enabled: widget.vndEnviado == 'N',
          value: PedidoMenuOption.enviar,
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
          value: PedidoMenuOption.atualizarPrecos,
          child: const Row(
            spacing: 10,
            children: [
              Icon(Icons.currency_exchange),
              Text('Atualizar Preços'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: widget.vndEnviado != 'C',
          value: PedidoMenuOption.email,
          child: const Row(
            spacing: 10,
            children: [
              Icon(Icons.email),
              Text('Enviar Email'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: widget.vndEnviado != 'C',
          value: PedidoMenuOption.pdf,
          child: const Row(
            spacing: 10,
            children: [
              Icon(Icons.description),
              Text('PDF'),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: widget.vndEnviado == 'N',
          value: PedidoMenuOption.cancelar,
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
