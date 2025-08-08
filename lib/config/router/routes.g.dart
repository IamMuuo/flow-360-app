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
      $salesReportRoute,
      $fuelDispensersPageRoute,
      $employeeManagementPageRoute,
      $shiftManagementRoute,
      $supervisorShiftManagementRoute,
      $employeeDashboardRoute,
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

RouteBase get $salesReportRoute => GoRouteData.$route(
      path: '/sales-report',
      factory: _$SalesReportRoute._fromState,
    );

mixin _$SalesReportRoute on GoRouteData {
  static SalesReportRoute _fromState(GoRouterState state) =>
      const SalesReportRoute();

  @override
  String get location => GoRouteData.$location(
        '/sales-report',
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

RouteBase get $employeeManagementPageRoute => GoRouteData.$route(
      path: '/employees',
      factory: _$EmployeeManagementPageRoute._fromState,
      routes: [
        GoRouteData.$route(
          path: 'create',
          factory: _$EmployeeCreatePageRoute._fromState,
        ),
        GoRouteData.$route(
          path: ':employeeId',
          factory: _$EmployeeDetailsPageRoute._fromState,
          routes: [
            GoRouteData.$route(
              path: 'edit',
              factory: _$EmployeeEditPageRoute._fromState,
            ),
          ],
        ),
      ],
    );

mixin _$EmployeeManagementPageRoute on GoRouteData {
  static EmployeeManagementPageRoute _fromState(GoRouterState state) =>
      const EmployeeManagementPageRoute();

  @override
  String get location => GoRouteData.$location(
        '/employees',
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

mixin _$EmployeeCreatePageRoute on GoRouteData {
  static EmployeeCreatePageRoute _fromState(GoRouterState state) =>
      const EmployeeCreatePageRoute();

  @override
  String get location => GoRouteData.$location(
        '/employees/create',
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

mixin _$EmployeeDetailsPageRoute on GoRouteData {
  static EmployeeDetailsPageRoute _fromState(GoRouterState state) =>
      EmployeeDetailsPageRoute(
        employeeId: state.pathParameters['employeeId']!,
      );

  EmployeeDetailsPageRoute get _self => this as EmployeeDetailsPageRoute;

  @override
  String get location => GoRouteData.$location(
        '/employees/${Uri.encodeComponent(_self.employeeId)}',
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

mixin _$EmployeeEditPageRoute on GoRouteData {
  static EmployeeEditPageRoute _fromState(GoRouterState state) =>
      EmployeeEditPageRoute(
        employeeId: state.pathParameters['employeeId']!,
      );

  EmployeeEditPageRoute get _self => this as EmployeeEditPageRoute;

  @override
  String get location => GoRouteData.$location(
        '/employees/${Uri.encodeComponent(_self.employeeId)}/edit',
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

RouteBase get $shiftManagementRoute => GoRouteData.$route(
      path: '/shift-management',
      factory: _$ShiftManagementRoute._fromState,
    );

mixin _$ShiftManagementRoute on GoRouteData {
  static ShiftManagementRoute _fromState(GoRouterState state) =>
      const ShiftManagementRoute();

  @override
  String get location => GoRouteData.$location(
        '/shift-management',
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

RouteBase get $supervisorShiftManagementRoute => GoRouteData.$route(
      path: '/supervisor-shift-management',
      factory: _$SupervisorShiftManagementRoute._fromState,
    );

mixin _$SupervisorShiftManagementRoute on GoRouteData {
  static SupervisorShiftManagementRoute _fromState(GoRouterState state) =>
      const SupervisorShiftManagementRoute();

  @override
  String get location => GoRouteData.$location(
        '/supervisor-shift-management',
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

RouteBase get $employeeDashboardRoute => GoRouteData.$route(
      path: '/employee-dashboard',
      factory: _$EmployeeDashboardRoute._fromState,
    );

mixin _$EmployeeDashboardRoute on GoRouteData {
  static EmployeeDashboardRoute _fromState(GoRouterState state) =>
      const EmployeeDashboardRoute();

  @override
  String get location => GoRouteData.$location(
        '/employee-dashboard',
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
