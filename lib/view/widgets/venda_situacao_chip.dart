import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class VendaSituacaoChip extends StatelessWidget {
  final String situacao;

  const VendaSituacaoChip({super.key, required this.situacao});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: situacao == 'N'
            ? AppColors.lightAbertoBg
            : situacao == 'P'
                ? AppColors.lightEnviadoBg
                : AppColors.lightCanceladoBg,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 1, 4, 1),
        child: Text(
          situacao == 'N'
              ? 'ABERTO'
              : situacao == 'P'
                  ? 'ENVIADO'
                  : 'CANCELADO',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: situacao == 'N'
                  ? AppColors.lightAbertoText
                  : situacao == 'P'
                      ? AppColors.lightEnviadoText
                      : AppColors.lightCanceladoText),
        ),
      ),
    );
  }
}
