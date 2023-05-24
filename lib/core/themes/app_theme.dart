import 'package:flutter/material.dart';

abstract class AppColors {
  static const primary = Color(0xFF9F39D2);
  static const background = Color(0xFF000000);
}

abstract class AppTheme {
  static get dark {
    return ThemeData.from(
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppColors.primary,
        background: AppColors.background,
      ),
    ).copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
    );
  }
}
