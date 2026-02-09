import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/route_constants.dart';
import '../../../../i18n/strings.g.dart';
import '../controllers/onboarding_controller.dart';

class PermissionsPage extends GetView<OnboardingController> {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final controller = Get.find<OnboardingController>();

    return Scaffold(
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

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    t.onboarding.permissions.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.onboarding.permissions.subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),

                  _PermissionItem(
                    icon: Icons.camera_alt,
                    title: t.onboarding.permissions.camera,
                    description: t.onboarding.permissions.cameraDescription,
                  ),
                  const SizedBox(height: 20),
                  _PermissionItem(
                    icon: Icons.photo_library,
                    title: t.onboarding.permissions.gallery,
                    description: t.onboarding.permissions.galleryDescription,
                  ),
                  const SizedBox(height: 20),
                  _PermissionItem(
                    icon: Icons.location_on,
                    title: t.onboarding.permissions.location,
                    description: t.onboarding.permissions.locationDescription,
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.requestPermissions,
                      child: Text(t.onboarding.permissions.grant),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => context.go(RouteConstants.home),
                    child: Text(
                      t.onboarding.permissions.skip,
                      style: TextStyle(color: AppColors.textWhite70),
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
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: AppColors.textWhite70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
