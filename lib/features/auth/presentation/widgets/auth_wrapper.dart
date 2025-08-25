import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/auth/presentation/screens/login_screen.dart';
import 'package:flow_360/features/dashboard/presentation/screens/dashboard_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    
    return Obx(() {
      final isLoggedIn = authController.isLoggedIn;
      
      if (isLoggedIn) {
        return const DashboardPage();
      } else {
        return const LoginScreen();
      }
    });
  }
}
