// lib/features/fuel/repository/fuel_dispenser_repository.dart

import 'package:flow_360/core/hive/hive_service.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/core/failure.dart';
import 'package:dio/dio.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';

class FuelDispenserRepository {
  final DioClient _dioClient;
  final HiveService _hiveService;

  static const _cacheBoxName = 'app_cache';
  String _getCacheKey(String stationId) => 'fuel_dispensers_$stationId';

  FuelDispenserRepository({
    required DioClient dioClient,
    required HiveService hiveService,
  }) : _dioClient = dioClient,
       _hiveService = hiveService;

  Future<List<FuelDispenserModel>> getFuelDispensers({
    required String stationId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/station/$stationId/fuel-dispensers',
      );

      // Check if response.data is a Map and contains the 'results' key
      if (response.data is! Map<String, dynamic> ||
          !response.data.containsKey('results')) {
        throw Failure(message: 'Invalid data format received from the server.');
      }

      final List<dynamic> results = response.data['results'] as List;
      final dispensers = results
          .map((json) => FuelDispenserModel.fromJson(json))
          .toList();

      await _hiveService.putCache<List<FuelDispenserModel>>(
        _getCacheKey(stationId),
        dispensers,
      );

      return dispensers;
    } on DioException catch (e) {
      String errorMessage;

      // Check if the response data is a Map before trying to access it
      if (e.response?.data is Map) {
        errorMessage =
            e.response?.data['detail'] ?? 'Failed to fetch dispensers';
      } else {
        // If the data is not a Map (e.g., HTML), use a generic message
        errorMessage = 'An unexpected server error occurred.';
      }

      throw Failure(message: errorMessage);
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<FuelDispenserModel>?> getCachedFuelDispensers({
    required String stationId,
  }) async {
    final cachedData = _hiveService.getCache<List<dynamic>>(
      _getCacheKey(stationId),
    );
    if (cachedData == null) {
      return null;
    }
    return cachedData.cast<FuelDispenserModel>();
  }

  Future<FuelDispenserModel> createFuelDispenser({
    required Map<String, dynamic> data,
  }) async {
    try {
      // Assuming the POST endpoint is '/fuel-dispensers/create/'
      // If it's different, adjust this URL.
      final response = await _dioClient.dio.post(
        'station/fuel-dispensers/create/',
        data: data,
      );
      return FuelDispenserModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage =
            e.response?.data['detail'] ?? 'Failed to create dispenser.';
      } else {
        errorMessage =
            'An unexpected server error occurred during dispenser creation.';
      }
      throw Failure(message: errorMessage);
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> updateFuelDispenser({
    required String dispenserId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Assuming your API endpoint for updating is /fuel-dispensers/:id/
      await _dioClient.dio.put(
        'station/fuel-dispensers/$dispenserId/',
        data: data,
      );
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage =
            e.response?.data['detail'] ?? 'Failed to update dispenser.';
      } else {
        errorMessage =
            'An unexpected server error occurred during dispenser update.';
      }
      throw Failure(message: errorMessage);
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
