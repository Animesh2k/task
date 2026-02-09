import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_constants.dart';
import 'app_router.dart';

/// Navigation helper for use in controllers and services
/// where BuildContext is not available.
///
/// Usage in controllers:
/// ```dart
/// NavigationHelper.toOtpVerification(email: 'test@example.com');
/// NavigationHelper.toHome();
/// ```
class NavigationHelper {
  NavigationHelper._();

  static GoRouter get _router {
    // Use the static router instance directly
    return AppRouter.router;
  }

  // Auth Routes
  static void toLogin() => _router.go(RouteConstants.login);

  static void toSignup() => _router.go(RouteConstants.signup);

  static void toForgotPassword() => _router.go(RouteConstants.forgotPassword);

  static void toResetPassword() => _router.go(RouteConstants.resetPassword);

  // Onboarding Routes
  static void toOtpVerification({String? email, bool isResetFlow = false}) {
    _router.go(
      RouteConstants.otpVerification,
      extra: {'email': email, 'isResetFlow': isResetFlow},
    );
  }

  static void toProfileCreation({String? name, String? photoUrl}) {
    _router.go(
      RouteConstants.profileCreation,
      extra: {'name': name, 'photoUrl': photoUrl},
    );
  }

  static void toPermissions() => _router.go(RouteConstants.permissions);

  // Main Routes
  static void toHome() => _router.go(RouteConstants.home);

  // Bottom Navigation Tab Routes
  static void toHomeTab() => _router.go(RouteConstants.home);

  static void toWeatherTab() => _router.go(RouteConstants.weather);

  static void toSearchTab() => _router.go(RouteConstants.search);

  static void toProfileTab() => _router.go(RouteConstants.profile);

  // Navigation actions
  static void back() {
    if (_router.canPop()) {
      _router.pop();
    }
  }
}

/// Service to hold the global navigator key
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
