import 'package:go_router/go_router.dart';
import 'package:trainalyzefrontend/pages/dahsboard/dashboard.dart';
import 'package:trainalyzefrontend/pages/in_training/in_training.dart';
import 'package:trainalyzefrontend/pages/new_exercise/new_exercise.dart';
import 'package:trainalyzefrontend/pages/new_plan/new_plan.dart';
import 'package:trainalyzefrontend/pages/new_workout/new_workout.dart';
import 'package:trainalyzefrontend/pages/profile/profile.dart';
import 'package:trainalyzefrontend/pages/statistics/statistics.dart';
import 'package:trainalyzefrontend/pages/login/login_page.dart';
import 'package:trainalyzefrontend/pages/login/register_page.dart';
import 'package:trainalyzefrontend/services/auth_service.dart';
import '../layout/layout_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      final isLoggedIn = await AuthService.isLoggedIn();
      final isLoggingIn =
          state.uri.path == '/login' || state.uri.path == '/register';

      // Wenn nicht eingeloggt und versucht auf geschützte Seite zuzugreifen
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // Wenn eingeloggt und versucht auf Login-Seite zuzugreifen
      if (isLoggedIn && isLoggingIn) {
        return '/dashboard';
      }

      return null; // Keine Umleitung nötig
    },
    routes: [
      // Login Routes (ohne Layout)
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => NoTransitionPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: RegisterPage()),
      ),

      // Geschützte Routes mit Layout
      ShellRoute(
        builder: (context, state, child) {
          // LayoutPage ist das Grundgerüst mit Sidebar
          return LayoutPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: Dashboard()),
          ),
          GoRoute(
            path: '/new/exercise',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: NewExercise()),
          ),
          GoRoute(
            path: '/new/workout',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: NewWorkout()),
          ),
          GoRoute(
            path: '/new/plan',
            pageBuilder: (context, state) => NoTransitionPage(child: NewPlan()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => NoTransitionPage(child: Profile()),
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: Statistics()),
          ),
          GoRoute(
            path: '/training',
            pageBuilder: (context, state) => NoTransitionPage(child: InTraining()),
          ),
        ],
      ),
    ],
  );
}
