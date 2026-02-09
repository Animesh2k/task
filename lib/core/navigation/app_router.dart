import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/onboarding/presentation/pages/otp_verification_page.dart';
import '../../features/onboarding/presentation/pages/profile_creation_page.dart';
import '../../features/onboarding/presentation/pages/permissions_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/analytics_page.dart';
import '../../features/weather/presentation/pages/weather_screen.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/profile/presentation/pages/theme_selection_page.dart';
import '../../features/profile/presentation/pages/language_selection_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../main.dart';
import 'route_constants.dart';
import 'widgets/bottom_navigation_shell.dart';

/// Application router configuration using go_router.
///
/// Features:
/// - Shell routing for auth and onboarding flows
/// - Declarative navigation
/// - Type-safe route parameters
/// - Deep linking support
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.login,
    debugLogDiagnostics: true,

    routes: [
      // Auth Shell Route - Groups all auth-related pages
      ShellRoute(
        builder: (context, state, child) {
          // You can add a common auth shell UI here if needed
          // For now, just return the child
          return child;
        },
        routes: [
          GoRoute(
            path: RouteConstants.login,
            name: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: RouteConstants.signup,
            name: 'signup',
            builder: (context, state) => const SignupPage(),
          ),
          GoRoute(
            path: RouteConstants.forgotPassword,
            name: 'forgot-password',
            builder: (context, state) => const ForgotPasswordPage(),
          ),
          GoRoute(
            path: RouteConstants.resetPassword,
            name: 'reset-password',
            builder: (context, state) => const ResetPasswordPage(),
          ),
        ],
      ),

      // Onboarding Shell Route - Groups all onboarding pages
      ShellRoute(
        builder: (context, state, child) {
          // You can add common onboarding shell UI here
          return child;
        },
        routes: [
          GoRoute(
            path: RouteConstants.otpVerification,
            name: 'otp-verification',
            builder: (context, state) => const OtpVerificationPage(),
          ),
          GoRoute(
            path: RouteConstants.profileCreation,
            name: 'profile-creation',
            builder: (context, state) => const ProfileCreationPage(),
          ),
          GoRoute(
            path: RouteConstants.permissions,
            name: 'permissions',
            builder: (context, state) => const PermissionsPage(),
          ),
        ],
      ),

      // Main App Shell Route with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.home,
                name: 'home',
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: RouteConstants.dashboard,
                    name: 'dashboard',
                    builder: (context, state) => const DashboardPage(),
                  ),
                  GoRoute(
                    path: RouteConstants.analytics,
                    name: 'analytics',
                    builder: (context, state) => const AnalyticsPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.weather,
                name: 'weather',
                builder: (context, state) => WeatherScreen(database: objectBox),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.search,
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteConstants.profile,
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: RouteConstants.editProfile,
                    name: 'edit-profile',
                    builder: (context, state) => const EditProfilePage(),
                  ),
                  GoRoute(
                    path: RouteConstants.settings,
                    name: 'settings',
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: RouteConstants.themeSelection,
                    name: 'theme-selection',
                    builder: (context, state) => const ThemeSelectionPage(),
                  ),
                  GoRoute(
                    path: RouteConstants.languageSelection,
                    name: 'language-selection',
                    builder: (context, state) => const LanguageSelectionPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // Redirect root to login
      GoRoute(
        path: RouteConstants.root,
        redirect: (context, state) => RouteConstants.login,
      ),
    ],
  );
}
