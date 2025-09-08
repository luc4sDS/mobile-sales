import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final Widget? content;
  const CustomExpansionTile({super.key, this.content});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: AppColors.lighSecondaryText.withValues(alpha: 0.4),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: AppColors.lighSecondaryText.withValues(alpha: 0.4),
        ),
      ),
      title: const Text(
        'Contatos',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [content ?? const SizedBox.shrink()],
    );
  }
}
