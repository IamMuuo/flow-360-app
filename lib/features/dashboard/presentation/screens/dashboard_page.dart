import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/features.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value?.user;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("No user logged in.")));
    }

    Widget dashboard;

    switch (user.role.toLowerCase()) {
      case 'manager':
        dashboard = const ManagerDashboard();
        break;
      case 'supervisor':
        dashboard = const SupervisorDashboard();
        break;
      case 'employee':
        dashboard = const EmployeeDashboard();
        break;
      default:
        dashboard = const Center(child: Text("Unknown role."));
    }

    return Scaffold(body: dashboard);
  }
}
