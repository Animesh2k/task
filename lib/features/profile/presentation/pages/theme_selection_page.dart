import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_theme_type.dart';
import '../../../../core/theme/theme_controller.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  IconData _getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  String _getThemeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Always use light theme';
      case AppThemeMode.dark:
        return 'Always use dark theme';
      case AppThemeMode.system:
        return 'Follow system settings';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final surface = isDark ? Colors.grey[900]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Theme',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Choose Theme',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your preferred theme mode',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => _buildThemeOption(
                  context,
                  mode: AppThemeMode.light,
                  isSelected:
                      themeController.currentTheme == AppThemeMode.light,
                  onTap: () => themeController.changeTheme(AppThemeMode.light),
                  isDark: isDark,
                  surface: surface,
                  textColor: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _buildThemeOption(
                  context,
                  mode: AppThemeMode.dark,
                  isSelected: themeController.currentTheme == AppThemeMode.dark,
                  onTap: () => themeController.changeTheme(AppThemeMode.dark),
                  isDark: isDark,
                  surface: surface,
                  textColor: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => _buildThemeOption(
                  context,
                  mode: AppThemeMode.system,
                  isSelected:
                      themeController.currentTheme == AppThemeMode.system,
                  onTap: () => themeController.changeTheme(AppThemeMode.system),
                  isDark: isDark,
                  surface: surface,
                  textColor: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required AppThemeMode mode,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required Color surface,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : (isDark ? Colors.white24 : Colors.black26),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getThemeIcon(mode), color: Colors.blue, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode.displayName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getThemeDescription(mode),
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue, size: 28)
            else
              Icon(
                Icons.circle_outlined,
                color: isDark ? Colors.white54 : Colors.black38,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
