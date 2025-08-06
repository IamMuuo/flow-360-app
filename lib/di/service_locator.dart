// lib/di/service_locator.dart
import 'package:flow_360/core/core.dart';
import 'package:flow_360/features/fuel/repository/fuel_price_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/repository/auth_repository.dart';

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
}
