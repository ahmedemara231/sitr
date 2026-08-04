import 'package:flutter/material.dart';

import '../../../../../config/res/config_imports.dart';

class PackageCardTheme {
  static const num _premiumStartingPrice = 200;
  static const num _eliteStartingPrice = 500;

  final Color accent;
  final Color accentDark;
  final IconData icon;

  const PackageCardTheme({
    required this.accent,
    required this.accentDark,
    required this.icon,
  });

  factory PackageCardTheme.fromPrice(num price) {
    if (price < _premiumStartingPrice) {
      return const PackageCardTheme(
        accent: AppColors.main,
        accentDark: AppColors.forth,
        icon: Icons.eco_outlined,
      );
    }
    if (price < _eliteStartingPrice) {
      return const PackageCardTheme(
        accent: AppColors.primary,
        accentDark: AppColors.primaryDark,
        icon: Icons.workspace_premium_outlined,
      );
    }
    return const PackageCardTheme(
      accent: AppColors.forth,
      accentDark: AppColors.infoColor,
      icon: Icons.diamond_outlined,
    );
  }
}
