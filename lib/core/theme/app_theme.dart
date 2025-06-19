import 'package:flutter/material.dart';
import 'package:health_fixed/core/theme/app_colors.dart';

final ThemeData lightMaterialTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.medicationCard,
    background: AppColors.background,
    surface: Colors.white,
    error: AppColors.danger,
    onPrimary: Colors.white,
    onSecondary: AppColors.dark,
    onBackground: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColors.background,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.bottomNavBackground,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.textSecondary,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.textPrimary),
    bodyMedium: TextStyle(fontSize: 14, color: AppColors.textSecondary),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 2,
  ),
  useMaterial3: true,
);
