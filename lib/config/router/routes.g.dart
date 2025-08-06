// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $authRoute,
      $mainLayoutShellRoute,
      $fuelPricesRoute,
    ];

RouteBase get $authRoute => GoRouteData.$route(
      path: '/auth',
      factory: _$AuthRoute._fromState,
    );

mixin _$AuthRoute on GoRouteData {
  static AuthRoute _fromState(GoRouterState state) => const AuthRoute();

  @override
  String get location => GoRouteData.$location(
        '/auth',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainLayoutShellRoute => ShellRouteData.$route(
      navigatorKey: MainLayoutShellRoute.$navigatorKey,
      factory: $MainLayoutShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/dashboard',
          factory: _$DashboardRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/stations',
          factory: _$StationsRoute._fromState,
        ),
        GoRouteData.$route(
          path: '/profile',
          factory: _$ProfileRoute._fromState,
        ),
      ],
    );

extension $MainLayoutShellRouteExtension on MainLayoutShellRoute {
  static MainLayoutShellRoute _fromState(GoRouterState state) =>
      const MainLayoutShellRoute();
}

mixin _$DashboardRoute on GoRouteData {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  @override
  String get location => GoRouteData.$location(
        '/dashboard',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$StationsRoute on GoRouteData {
  static StationsRoute _fromState(GoRouterState state) => const StationsRoute();

  @override
  String get location => GoRouteData.$location(
        '/stations',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location(
        '/profile',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $fuelPricesRoute => GoRouteData.$route(
      path: '/fuel',
      factory: _$FuelPricesRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: '/add',
          factory: _$CreateFuelRoute._fromState,
        ),
      ],
    );

mixin _$FuelPricesRoute on GoRouteData {
  static FuelPricesRoute _fromState(GoRouterState state) =>
      const FuelPricesRoute();

  @override
  String get location => GoRouteData.$location(
        '/fuel',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin _$CreateFuelRoute on GoRouteData {
  static CreateFuelRoute _fromState(GoRouterState state) =>
      const CreateFuelRoute();

  @override
  String get location => GoRouteData.$location(
        '/add',
      );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
