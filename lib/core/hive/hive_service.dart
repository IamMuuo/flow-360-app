import 'package:flow_360/features/features.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/auth/models/auth_model.dart';
import 'package:flow_360/features/fuel/models/fuel_price_model.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';
import 'package:flow_360/features/shift/models/station_shift_model.dart';

class HiveService {
  static const String _cacheBoxName = 'app_cache';
  static const String _authBoxName = 'authBox';
  static const String _metaBoxName = 'metaBox';

  Future<HiveService> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register all adapters
    Hive.registerAdapter(AuthModelAdapter());
    Hive.registerAdapter(FuelPriceModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(FuelDispenserModelAdapter());
    Hive.registerAdapter(NozzleModelAdapter());
    Hive.registerAdapter(TankModelAdapter());
    Hive.registerAdapter(TankAuditModelAdapter());
    Hive.registerAdapter(StationShiftModelAdapter());
    Hive.registerAdapter(TankReadingModelAdapter());
    Hive.registerAdapter(NozzleReadingModelAdapter());
    Hive.registerAdapter(ShiftNozzleModelAdapter());

    // Open the generic cache box once as Box<dynamic>
    await Hive.openBox<dynamic>(_cacheBoxName);

    // Open other specific boxes
    await openBox<AuthModel>(_authBoxName);
    await openBox<String>(_metaBoxName);

    return this;
  }

  // Dedicated methods for the generic 'app_cache' box
  Future<void> putCache<T>(String key, T value) async {
    final box = Hive.box<dynamic>(_cacheBoxName);
    await box.put(key, value);
  }

  T? getCache<T>(String key) {
    final box = Hive.box<dynamic>(_cacheBoxName);
    return box.get(key) as T?;
  }

  // General-purpose methods for other, type-specific boxes
  Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = getBox<T>(boxName);
    await box.put(key, value);
  }

  T? get<T>(String boxName, dynamic key) {
    // Check if the box is open before getting it
    if (!Hive.isBoxOpen(boxName)) {
      return null;
    }
    final box = getBox<T>(boxName);
    return box.get(key);
  }

  Future<void> delete<T>(String boxName, dynamic key) async {
    final box = getBox<T>(boxName);
    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);
    await box.clear();
  }

  // Helper methods
  Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }
}
