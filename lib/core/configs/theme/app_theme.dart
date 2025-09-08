import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      centerTitle: true,
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
    // iconButtonTheme: IconButtonThemeData(
    //   style: ButtonStyle(iconColor: WidgetStateColor.resolveWith((state) {
    //     return Colors.white;
    //   }), backgroundColor: WidgetStateColor.resolveWith((state) {
    //     if (state.contains(WidgetState.disabled))
    //       return AppColors.lightDisabled;

    //     return AppColors.primary;
    //   })),
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(25, 8, 25, 8),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primary,
        textStyle: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.grey.withValues(alpha: 0.5),
      selectionHandleColor: AppColors.primary,
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.all(5),
      dense: true,
      minTileHeight: 0,
      minLeadingWidth: 0,
      horizontalTitleGap: 0,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      iconColor: AppColors.lighSecondaryText,
      collapsedIconColor: AppColors.lighSecondaryText,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: AppColors.lighSecondaryText.withValues(alpha: 0.4),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: AppColors.lighSecondaryText.withValues(alpha: 0.4),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.lightBackground,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(
          width: 1,
          color: AppColors.lighSecondaryText.withAlpha(160),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      labelStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const TextStyle(color: AppColors.lightPrimaryText);
        }

        return const TextStyle(color: AppColors.lightPrimaryText);
      }),
      hintStyle: WidgetStateTextStyle.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return const TextStyle(color: AppColors.lightPrimaryText);
        }

        return const TextStyle(color: AppColors.lightPrimaryText);
      }),
      fillColor: AppColors.lightSecondaryBackground,
      filled: true,
      floatingLabelStyle: const TextStyle(color: AppColors.lighSecondaryText),
      disabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5),
      ),
      errorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(color: Colors.transparent, width: 1.5),
        // ),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSecondaryBackground,
          // isDense: true,
        ),
        menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.resolveWith(
                (state) => AppColors.lightBackground))),
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
