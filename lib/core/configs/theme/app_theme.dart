import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    appBarTheme:
        AppBarTheme(backgroundColor: AppColors.lightSecondaryBackground),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lighSecondaryText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.grey.withOpacity(0.5),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: AppColors.lightInputBg,
      filled: true,
      floatingLabelStyle: TextStyle(color: AppColors.primary),
      enabledBorder: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
        borderSide: BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(3),
        ),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (!states.contains(WidgetState.selected)) {
          return null;
        } else {
          return AppColors.primary;
        }
      }),
    ),
  );

  static final darkTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    fontFamily: 'Poppins',
    cardTheme: const CardTheme(
      color: AppColors.darkSecondaryBackground,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkSecondaryText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionHandleColor: Colors.white,
      selectionColor: AppColors.grey.withOpacity(0.5),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      fillColor: AppColors.darkInputBg,
      filled: true,
      floatingLabelStyle: TextStyle(color: Colors.white),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: AppColors.darkBorderBg)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        borderSide: BorderSide(color: Colors.red, width: 1.5),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (!states.contains(WidgetState.selected)) {
            return null;
          } else {
            return AppColors.primary;
          }
        },
      ),
      checkColor: WidgetStateProperty.resolveWith(
        (states) {
          if (!states.contains(WidgetState.selected)) {
            return null;
          } else {
            return AppColors.darkPrimaryText;
          }
        },
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        // circularTrackColor: AppColors.darkSecondaryBackground,
        color: AppColors.highlight,
        circularTrackColor: AppColors.darkSecondaryBackground),
  );
}
