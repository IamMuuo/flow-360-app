import 'package:flow_360/config/router/app_navigation_observer.dart';
import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> globalNavigatorKey =
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    routes: $appRoutes,
    observers: [AppNavigationObserver()],
    navigatorKey: globalNavigatorKey,
    initialLocation: AuthRoute().location,
    redirect: (context, state) async {
      final auth = Get.find<AuthController>();

      // If currentUser is null, check from cache
      if (auth.currentUser.value == null) {
        await auth.isUserLoggedIn();
      }

      final loggedIn = auth.currentUser.value != null;

      final isLoggingIn = state.fullPath == AuthRoute().location;

      if (!loggedIn && !isLoggingIn) {
        return AuthRoute().location; // force login
      }

      if (loggedIn && isLoggingIn) {
        return DashboardRoute().location; // skip login
      }
    },
  );
}
