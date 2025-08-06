import 'package:flow_360/features/auth/models/auth_model.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/fuel/models/fuel_price_model.dart';
import 'package:hive/hive.dart';

Future<void> registerAdapter() async {
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(AuthModelAdapter());
  Hive.registerAdapter(FuelPriceModelAdapter());
}
