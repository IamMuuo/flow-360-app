// lib/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/repository/auth_repository.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(dioClient: sl()),
  );
}
