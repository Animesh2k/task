import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme_type.dart';
import 'theme_controller.dart';

class AppColors {
  AppColors._();

  // Common colors (not theme-dependent)
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color accent = Color(0xFF00C6FF); // Cyan-ish for contrast
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;

  // Theme-specific colors
  static Color _getPrimaryColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.current:
        return const Color(0xFF667EEA);
      case AppThemeType.orange:
        return const Color(0xFFFF6B35);
      case AppThemeType.green:
        return const Color(0xFF11998E);
    }
  }

  static Color _getSecondaryColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.current:
        return const Color(0xFF764BA2);
      case AppThemeType.orange:
        return const Color(0xFFF7931E);
      case AppThemeType.green:
        return const Color(0xFF38EF7D);
    }
  }

  /// Get primary color based on current theme.
  static Color get primary {
    try {
      final controller = Get.find<ThemeController>();
      return _getPrimaryColor(controller.currentTheme);
    } catch (e) {
      // Fallback if controller not initialized
      return const Color(0xFF667EEA);
    }
  }

  /// Get secondary color based on current theme.
  static Color get secondary {
    try {
      final controller = Get.find<ThemeController>();
      return _getSecondaryColor(controller.currentTheme);
    } catch (e) {
      // Fallback if controller not initialized
      return const Color(0xFF764BA2);
    }
  }

  // Glassmorphism (not theme-dependent)
  static Color get glassBackground => Colors.white.withValues(alpha: 0.1);
  static Color get glassBorder => Colors.white.withValues(alpha: 0.3);

  /// Get main gradient based on current theme.
  static LinearGradient get mainGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, secondary],
    );
  }
}
