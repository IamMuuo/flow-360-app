import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/employees/presentation/presentation.dart';
import 'package:flow_360/features/features.dart';
import 'package:flow_360/features/fuel/fuel.dart';
import 'package:flow_360/features/shift/shift.dart';
import 'package:flow_360/features/sales/presentation/screens/sales_report_screen.dart';
import 'package:flow_360/features/sales/presentation/screens/create_sale_screen.dart';
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

@TypedGoRoute<SalesReportRoute>(path: "/sales-report")
class SalesReportRoute extends GoRouteData with _$SalesReportRoute {
  const SalesReportRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SalesReportScreen();
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

@TypedGoRoute<EmployeeManagementPageRoute>(
  path: "/employees",
  routes: [
    TypedGoRoute<EmployeeCreatePageRoute>(path: "create"),
    TypedGoRoute<EmployeeDetailsPageRoute>(
      path: ":employeeId",
      routes: [TypedGoRoute<EmployeeEditPageRoute>(path: "edit")],
    ),
  ],
)
class EmployeeManagementPageRoute extends GoRouteData
    with _$EmployeeManagementPageRoute {
  const EmployeeManagementPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmployeeManagementPage();
  }
}

class EmployeeCreatePageRoute extends GoRouteData
    with _$EmployeeCreatePageRoute {
  const EmployeeCreatePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EmployeeCreationPage();
  }
}

class EmployeeDetailsPageRoute extends GoRouteData
    with _$EmployeeDetailsPageRoute {
  const EmployeeDetailsPageRoute({required this.employeeId});
  final String employeeId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmployeeProfilePage(employeeId: employeeId);
  }
}

class EmployeeEditPageRoute extends GoRouteData with _$EmployeeEditPageRoute {
  const EmployeeEditPageRoute({required this.employeeId});
  final String employeeId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return EmployeeEditPage(employeeId: employeeId);
  }
}

@TypedGoRoute<ShiftManagementRoute>(path: "/shift-management")
class ShiftManagementRoute extends GoRouteData with _$ShiftManagementRoute {
  const ShiftManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ShiftManagementScreen();
  }
}

@TypedGoRoute<SupervisorShiftManagementRoute>(path: "/supervisor-shift-management")
class SupervisorShiftManagementRoute extends GoRouteData with _$SupervisorShiftManagementRoute {
  const SupervisorShiftManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SupervisorShiftManagementScreen();
  }
}

@TypedGoRoute<EmployeeDashboardRoute>(path: "/employee-dashboard")
class EmployeeDashboardRoute extends GoRouteData with _$EmployeeDashboardRoute {
  const EmployeeDashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EmployeeDashboard();
  }
}

@TypedGoRoute<CreateSaleRoute>(path: "/create-sale")
class CreateSaleRoute extends GoRouteData with _$CreateSaleRoute {
  const CreateSaleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CreateSaleScreen();
  }
}
