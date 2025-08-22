import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    fontFamily: 'Poppins',
    cardTheme: const CardTheme(
      color: AppColors.lightSecondaryBackground,
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
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
      selectionColor: AppColors.grey.withValues(alpha: 0.5),
      selectionHandleColor: AppColors.primary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      isDense: true,
      fillColor: AppColors.lightSecondaryBackground,
      filled: true,
      floatingLabelStyle: TextStyle(color: AppColors.lighSecondaryText),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Colors.transparent)),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5),
        // ),
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
      checkColor: WidgetStateProperty.resolveWith(
        (states) {
          if (!states.contains(WidgetState.selected)) {
            return null;
          } else {
            return Colors.white;
          }
        },
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      // circularTrackColor: AppColors.darkSecondaryBackground,
      color: AppColors.primary,
      circularTrackColor: AppColors.lightSecondaryBackground,
    ),
  );

  static final darkTheme = ThemeData(
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
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
      selectionColor: AppColors.grey.withValues(alpha: 0.5),
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
        color: AppColors.darkHighlight,
        circularTrackColor: AppColors.darkSecondaryBackground),
  );
}
