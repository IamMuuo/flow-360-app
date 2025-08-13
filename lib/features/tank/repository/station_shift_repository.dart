import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/hive/hive_service.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';

class StationShiftRepository {
  final DioClient _dioClient;
  final HiveService _hiveService;

  // Define cache keys
  static const _cacheBoxName = 'app_cache';
  String _getStationShiftsCacheKey(String stationId) => 'station_shifts_$stationId';
  String _getTankReadingsCacheKey(String shiftId) => 'tank_readings_$shiftId';

  // Constructor
  StationShiftRepository({
    required DioClient dioClient,
    required HiveService hiveService,
  }) : _dioClient = dioClient,
       _hiveService = hiveService;

  // Fetch station shifts from network and cache them
  Future<List<StationShiftModel>> getStationShifts({
    required String stationId,
    String? date,
    String? status,
  }) async {
    try {
      print('Fetching station shifts for station: $stationId');
      
      final queryParams = <String, dynamic>{};
      if (date != null) queryParams['date'] = date;
      if (status != null) queryParams['status'] = status;
      
      final response = await _dioClient.dio.get(
        '/station/shifts/',
        queryParameters: queryParams,
      );

      print('Station shifts response status: ${response.statusCode}');
      print('Station shifts response data: ${response.data}');

      final List<dynamic> results = response.data['results'] as List;
      final shifts = results
          .map((json) => StationShiftModel.fromJson(json))
          .toList();

      // Cache the fetched data
      await _hiveService.putCache<List<StationShiftModel>>(
        _getStationShiftsCacheKey(stationId),
        shifts,
      );

      return shifts;
    } catch (e) {
      rethrow;
    }
  }

  // Get cached station shifts
  Future<List<StationShiftModel>?> getCachedStationShifts({
    required String stationId,
  }) async {
    final cachedData = _hiveService.getCache<List<dynamic>>(
      _getStationShiftsCacheKey(stationId),
    );
    if (cachedData == null) {
      return null;
    }
    return cachedData.cast<StationShiftModel>();
  }

  // Create new station shift
  Future<StationShiftModel> createStationShift({
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.post(
      '/station/shifts/create/',
      data: data,
    );
    return StationShiftModel.fromJson(response.data);
  }

  // Update station shift
  Future<StationShiftModel> updateStationShift({
    required String shiftId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.put(
      '/station/shifts/$shiftId/update/',
      data: data,
    );
    return StationShiftModel.fromJson(response.data);
  }

  // Get station shift details
  Future<StationShiftModel> getStationShiftDetails({
    required String shiftId,
  }) async {
    final response = await _dioClient.dio.get(
      '/station/shifts/$shiftId/',
    );
    return StationShiftModel.fromJson(response.data);
  }

  // Fetch tank readings for a shift
  Future<List<TankReadingModel>> getTankReadings({
    required String shiftId,
  }) async {
    try {
      print('Fetching tank readings for shift: $shiftId');
      
      final response = await _dioClient.dio.get(
        '/station/shifts/$shiftId/readings/',
      );

      print('Tank readings response status: ${response.statusCode}');
      print('Tank readings response data: ${response.data}');

      final List<dynamic> results = response.data['results'] as List;
      final readings = results
          .map((json) => TankReadingModel.fromJson(json))
          .toList();

      // Cache the fetched data
      await _hiveService.putCache<List<TankReadingModel>>(
        _getTankReadingsCacheKey(shiftId),
        readings,
      );

      return readings;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  // Get cached tank readings
  Future<List<TankReadingModel>?> getCachedTankReadings({
    required String shiftId,
  }) async {
    final cachedData = _hiveService.getCache<List<dynamic>>(
      _getTankReadingsCacheKey(shiftId),
    );
    if (cachedData == null) {
      return null;
    }
    return cachedData.cast<TankReadingModel>();
  }

  // Create new tank reading
  Future<TankReadingModel> createTankReading({
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.post(
      '/station/readings/create/',
      data: data,
    );
    return TankReadingModel.fromJson(response.data);
  }

  // Reconcile tank reading
  Future<TankReadingModel> reconcileTankReading({
    required String readingId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.put(
      '/station/readings/$readingId/reconcile/',
      data: data,
    );
    return TankReadingModel.fromJson(response.data);
  }

  // Get tank readings report
  Future<Map<String, dynamic>> getTankReadingsReport({
    String? startDate,
    String? endDate,
    String? tankId,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;
      if (tankId != null) queryParams['tank_id'] = tankId;
      
      final response = await _dioClient.dio.get(
        '/station/readings/report/',
        queryParameters: queryParams,
      );

      return response.data;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
