import 'package:flow_360/features/employees/presentation/presentation.dart';
import 'package:flow_360/features/features.dart';
import 'package:flow_360/features/fuel/fuel.dart';
import 'package:flow_360/features/sales/presentation/screens/sales_report_screen.dart';
import 'package:flow_360/features/sales/presentation/screens/create_sale_screen.dart';
import 'package:flow_360/features/sales/presentation/screens/receipt_screen.dart';
import 'package:flow_360/features/tank/presentation/screens/tanks_page.dart';
import 'package:flow_360/features/tank/presentation/screens/station_shifts_page.dart';
import 'package:flow_360/features/tank/presentation/screens/tank_readings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: shellNavigatorKey,
  initialLocation: '/',
  routes: [
    // Auth
    GoRoute(
      path: '/auth',
      builder: (context, state) => LoginScreen(),
    ),
    
    // Main Dashboard
    GoRoute(
      path: '/',
      builder: (context, state) => DashboardPage(),
    ),
    
    // Profile
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfilePage(),
    ),
    
    // Fuel Prices
    GoRoute(
      path: '/fuel',
      builder: (context, state) => FuelPricesPage(),
    ),
    
    // Sales Report
    GoRoute(
      path: '/sales-report',
      builder: (context, state) => SalesReportScreen(),
    ),
    
    // Fuel Dispensers
    GoRoute(
      path: '/fuel-dispenser',
      builder: (context, state) => FuelDispensersPage(),
      routes: [
        GoRoute(
          path: 'create/:stationId',
          builder: (context, state) {
            final stationId = state.pathParameters['stationId']!;
            return CreateFuelDispenserPage(stationId: stationId);
          },
        ),
        GoRoute(
          path: ':dispenserId',
          builder: (context, state) {
            final dispenserId = state.pathParameters['dispenserId']!;
            return DispenserDetailPage(dispenserId: dispenserId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final dispenserId = state.pathParameters['dispenserId']!;
                return EditDispenserPage(dispenserId: dispenserId);
              },
            ),
          ],
        ),
      ],
    ),
    
    // Employee Management
    GoRoute(
      path: '/employees',
      builder: (context, state) => EmployeeManagementPage(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) => EmployeeCreationPage(),
        ),
        GoRoute(
          path: ':employeeId',
          builder: (context, state) {
            final employeeId = state.pathParameters['employeeId']!;
            return EmployeeProfilePage(employeeId: employeeId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) {
                final employeeId = state.pathParameters['employeeId']!;
                return EmployeeEditPage(employeeId: employeeId);
              },
            ),
          ],
        ),
      ],
    ),
    
    // Shift Management
    GoRoute(
      path: '/shifts',
      builder: (context, state) => ShiftManagementScreen(),
    ),
    
    // Supervisor Shift Management
    GoRoute(
      path: '/supervisor-shifts',
      builder: (context, state) => SupervisorShiftManagementScreen(),
    ),
    
    // Employee Dashboard
    GoRoute(
      path: '/employee-dashboard',
      builder: (context, state) => EmployeeDashboard(),
    ),
    
    // Create Sale
    GoRoute(
      path: '/create-sale',
      builder: (context, state) => CreateSaleScreen(),
    ),
    
    // Receipt
    GoRoute(
      path: '/receipt/:saleId',
      builder: (context, state) {
        final saleId = state.pathParameters['saleId']!;
        return ReceiptScreen(saleId: saleId);
      },
    ),
    
    // QR Code Scan
    GoRoute(
      path: '/qr-scan',
      builder: (context, state) {
        // Extract sale ID from query parameters or URL
        final saleId = state.uri.queryParameters['sale_id'] ?? '';
        if (saleId.isNotEmpty) {
          return ReceiptScreen(saleId: saleId);
        }
        // If no sale ID, show error or redirect
        return Scaffold(
          appBar: AppBar(title: const Text('QR Code Scan')),
          body: const Center(
            child: Text('Invalid QR code or missing sale information'),
          ),
        );
      },
    ),
    
    // Tanks
    GoRoute(
      path: '/tanks',
      builder: (context, state) => TanksPage(),
      routes: [
        GoRoute(
          path: ':tankId',
          builder: (context, state) {
            final tankId = state.pathParameters['tankId']!;
            // Get the tank from the controller or pass it via extra
            final tank = state.extra as dynamic;
            return TankDetailsPage(tank: tank);
          },
        ),
      ],
    ),
    
    // Station Shifts
    GoRoute(
      path: '/station-shifts',
      builder: (context, state) => StationShiftsPage(),
      routes: [
        GoRoute(
          path: ':shiftId/readings',
          builder: (context, state) {
            final shiftId = state.pathParameters['shiftId']!;
            final shift = state.extra as dynamic;
            return ShiftReadingsScreen();
          },
        ),
      ],
    ),
    
    // Tank Readings
    GoRoute(
      path: '/tank-readings/:shiftId',
      builder: (context, state) {
        final shiftId = state.pathParameters['shiftId']!;
        final shift = state.extra as dynamic;
        return TankReadingsPage(shift: shift);
      },
    ),
  ],
);
