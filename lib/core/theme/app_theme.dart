import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// PRISM's dark, hard-edged Material theme. COPIED from prism_appbloc's
/// app_theme.dart. Zero border radius throughout — do not add a
/// ThemeData-level shape override that introduces rounding.
class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      primaryColor: AppColors.cyan,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.cyan,
        secondary: AppColors.cyan,
        surface: AppColors.bgVoid,
        error: AppColors.error,
      ),
      dividerColor: AppColors.border1,
      textTheme: TextTheme(
        titleLarge: AppTextStyles.pageTitle,
        titleMedium: AppTextStyles.sectionHead,
        bodyMedium: AppTextStyles.bodyM,
        bodySmall: AppTextStyles.bodyS,
        labelSmall: AppTextStyles.dataLabel,
      ),
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
    );
  }
}
