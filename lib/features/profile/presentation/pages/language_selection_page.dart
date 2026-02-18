import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/language/app_language_type.dart';
import '../../../../core/language/language_controller.dart';
import '../../../../i18n/strings.g.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
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
          t.language.selectTitle,
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
                    t.language.selectTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.language.selectSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textWhite70,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Obx(
                    () => _buildLanguageOption(
                      context,
                      language: AppLanguageType.english,
                      isSelected:
                          languageController.currentLanguage ==
                          AppLanguageType.english,
                      onTap: () => languageController.changeLanguage(
                        AppLanguageType.english,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => _buildLanguageOption(
                      context,
                      language: AppLanguageType.arabic,
                      isSelected:
                          languageController.currentLanguage ==
                          AppLanguageType.arabic,
                      onTap: () => languageController.changeLanguage(
                        AppLanguageType.arabic,
                      ),
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

  Widget _buildLanguageOption(
    BuildContext context, {
    required AppLanguageType language,
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
            // Language flag/icon placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  language == AppLanguageType.english ? 'EN' : 'AR',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Language name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.displayName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    language == AppLanguageType.english
                        ? t.language.englishName
                        : t.language.arabicName,
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
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: AppColors.primary, size: 16),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.textWhite70, width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
