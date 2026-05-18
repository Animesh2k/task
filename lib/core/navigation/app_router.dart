import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/tasks/presentation/pages/task_list_page.dart';
import '../../features/tasks/presentation/pages/task_create_page.dart';
import '../../features/tasks/presentation/pages/task_edit_page.dart';
import '../../features/tasks/presentation/bloc/task_bloc.dart';
import '../../features/tasks/presentation/bloc/task_event.dart';
import '../../features/tasks/data/repositories/task_repository.dart';
import '../../features/tasks/services/sync_service.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/theme_selection_page.dart';
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
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isLoginRoute = state.matchedLocation == RouteConstants.login;

      // Not logged in and trying to access protected route -> go to login
      if (user == null && !isLoginRoute) {
        return RouteConstants.login;
      }

      // Logged in and on login route -> go to tasks
      if (user != null && isLoginRoute) {
        return RouteConstants.tasks;
      }

      return null; // No redirect
    },

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
                path: RouteConstants.tasks,
                name: 'tasks',
                builder: (context, state) => const TaskListPage(),
                routes: [
                  GoRoute(
                    path: 'create',
                    name: 'task-create',
                    builder: (context, state) {
                      final userId =
                          Get.find<AuthController>().firebaseUser.value?.uid ??
                          '';
                      return BlocProvider(
                        create: (context) => TaskBloc(
                          taskRepository: TaskRepository(database: objectBox),
                          syncService: SyncService(
                            taskRepository: TaskRepository(database: objectBox),
                          ),
                        )..add(LoadTasksEvent(userId: userId)),
                        child: const TaskCreatePage(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'edit/:taskId',
                    name: 'task-edit',
                    builder: (context, state) {
                      final taskId = state.pathParameters['taskId']!;
                      final userId =
                          Get.find<AuthController>().firebaseUser.value?.uid ??
                          '';
                      return BlocProvider(
                        create: (context) => TaskBloc(
                          taskRepository: TaskRepository(database: objectBox),
                          syncService: SyncService(
                            taskRepository: TaskRepository(database: objectBox),
                          ),
                        )..add(LoadTasksEvent(userId: userId)),
                        child: TaskEditPage(taskId: taskId),
                      );
                    },
                  ),
                ],
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
                    path: RouteConstants.themeSelection,
                    name: 'theme-selection',
                    builder: (context, state) => const ThemeSelectionPage(),
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
