/// Route path constants for the application.
///
/// This provides a centralized place for all route paths,
/// making it easy to maintain and preventing typos.
class RouteConstants {
  RouteConstants._();

  // Root
  static const String root = '/';

  // Auth Routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';

  // Onboarding Routes
  static const String otpVerification = '/otp-verification';
  static const String profileCreation = '/profile-creation';
  static const String permissions = '/permissions';

  // Main Routes
  static const String home = '/home';
  static const String weather = '/weather';
  static const String profile = '/profile';
  static const String search = '/search';

  // Home Nested Routes
  static const String dashboard = 'dashboard';
  static const String analytics = 'analytics';

  // Profile Nested Routes
  static const String editProfile = 'edit';
  static const String settings = 'settings';
  static const String themeSelection = 'theme';
  static const String languageSelection = 'language';
}
