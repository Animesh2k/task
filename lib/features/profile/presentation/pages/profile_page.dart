import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final authController = Get.find<AuthController>();

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
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Header
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.glassBorder,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    t.profile.title,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Profile Options
                  _buildProfileOption(
                    context,
                    icon: Icons.person_outline,
                    title: t.profile.editProfile,
                    onTap: () => context.push(
                      '${RouteConstants.profile}/${RouteConstants.editProfile}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileOption(
                    context,
                    icon: Icons.settings_outlined,
                    title: t.profile.settings,
                    onTap: () => context.push(
                      '${RouteConstants.profile}/${RouteConstants.settings}',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileOption(
                    context,
                    icon: Icons.notifications_outlined,
                    title: t.profile.notifications,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildProfileOption(
                    context,
                    icon: Icons.help_outline,
                    title: t.profile.helpSupport,
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.2),
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.red.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      child: Text(t.profile.logout),
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

  Widget _buildProfileOption(
    BuildContext context, {
    required IconData icon,
    required String title,
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
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.white),
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
