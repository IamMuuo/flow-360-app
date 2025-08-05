import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'routes.g.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<AuthRoute>(path: "/auth")
class AuthRoute extends GoRouteData with _$AuthRoute {
  const AuthRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(body: Center(child: Text("Auth")));
  }
}

// // Main pages
// @TypedShellRoute<MainLayoutShellRoute>(
//   routes: <TypedRoute<RouteData>>[TypedGoRoute<AuthRoute>(path: '/')],
// )
// class MainLayoutShellRoute extends ShellRouteData {
//   const MainLayoutShellRoute();
//
//   static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;
//
//   @override
//   Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
//     // In the navigator, we get the current tab widget.
//     return Scaffold();
//   }
// }
