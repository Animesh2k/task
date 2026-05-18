import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_theme_type.dart';
import 'theme_controller.dart';

/// Simplified color palette using white/black backgrounds with blue accent.
/// Flat design - no gradients or glassmorphism.
class AppColors {
  AppColors._();

  // Background colors
  static Color get background => _isDarkMode ? Colors.black : Colors.white;
  static Color get surface =>
      _isDarkMode ? Colors.grey[900]! : Colors.grey[100]!;

  // Primary accent - Blue
  static const Color primary = Colors.blue;
  static Color get primaryLight => Colors.blue[300]!;
  static Color get primaryDark => Colors.blue[700]!;

  // Text colors
  static Color get textPrimary => _isDarkMode ? Colors.white : Colors.black;
  static Color get textSecondary =>
      _isDarkMode ? Colors.white70 : Colors.black54;
  static Color get textDisabled =>
      _isDarkMode ? Colors.white38 : Colors.black38;

  // Utility colors
  static Color get divider => _isDarkMode ? Colors.white24 : Colors.black12;
  static Color get border => _isDarkMode ? Colors.white24 : Colors.black26;
  static Color get error => Colors.red;
  static Color get success => Colors.green;

  /// Check if dark mode is active
  static bool get _isDarkMode {
    try {
      final controller = Get.find<ThemeController>();
      final theme = controller.currentTheme;
      if (theme == AppThemeMode.dark) return true;
      if (theme == AppThemeMode.light) return false;
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.dark;
    } catch (e) {
      return false;
    }
  }

  // For backwards compatibility with old code
  static Color get white => Colors.white;
  static Color get black => Colors.black;
  static Color get transparent => Colors.transparent;
  static Color get accent => primary;
  static Color get textWhite => Colors.white;
  static Color get textWhite70 => Colors.white70;
  static Color get primaryLegacy => primary;
  static Color get secondary => primaryLight;

  // Backwards compatibility - glassmorphism removed, use surface color instead
  static Color get glassBackground => surface;
  static Color get glassBorder => border;

  // Backwards compatibility - gradient removed
  static LinearGradient get mainGradient {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, primaryLight],
    );
  }
}
