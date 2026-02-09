import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../i18n/strings.g.dart';
import '../controllers/onboarding_controller.dart';

class ProfileCreationPage extends GetView<OnboardingController> {
  const ProfileCreationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    // If not injected
    final controller = Get.find<OnboardingController>();

    final nameController = TextEditingController(text: controller.name.value);
    final bioController = TextEditingController();

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    t.onboarding.profileCreation.title,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.onboarding.profileCreation.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),

                  // Image Picker
                  GestureDetector(
                    onTap: controller.pickImage,
                    child: Obx(() {
                      final fileImage = controller.profileImage.value;
                      final netImage = controller.profileImageUrl.value;

                      ImageProvider? imageProvider;
                      if (fileImage != null) {
                        imageProvider = FileImage(fileImage);
                      } else if (netImage.isNotEmpty) {
                        imageProvider = NetworkImage(netImage);
                      }

                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.glassBackground,
                          border: Border.all(color: AppColors.white, width: 2),
                          image: imageProvider != null
                              ? DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageProvider == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: AppColors.white,
                                size: 40,
                              )
                            : null,
                      );
                    }),
                  ),

                  const SizedBox(height: 40),

                  // Fields
                  TextField(
                    controller: nameController,
                    onChanged: (v) => controller.name.value = v,
                    style: const TextStyle(color: AppColors.white),
                    decoration: InputDecoration(
                      hintText: t.onboarding.profileCreation.fullName,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: bioController,
                    onChanged: (v) => controller.bio.value = v,
                    style: const TextStyle(color: AppColors.white),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: t.onboarding.profileCreation.bio,
                      prefixIcon: const Icon(Icons.info_outline),
                    ),
                  ),

                  const SizedBox(height: 50),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.saveProfile,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(t.onboarding.profileCreation.kContinue),
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
