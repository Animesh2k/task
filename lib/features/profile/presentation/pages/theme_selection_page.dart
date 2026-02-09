import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme_type.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../i18n/strings.g.dart';

class ThemeSelectionPage extends StatelessWidget {
  const ThemeSelectionPage({super.key});

  Color _getPrimaryColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.current:
        return const Color(0xFF667EEA);
      case AppThemeType.orange:
        return const Color(0xFFFF6B35);
      case AppThemeType.green:
        return const Color(0xFF11998E);
    }
  }

  Color _getSecondaryColor(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.current:
        return const Color(0xFF764BA2);
      case AppThemeType.orange:
        return const Color(0xFFF7931E);
      case AppThemeType.green:
        return const Color(0xFF38EF7D);
    }
  }

  LinearGradient _getThemeGradient(AppThemeType theme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [_getPrimaryColor(theme), _getSecondaryColor(theme)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t.theme.selectTitle,
          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Obx(
              () => Container(
                decoration: BoxDecoration(gradient: AppColors.mainGradient),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    t.theme.chooseTheme,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.theme.selectSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textWhite70,
                        ),
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => _buildThemeOption(
                      context,
                      theme: AppThemeType.current,
                      isSelected: themeController.currentTheme == AppThemeType.current,
                      onTap: () => themeController.changeTheme(AppThemeType.current),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => _buildThemeOption(
                      context,
                      theme: AppThemeType.orange,
                      isSelected: themeController.currentTheme == AppThemeType.orange,
                      onTap: () => themeController.changeTheme(AppThemeType.orange),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => _buildThemeOption(
                      context,
                      theme: AppThemeType.green,
                      isSelected: themeController.currentTheme == AppThemeType.green,
                      onTap: () => themeController.changeTheme(AppThemeType.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required AppThemeType theme,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.white : AppColors.glassBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Preview gradient box
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: _getThemeGradient(theme),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Theme name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    theme.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${_getPrimaryColor(theme).toARGB32().toRadixString(16).substring(2).toUpperCase()} → #${_getSecondaryColor(theme).toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textWhite70,
                        ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: _getPrimaryColor(theme),
                  size: 16,
                ),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.textWhite70,
                    width: 2,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
