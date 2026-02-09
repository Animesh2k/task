import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../controllers/onboarding_controller.dart';

class OtpVerificationPage extends GetView<OnboardingController> {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    // Initialize controller if not already given (depends on binding)
    final controller = Get.put(OnboardingController());
    // Retrieve arguments from go_router state
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
    final email = extra?['email'] ?? t.onboarding.otp.fallbackEmail;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.white,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(12),
      ),
    );

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text(
                    t.onboarding.otp.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.onboarding.otp.subtitle.replaceAll('{{email}}', email),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 50),

                  // Pinput
                  Pinput(
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: AppColors.white),
                      color: AppColors.white.withValues(alpha: 0.15),
                    ),
                    onCompleted: (pin) => controller.verifyOtp(pin),
                  ),

                  const Spacer(),

                  // Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                // Pinput calls onCompleted, but button can also trigger if pin is full?
                                // For now, let's just rely on Pinput or let user click if they want
                              },
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(t.onboarding.otp.verify),
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
}
