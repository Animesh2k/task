import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      size: 60,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    t.auth.login.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.auth.login.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 50),

                  // Glassmorphism Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.glassBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Column(
                      children: [
                        // Email Field
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: t.auth.login.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            hintText: t.auth.login.password,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.go(RouteConstants.forgotPassword),
                            child: Text(
                              t.auth.login.forgotPassword,
                              style: const TextStyle(
                                color: AppColors.textWhite70,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.loginWithEmail(
                                      emailController.text,
                                      passwordController.text,
                                    ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(t.auth.login.loginButton),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Social Auth
                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.glassBorder)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          t.auth.login.orContinue,
                          style: const TextStyle(color: AppColors.textWhite70),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.glassBorder)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _SocialButton(
                        icon: Icons.g_mobiledata, // Placeholder for Google Icon
                        label: t.auth.social.google,
                        onTap: controller.loginWithGoogle,
                      ),
                      _SocialButton(
                        icon: Icons.apple,
                        label: t.auth.social.apple,
                        onTap: controller.loginWithApple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.auth.login.noAccount,
                        style: const TextStyle(color: AppColors.textWhite70),
                      ),
                      GestureDetector(
                        onTap: () => context.go(RouteConstants.signup),
                        child: Text(
                          t.auth.login.signUp,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
