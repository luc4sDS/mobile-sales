import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class ValorCard extends StatelessWidget {
  final String label;
  final double valor;

  const ValorCard({
    super.key,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.lighSecondaryText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'R\$ ${valor.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppColors.lightPrimaryText,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
