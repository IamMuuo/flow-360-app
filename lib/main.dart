import 'package:flow_360/di/service_locator.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/auth/repository/auth_repository.dart';
import 'package:flow_360/features/features.dart';
import 'package:flow_360/features/fuel/controllers/fuel_price_controller.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/features/fuel_dispenser/controller/nozzle_controller.dart';
import 'package:flow_360/features/sales/controllers/sales_controller.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';
import 'package:flow_360/features/shift/controllers/supervisor_shift_controller.dart';
import 'package:flow_360/features/shift/controllers/shift_readings_controller.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/controllers/station_shift_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  // Inject controller with its dependencies from `sl`
  Get.put(AuthController(authRepository: sl<AuthRepository>()));
  Get.put(FuelPriceController());
  Get.put(FuelDispenserController());
  Get.put(NozzleController());
  Get.put(SalesController());
  Get.put(ShiftController());
  Get.put(SupervisorShiftController());
  Get.put(ShiftReadingsController());
  Get.put(TankController());
  Get.put(StationShiftController());

  runApp(const Flow360App());
}
