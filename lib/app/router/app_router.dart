import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/repository_providers.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/navigation/screens/navigation_search_screen.dart';
import '../../features/navigation/screens/navigation_progress_screen.dart';
import '../../features/route_comparison/screens/route_comparison_screen.dart';
import '../../features/safety_corridor/screens/safety_corridor_screen.dart';
import '../../features/reports/screens/report_incident_screen.dart';
import '../../features/emergency/screens/emergency_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/route_history/screens/route_history_screen.dart';
import '../../core/models/route_model.dart';
import '../../features/demo/providers/demo_state_provider.dart';

/// NaviHer AI — Application Router
/// Uses GoRouter for declarative URL-based navigation.
final goRouterProvider = Provider<GoRouter>((ref) {
  // ignore authState — auth guards deferred to Phase 2
  ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fade(
          state,
          SplashScreen(
            onComplete: () => context.go('/onboarding'),
          ),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _fade(
          state,
          OnboardingScreen(
            onComplete: () => context.go('/home'),
          ),
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => _fade(
          state,
          HomeScreen(
            navIndex: 0,
            onNavTap: (i) => _handleNav(context, i, 0),
            onSearchTap: () => context.push('/navigate'),
            onReportTap: () => context.push('/report'),
            onEmergencyTap: () => context.push('/emergency'),
            onSafetyTap: () => context.push('/safety-corridor'),
            onShareLocationTap: () => context.push('/emergency'),
            onEmergencyContactsTap: () => context.push('/profile'),
          ),
        ),
      ),
      GoRoute(
        path: '/navigate',
        pageBuilder: (context, state) => _slideUp(
          state,
          NavigationSearchScreen(
            onBack: () => context.pop(),
            onFindRoutes: () => context.push('/route-comparison'),
          ),
        ),
      ),
      GoRoute(
        path: '/route-comparison',
        pageBuilder: (context, state) => _slideUp(
          state,
          RouteComparisonScreen(
            onBack: () => context.pop(),
            onSelectRoute: (route) {
              ref.read(demoStateProvider.notifier).setActiveRoute(route);
              context.push('/navigation-progress', extra: route);
            },
          ),
        ),
      ),
      GoRoute(
        path: '/navigation-progress',
        pageBuilder: (context, state) {
          final routeModel = state.extra as RouteModel?;
          return _fade(
            state,
            NavigationProgressScreen(
              route: routeModel,
              onEndTrip: () {
                ref.read(demoStateProvider.notifier).endNavigation();
                context.go('/home');
              },
            ),
          );
        },
      ),
      GoRoute(
        path: '/safety-corridor',
        pageBuilder: (context, state) => _slideUp(
          state,
          SafetyCorridorScreen(
            onBack: () => context.pop(),
          ),
        ),
      ),
      GoRoute(
        path: '/report',
        pageBuilder: (context, state) => _slideUp(
          state,
          ReportIncidentScreen(
            onBack: () => context.pop(),
            onSubmit: () => context.pop(),
          ),
        ),
      ),
      GoRoute(
        path: '/emergency',
        pageBuilder: (context, state) => _fade(
          state,
          EmergencyScreen(
            onBack: () => context.pop(),
          ),
        ),
      ),
      GoRoute(
        path: '/profile',
        pageBuilder: (context, state) => _fade(
          state,
          ProfileScreen(
            navIndex: 4,
            onNavTap: (i) => _handleNav(context, i, 4),
          ),
        ),
      ),
      GoRoute(
        path: '/route-history',
        pageBuilder: (context, state) => _fade(
          state,
          RouteHistoryScreen(
            onBack: () => context.pop(),
          ),
        ),
      ),
    ],
  );
});

void _handleNav(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;
  switch (index) {
    case 0:
      context.go('/home');
    case 1:
      context.push('/navigate');
    case 2:
      context.push('/safety-corridor');
    case 3:
      context.push('/report');
    case 4:
      context.go('/profile');
  }
}

CustomTransitionPage _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      child: child,
    ),
    transitionDuration: const Duration(milliseconds: 300),
  );
}

CustomTransitionPage _slideUp(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 0.06),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(position: offset, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 350),
  );
}
