import 'package:charity_app/core/navigation/routes/slider_transition.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:charity_app/core/navigation/routes/app_routes.dart';
import 'package:charity_app/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:charity_app/features/start_screens/presentation/pages/admin_login_screen.dart';
import 'package:charity_app/features/start_screens/presentation/pages/landing_screen.dart';
import 'package:charity_app/features/user/data/models/case_model.dart';
import 'package:charity_app/features/user/presentation/pages/case_details_screen.dart';
import 'package:charity_app/features/admin/presentation/pages/profile_screen.dart';
import 'package:charity_app/features/user/presentation/pages/case_registration_screen.dart';
import '../navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: AppRoutes.landing,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.landing,
        name: 'landing',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const LandingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminLogin,
        name: 'adminLogin',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const AdminLoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.caseRegistration,
        name: 'caseRegistration',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const CaseRegistrationScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.caseDetails,
        name: 'caseDetails',
        pageBuilder: (context, state) {
          final caseEntity = state.extra as CaseModel;
          return AppTransitions.slideFromRight(
            context: context,
            state: state,
            child: CaseDetailsScreen(caseEntity: caseEntity),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => AppTransitions.slideFromRight(
          context: context,
          state: state,
          child: const ProfileScreen(),
        ),
      ),
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(body: Center(child: Text('Error: ${state.error}'))),
    ),
  );

  // Navigation methods
  static void push(BuildContext context, String path) {
    GoRouter.of(context).push(path);
  }

  static void pushReplacement(BuildContext context, String path) {
    GoRouter.of(context).pushReplacement(path);
  }

  static void pop(BuildContext context) {
    GoRouter.of(context).pop();
  }

  // Navigation helper methods
  static void goToSplash() =>
      NavigationService.currentContext?.go(AppRoutes.splash);

  static void goToLogin() =>
      NavigationService.currentContext?.go(AppRoutes.login);
}
