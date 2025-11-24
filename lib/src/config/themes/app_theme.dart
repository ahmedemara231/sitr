import 'package:flutter/material.dart';
import '../../core/extensions/material_color_extension.dart';
import '../res/config_imports.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      primarySwatch: AppColors.primary.toMaterialColor(),
      primaryColor: AppColors.primary,
      useMaterial3: true,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      fontFamily: ConstantManager.fontFamily,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pW4),
          foregroundColor: AppColors.primary,
          minimumSize: Size(AppSize.sW30, AppSize.sH30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.sH0),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(
        surfaceTintColor: Colors.transparent,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primary.withValues(alpha: 0.2),
        selectionHandleColor: AppColors.primary,
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: AppColors.white,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: AppColors.border,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      primarySwatch: AppColorsWithDarkMode.primary.toMaterialColor(),
      primaryColor: AppColorsWithDarkMode.primary,
      useMaterial3: true,
      scaffoldBackgroundColor: AppColorsWithDarkMode.border,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColorsWithDarkMode.white,
        selectedItemColor: AppColorsWithDarkMode.primary,
        unselectedItemColor: AppColorsWithDarkMode.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.pW4),
          foregroundColor: AppColorsWithDarkMode.primary,
          minimumSize: Size(AppSize.sW30, AppSize.sH30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSize.sH0,
            ),
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: AppColorsWithDarkMode.white,
      ),
      iconTheme: const IconThemeData(
        color: AppColorsWithDarkMode.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        prefixIconColor: AppColorsWithDarkMode.border,
      ),
    );
  }
}
