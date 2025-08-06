import 'package:flow_360/features/features.dart';
import 'package:flow_360/features/fuel/fuel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
part 'routes.g.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

@TypedGoRoute<AuthRoute>(path: "/auth")
class AuthRoute extends GoRouteData with _$AuthRoute {
  const AuthRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return LoginScreen();
  }
}

// Main pages
// @TypedShellRoute<MainLayoutShellRoute>(
//   routes: <TypedRoute<RouteData>>[
//     TypedGoRoute<DashboardRoute>(path: "/dashboard"),
//     TypedGoRoute<StationsRoute>(path: "/stations"),
//     TypedGoRoute<ProfileRoute>(path: "/profile"),
//   ],
// )
// class MainLayoutShellRoute extends ShellRouteData {
//   const MainLayoutShellRoute();
//
//   static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;
//
//   @override
//   Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
//     // In the navigator, we get the current tab widget.
//     return DashboardShell(navigator: navigator);
//   }
// }

@TypedGoRoute<DashboardRoute>(path: "/")
class DashboardRoute extends GoRouteData with _$DashboardRoute {
  const DashboardRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DashboardPage();
  }
}

// class StationsRoute extends GoRouteData with _$StationsRoute {
//   const StationsRoute();
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return StationsPage();
//   }
// }

@TypedGoRoute<ProfileRoute>(path: "/profile")
class ProfileRoute extends GoRouteData with _$ProfileRoute {
  const ProfileRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage();
  }
}

@TypedGoRoute<FuelPricesRoute>(path: "/fuel")
class FuelPricesRoute extends GoRouteData with _$FuelPricesRoute {
  const FuelPricesRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FuelPricesPage();
  }
}

@TypedGoRoute<FuelDispensersPageRoute>(
  path: "/fuel-dispenser",
  routes: [
    TypedGoRoute<CreateFuelDispenserRoute>(path: "create/:stationId"),
    TypedGoRoute<DispenserDetailsRoute>(
      path: ":dispenserId",
      routes: [TypedGoRoute<EditDispenserRoute>(path: "edit")],
    ),
  ],
)
class FuelDispensersPageRoute extends GoRouteData
    with _$FuelDispensersPageRoute {
  const FuelDispensersPageRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FuelDispensersPage();
  }
}

class CreateFuelDispenserRoute extends GoRouteData
    with _$CreateFuelDispenserRoute {
  final String stationId;
  const CreateFuelDispenserRoute({required this.stationId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CreateFuelDispenserPage(stationId: stationId);
  }
}

class DispenserDetailsRoute extends GoRouteData with _$DispenserDetailsRoute {
  final String dispenserId;
  const DispenserDetailsRoute({required this.dispenserId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DispenserDetailPage(dispenserId: dispenserId);
  }
}

class EditDispenserRoute extends GoRouteData with _$EditDispenserRoute {
  final String dispenserId;
  const EditDispenserRoute({required this.dispenserId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EditDispenserPage(dispenserId: dispenserId);
  }
}
