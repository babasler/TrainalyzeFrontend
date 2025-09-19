import 'package:go_router/go_router.dart';
import 'package:trainalyzefrontend/pages/dahsboard/dashboard.dart';
import 'package:trainalyzefrontend/pages/new_exercise/new_exercise.dart';
import 'package:trainalyzefrontend/pages/new_plan/new_plan.dart';
import 'package:trainalyzefrontend/pages/new_workout/new_workout.dart';
import 'package:trainalyzefrontend/pages/profile/profile.dart';
import 'package:trainalyzefrontend/pages/statistics/statistics.dart';
import '../layout/layout_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          // LayoutPage ist das Grundgerüst mit Sidebar
          return LayoutPage(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            pageBuilder: (context, state) => NoTransitionPage(child: Dashboard()),
          ),
          GoRoute(
            path: '/new/exercise',
            pageBuilder: (context, state) => NoTransitionPage(child: NewExercise()),
          ),
          GoRoute(
            path: '/new/workout',
            pageBuilder: (context, state) => NoTransitionPage(child: NewWorkout()),
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
            pageBuilder: (context, state) => NoTransitionPage(child: Statistics()),
          ),
        ],
      ),
    ],
  );
}
