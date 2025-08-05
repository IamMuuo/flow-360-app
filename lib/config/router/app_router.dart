import 'package:flow_360/config/router/app_navigation_observer.dart';
import 'package:flow_360/config/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GlobalKey<NavigatorState> get globalNavigatorKey =>
      GlobalKey<NavigatorState>();

  static final router = GoRouter(
    routes: $appRoutes,
    observers: [AppNavigationObserver()],
    navigatorKey: globalNavigatorKey,
    initialLocation: AuthRoute().location,
    // redirect: (context, state) async {},
  );
}
