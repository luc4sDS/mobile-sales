import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class VendaSituacaoToggle extends StatelessWidget {
  final String situ;
  final bool estado;
  final void Function() onTap;

  const VendaSituacaoToggle({
    super.key,
    required this.situ,
    required this.estado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              color: estado
                  ? AppColors.primary
                  : AppColors.lightSecondaryBackground),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
            child: Text(
              situ,
              style: TextStyle(
                color: estado ? Colors.white : AppColors.lightPrimaryText,
              ),
            ),
          ),
        ));
  }
}
