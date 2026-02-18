import 'dart:developer';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/navigation/navigation_helper.dart';
import '../../../../core/utill/toasts.dart';
import '../../data/repositories/auth_repository.dart';
import '../../../../i18n/strings.g.dart';

class AuthController extends GetxController {
  final AuthRepository _repository = AuthRepository();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final credential = await _repository.signInWithGoogle();
      if (credential != null && credential.additionalUserInfo!.isNewUser) {
        // Navigate to Profile Creation if new user
        try {
          NavigationHelper.toProfileCreation(
            name: credential.user?.displayName,
            photoUrl: credential.user?.photoURL,
          );
        } catch (e, stackTrace) {
          log('Navigation error: $e', error: e, stackTrace: stackTrace);
          AppToast.showError(
            t.auth.errors.navigationError,
            description: t.auth.errors.navigationFailed,
          );
        }
      } else if (credential != null) {
        // Navigate Home
        try {
          NavigationHelper.toHome();
        } catch (e, stackTrace) {
          log('Navigation error: $e', error: e, stackTrace: stackTrace);
          AppToast.showError(
            t.auth.errors.navigationError,
            description: t.auth.errors.navigationFailed,
          );
        }
      }
    } catch (e) {
      AppToast.showError(t.auth.errors.error, description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithApple() async {
    try {
      isLoading.value = true;
      final credential = await _repository.signInWithApple();
      if (credential != null && credential.additionalUserInfo!.isNewUser) {
        try {
          NavigationHelper.toProfileCreation(
            name: credential.user?.displayName,
            photoUrl: credential.user?.photoURL,
          );
        } catch (e, stackTrace) {
          log('Navigation error: $e', error: e, stackTrace: stackTrace);
          AppToast.showError(
            t.auth.errors.navigationError,
            description: t.auth.errors.navigationFailed,
          );
        }
      } else if (credential != null) {
        try {
          NavigationHelper.toHome();
        } catch (e, stackTrace) {
          log('Navigation error: $e', error: e, stackTrace: stackTrace);
          AppToast.showError(
            t.auth.errors.navigationError,
            description: t.auth.errors.navigationFailed,
          );
        }
      }
    } catch (e) {
      AppToast.showError(t.auth.errors.error, description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      await _repository.loginWithEmail(email, password);
      log('Login successful');
      // For mock flow, we just assume success and go home
      try {
        NavigationHelper.toHome();
      } catch (e, stackTrace) {
        log('Navigation error: $e', error: e, stackTrace: stackTrace);
        AppToast.showError(
          t.auth.errors.navigationError,
          description: t.auth.errors.navigationFailed,
        );
      }
    } catch (e) {
      log('Error: $e');
      AppToast.showError(t.auth.errors.error, description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      await _repository.signUpWithEmail(email, password);
      // Navigate to OTP
      try {
        NavigationHelper.toOtpVerification(email: email);
      } catch (e, stackTrace) {
        log('Navigation error: $e', error: e, stackTrace: stackTrace);
        AppToast.showError(
          t.auth.errors.navigationError,
          description: t.auth.errors.navigationFailed,
        );
      }
    } catch (e) {
      AppToast.showError(t.auth.errors.error, description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      try {
        NavigationHelper.toLogin();
      } catch (e, stackTrace) {
        log('Navigation error: $e', error: e, stackTrace: stackTrace);
        AppToast.showError(
          t.auth.errors.navigationError,
          description: t.auth.errors.navigationFailed,
        );
      }
    } catch (e) {
      log('Logout error: $e');
      AppToast.showError(t.auth.errors.error, description: e.toString());
    }
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      await Future.delayed(const Duration(seconds: 2)); // Mock API
      AppToast.showSuccess(t.auth.success.passwordUpdated);
      try {
        NavigationHelper.toLogin();
      } catch (e, stackTrace) {
        log('Navigation error: $e', error: e, stackTrace: stackTrace);
        AppToast.showError(
          t.auth.errors.navigationError,
          description: t.auth.errors.navigationFailed,
        );
      }
    } catch (e) {
      AppToast.showError(t.auth.errors.error, description: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
