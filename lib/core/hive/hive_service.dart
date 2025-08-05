import 'package:flow_360/core/core.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    registerAdapter();
  }

  static Future<void> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<T>(boxName);
    }
  }

  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  static Future<void> put<T>(String boxName, String key, T value) async {
    final b = getBox<T>(boxName);
    await b.put(key, value);
  }

  static T? get<T>(String boxName, String key) {
    final b = getBox<T>(boxName);
    return b.get(key);
  }

  static Future<void> clear(String boxName) async {
    final b = Hive.box(boxName);
    await b.clear();
  }

  static Future<void> delete<T>(String boxName, String key) async {
    final b = getBox<T>(boxName);
    await b.delete(key);
  }
}
