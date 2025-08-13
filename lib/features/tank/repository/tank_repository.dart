import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/hive/hive_service.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';
import 'package:flow_360/features/tank/models/tank_audit_model.dart';

class TankRepository {
  final DioClient _dioClient;
  final HiveService _hiveService;

  // Define cache keys
  static const _cacheBoxName = 'app_cache';
  String _getTanksCacheKey(String stationId) => 'tanks_$stationId';
  String _getTankAuditCacheKey(String tankId) => 'tank_audit_$tankId';

  // Constructor
  TankRepository({
    required DioClient dioClient,
    required HiveService hiveService,
  }) : _dioClient = dioClient,
       _hiveService = hiveService;

  // Fetch tanks from network and cache them
  Future<List<TankModel>> getTanks({
    required String stationId,
  }) async {
    try {
      print('Fetching tanks for station: $stationId');
      final response = await _dioClient.dio.get(
        '/station/$stationId/tanks/',
      );

      print('Tank response status: ${response.statusCode}');
      print('Tank response data: ${response.data}');

      final List<dynamic> results = response.data['results'] as List;
      final tanks = results
          .map((json) => TankModel.fromJson(json))
          .toList();

      // Cache the fetched data
      await _hiveService.putCache<List<TankModel>>(
        _getTanksCacheKey(stationId),
        tanks,
      );

      return tanks;
    } catch (e) {
      // print('Error fetching tanks: $e');
      // if (e is DioException) {
      //   print('DioException status: ${e.response?.statusCode}');
      //   print('DioException data: ${e.response?.data}');
      // }
    print(e.toString());
      rethrow;
    }
  }

  // Get cached tanks
  Future<List<TankModel>?> getCachedTanks({
    required String stationId,
  }) async {
    final cachedData = _hiveService.getCache<List<dynamic>>(
      _getTanksCacheKey(stationId),
    );
    if (cachedData == null) {
      return null;
    }
    return cachedData.cast<TankModel>();
  }

  // Create new tank
  Future<TankModel> createTank({
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.post(
      '/station/tanks/create/',
      data: data,
    );
    return TankModel.fromJson(response.data);
  }

  // Update tank
  Future<TankModel> updateTank({
    required String tankId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.put(
      '/station/tanks/$tankId/',
      data: data,
    );
    return TankModel.fromJson(response.data);
  }

  // Add fuel to tank
  Future<TankAuditModel> addFuelToTank({
    required String tankId,
    required double litres,
    required String reason,
  }) async {
    final response = await _dioClient.dio.post(
      '/station/tanks/$tankId/add-fuel/',
      data: {
        'litres': litres,
        'reason': reason,
      },
    );
    return TankAuditModel.fromJson(response.data);
  }

  // Adjust tank level
  Future<TankAuditModel> adjustTankLevel({
    required String tankId,
    required double newLevel,
    required String reason,
  }) async {
    final response = await _dioClient.dio.post(
      '/station/tanks/$tankId/adjust-level/',
      data: {
        'new_level': newLevel,
        'reason': reason,
      },
    );
    return TankAuditModel.fromJson(response.data);
  }

  // Get tank audit trail
  Future<List<TankAuditModel>> getTankAuditTrail({
    required String tankId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/station/tanks/$tankId/audit/',
      );

      final List<dynamic> results = response.data['results'] as List;
      final audits = results
          .map((json) => TankAuditModel.fromJson(json))
          .toList();

      // Cache the audit trail
      await _hiveService.putCache<List<TankAuditModel>>(
        _getTankAuditCacheKey(tankId),
        audits,
      );

      return audits;
    } catch (e) {
      rethrow;
    }
  }

  // Get cached tank audit trail
  Future<List<TankAuditModel>?> getCachedTankAuditTrail({
    required String tankId,
  }) async {
    final cachedData = _hiveService.getCache<List<dynamic>>(
      _getTankAuditCacheKey(tankId),
    );
    if (cachedData == null) {
      return null;
    }
    return cachedData.cast<TankAuditModel>();
  }
}
