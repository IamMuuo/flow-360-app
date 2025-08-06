// lib/features/fuel_dispenser/repository/nozzle_repository.dart

import 'package:dio/dio.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/hive/hive_service.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';

class NozzleRepository {
  final DioClient _dioClient;
  final HiveService _hiveService;

  static const _cacheBoxName = 'app_cache';
  String _getCacheKey(String dispenserId) => 'nozzles_$dispenserId';

  NozzleRepository({
    required DioClient dioClient,
    required HiveService hiveService,
  }) : _dioClient = dioClient,
       _hiveService = hiveService;

  Future<List<NozzleModel>> getCachedNozzles({
    required String dispenserId,
  }) async {
    // Check cache first
    final cachedNozzles = await _hiveService.getCache<List<NozzleModel>>(
      _getCacheKey(dispenserId),
    );
    if (cachedNozzles != null) {
      return cachedNozzles;
    }
    return [];
  }

  Future<List<NozzleModel>> getNozzles({required String dispenserId}) async {
    // Check cache first
    final cachedNozzles = await _hiveService.getCache<List<NozzleModel>>(
      _getCacheKey(dispenserId),
    );
    try {
      final response = await _dioClient.dio.get(
        '/station/fuel-dispensers/$dispenserId/nozzles',
      );

      if (response.data is! Map<String, dynamic> ||
          !response.data.containsKey('results')) {
        throw Failure(message: 'Invalid data format received from the server.');
      }

      final List<dynamic> results = response.data['results'] as List;
      final nozzles = results
          .map((json) => NozzleModel.fromJson(json))
          .toList();

      await _hiveService.putCache<List<NozzleModel>>(
        _getCacheKey(dispenserId),
        nozzles,
      );
      return nozzles;
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['detail'] ?? 'Failed to fetch nozzles.';
      } else {
        errorMessage = 'An unexpected server error occurred.';
      }
      throw Failure(message: errorMessage);
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<NozzleModel> createNozzle({
    required String dispenserId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Endpoint for creating a nozzle
      final response = await _dioClient.dio.post(
        '/station/nozzles/create/',
        data: data,
      );
      return NozzleModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['detail'] ?? 'Failed to create nozzle.';
      } else {
        errorMessage =
            'An unexpected server error occurred during nozzle creation.';
      }
      throw Failure(message: errorMessage);
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> updateNozzle({
    required String dispenserId,
    required String nozzleId,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Endpoint for updating a specific nozzle
      await _dioClient.dio.put('/station/nozzles/$nozzleId/', data: data);
    } on DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['detail'] ?? 'Failed to update nozzle.';
      } else {
        errorMessage =
            'An unexpected server error occurred during nozzle update.';
      }
      throw Failure(message: errorMessage);
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
