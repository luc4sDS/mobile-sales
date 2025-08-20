import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';
import 'package:mobile_sales/core/configs/theme/app_theme.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final List<GButton> tabs;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // color: isDark
        //     ? AppColors.darkSecondaryBackground
        // : AppColors.lightSecondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            textStyle: TextStyle(fontWeight: FontWeight.w500),
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: isDark ? Colors.white : AppColors.primary,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: isDark
                ? AppColors.darkSecondaryBackground
                : AppColors.lightSecondaryBackground,
            color: isDark
                ? AppColors.darkSecondaryText
                : AppColors.lighSecondaryText,
            tabs: tabs,
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
