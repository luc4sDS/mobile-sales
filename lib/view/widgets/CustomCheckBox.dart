import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class CustomCheckBox extends StatelessWidget {
  final Function()? onTap;
  final String? label;
  final bool? enabled;
  final bool value;
  final void Function(bool?) onChanged;

  const CustomCheckBox({
    super.key,
    this.onTap,
    this.label,
    this.enabled,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final aEnabled = this.enabled ?? true;

    return GestureDetector(
      onTap: aEnabled ? onTap : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
            onChanged: aEnabled ? onChanged : null,
            fillColor: WidgetStateProperty.resolveWith(
              (states) {
                if (!states.contains(WidgetState.selected)) {
                  return null;
                } else {
                  return !aEnabled ? AppColors.darkDisabled : AppColors.primary;
                }
              },
            ),
            value: value,
          ),
          Text(
            style: TextStyle(
                color: !aEnabled
                    ? AppColors.lightDisabledText
                    : AppColors.lightPrimaryText),
            label ?? '',
          ),
        ],
      ),
    );
  }
}
