import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;

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
          t.settings.title,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
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
                    t.settings.title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.settings.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textWhite70,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Settings Options
                  _buildSettingsOption(
                    context,
                    icon: Icons.palette_outlined,
                    title: t.settings.theme,
                    description: t.settings.themeDescription,
                    onTap: () => context.push(
                      '${RouteConstants.profile}/${RouteConstants.themeSelection}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsOption(
                    context,
                    icon: Icons.language_outlined,
                    title: t.settings.language,
                    description: t.settings.languageDescription,
                    onTap: () => context.push(
                      '${RouteConstants.profile}/${RouteConstants.languageSelection}',
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

  Widget _buildSettingsOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textWhite70,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textWhite70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
