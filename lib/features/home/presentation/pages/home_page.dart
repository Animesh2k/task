import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Welcome Section
                  Text(
                    t.home.welcome,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.home.dashboardOverview,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textWhite70,
                        ),
                  ),
                  const SizedBox(height: 40),
                  // Dashboard Cards
                  _buildDashboardCard(
                    context,
                    icon: Icons.dashboard_outlined,
                    title: t.home.dashboard,
                    description: t.home.dashboardDescription,
                    onTap: () => context.push('${RouteConstants.home}/${RouteConstants.dashboard}'),
                  ),
                  const SizedBox(height: 20),
                  _buildDashboardCard(
                    context,
                    icon: Icons.trending_up_outlined,
                    title: t.home.analytics,
                    description: t.home.analyticsDescription,
                    onTap: () => context.push('${RouteConstants.home}/${RouteConstants.analytics}'),
                  ),
                  const SizedBox(height: 20),
                  _buildDashboardCard(
                    context,
                    icon: Icons.notifications_outlined,
                    title: t.home.notifications,
                    description: t.home.notificationsDescription,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
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
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
