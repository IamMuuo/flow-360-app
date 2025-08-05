import 'package:flow_360/core/core.dart';
import 'package:flow_360/di/service_locator.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  await HiveService.init();

  // Inject controller with its dependencies from `sl`
  Get.put(AuthController(authRepository: sl<AuthRepository>()));
  runApp(const Flow360App());
}
