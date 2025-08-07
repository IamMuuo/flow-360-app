// lib/di/service_locator.dart
import 'package:flow_360/core/core.dart';
import 'package:flow_360/features/employees/employees.dart';
import 'package:flow_360/features/fuel/repository/fuel_price_repository.dart';
import 'package:flow_360/features/fuel_dispenser/repository/fuel_dispenser_repository.dart';
import 'package:flow_360/features/fuel_dispenser/repository/nozzle_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/repository/auth_repository.dart';
import 'package:flow_360/features/shift/repository/shift_repository.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  sl.registerSingletonAsync<HiveService>(() => HiveService().init());

  await sl.allReady();

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(dioClient: sl(), hiveService: sl()),
  );

  sl.registerLazySingleton<FuelPriceRepository>(
    () => FuelPriceRepository(dioClient: sl(), hiveService: sl()),
  );
  sl.registerLazySingleton<FuelDispenserRepository>(
    () => FuelDispenserRepository(dioClient: sl(), hiveService: sl()),
  );
  sl.registerLazySingleton<NozzleRepository>(
    () => NozzleRepository(
      dioClient: sl<DioClient>(),
      hiveService: sl<HiveService>(),
    ),
  );

  sl.registerLazySingleton<EmployeeRepository>(() => EmployeeRepository());
  
  sl.registerLazySingleton<ShiftRepository>(() => ShiftRepository());
}
