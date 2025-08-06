// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $authRoute,
      $dashboardRoute,
      $profileRoute,
      $fuelPricesRoute,
      $fuelDispensersPageRoute,
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

RouteBase get $dashboardRoute => GoRouteData.$route(
      path: '/',
      factory: _$DashboardRoute._fromState,
    );

mixin _$DashboardRoute on GoRouteData {
  static DashboardRoute _fromState(GoRouterState state) =>
      const DashboardRoute();

  @override
  String get location => GoRouteData.$location(
        '/',
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

RouteBase get $profileRoute => GoRouteData.$route(
      path: '/profile',
      factory: _$ProfileRoute._fromState,
    );

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

RouteBase get $fuelDispensersPageRoute => GoRouteData.$route(
      path: '/fuel-dispenser',
      factory: _$FuelDispensersPageRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'create/:stationId',
          factory: _$CreateFuelDispenserRoute._fromState,
        ),
        GoRouteData.$route(
          path: ':dispenserId',
          factory: _$DispenserDetailsRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'edit',
              factory: _$EditDispenserRoute._fromState,
            ),
          ],
        ),
      ],
    );

mixin _$FuelDispensersPageRoute on GoRouteData {
  static FuelDispensersPageRoute _fromState(GoRouterState state) =>
      const FuelDispensersPageRoute();

  @override
  String get location => GoRouteData.$location(
        '/fuel-dispenser',
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

mixin _$CreateFuelDispenserRoute on GoRouteData {
  static CreateFuelDispenserRoute _fromState(GoRouterState state) =>
      CreateFuelDispenserRoute(
        stationId: state.pathParameters['stationId']!,
      );

  CreateFuelDispenserRoute get _self => this as CreateFuelDispenserRoute;

  @override
  String get location => GoRouteData.$location(
        '/fuel-dispenser/create/${Uri.encodeComponent(_self.stationId)}',
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

mixin _$DispenserDetailsRoute on GoRouteData {
  static DispenserDetailsRoute _fromState(GoRouterState state) =>
      DispenserDetailsRoute(
        dispenserId: state.pathParameters['dispenserId']!,
      );

  DispenserDetailsRoute get _self => this as DispenserDetailsRoute;

  @override
  String get location => GoRouteData.$location(
        '/fuel-dispenser/${Uri.encodeComponent(_self.dispenserId)}',
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

mixin _$EditDispenserRoute on GoRouteData {
  static EditDispenserRoute _fromState(GoRouterState state) =>
      EditDispenserRoute(
        dispenserId: state.pathParameters['dispenserId']!,
      );

  EditDispenserRoute get _self => this as EditDispenserRoute;

  @override
  String get location => GoRouteData.$location(
        '/fuel-dispenser/${Uri.encodeComponent(_self.dispenserId)}/edit',
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
