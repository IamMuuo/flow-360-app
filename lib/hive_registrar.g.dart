import 'package:hive_ce/hive.dart';
import 'package:flow_360/features/auth/models/auth_model.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/fuel/models/fuel_price_model.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';
import 'package:flow_360/features/shared/models/fuel_type_model.dart';
import 'package:flow_360/features/shift/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_audit_model.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(AuthModelAdapter());
    registerAdapter(UserModelAdapter());
    registerAdapter(FuelPriceModelAdapter());
    registerAdapter(FuelDispenserModelAdapter());
    registerAdapter(NozzleModelAdapter());
    registerAdapter(FuelTypeModelAdapter());
    registerAdapter(NozzleReadingModelAdapter());
    registerAdapter(ShiftNozzleModelAdapter());
    registerAdapter(StationShiftModelAdapter());
    registerAdapter(TankAuditModelAdapter());
    registerAdapter(TankModelAdapter());
    registerAdapter(TankReadingModelAdapter());
  }
}
