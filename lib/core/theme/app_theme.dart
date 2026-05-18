import 'package:flutter/material.dart';
import 'app_text_styles.dart';

/// Application theme configuration.
/// Flat design with white/black backgrounds and blue accent.
class AppTheme {
  AppTheme._();

  /// Get theme data based on the current theme.
  static ThemeData getTheme({bool isDarkMode = false}) {
    final background = isDarkMode ? Colors.black : Colors.white;
    final surface = isDarkMode ? Colors.grey[900]! : Colors.grey[100]!;
    final textPrimary = isDarkMode ? Colors.white : Colors.black;
    final textSecondary = isDarkMode ? Colors.white70 : Colors.black54;
    final border = isDarkMode ? Colors.white24 : Colors.black26;

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primary: Colors.blue,
        secondary: Colors.blue[300]!,
        surface: surface,
        background: background,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      scaffoldBackgroundColor: background,

      // Text Theme
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: textPrimary),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: textPrimary),
        headlineLarge: AppTextStyles.heading1.copyWith(color: textPrimary),
        headlineMedium: AppTextStyles.heading2.copyWith(color: textPrimary),
        headlineSmall: AppTextStyles.heading3.copyWith(color: textPrimary),
        titleLarge: AppTextStyles.heading4.copyWith(color: textPrimary),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: textPrimary),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: textSecondary),
        labelLarge: AppTextStyles.buttonText.copyWith(color: textPrimary),
        labelSmall: AppTextStyles.caption.copyWith(color: textSecondary),
      ),

      // Input Decoration Theme - Flat design
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(color: textSecondary),
        prefixIconColor: textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.buttonText,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
      ),
    );
  }
}
