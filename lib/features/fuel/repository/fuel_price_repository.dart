import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/hive/hive_service.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/fuel/models/fuel_price_model.dart';
import 'package:flow_360/features/fuel/models/fuel_price_response.dart';

class FuelPriceRepository {
  final DioClient _dioClient;
  final HiveService _hiveService;

  // Define a cache key for each station's fuel prices
  static const _cacheBoxName = 'app_cache';
  String _getCacheKey(String stationId) => 'fuel_prices_$stationId';

  // Constructor now requires its dependencies
  FuelPriceRepository({
    required DioClient dioClient,
    required HiveService hiveService,
  }) : _dioClient = dioClient,
       _hiveService = hiveService;

  // Fetches fuel prices from the network and caches them
  Future<List<FuelPriceModel>> getFuelPrices({
    required String stationId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/station/$stationId/fuel-prices/',
      );

      final List<dynamic> results = response.data['results'] as List;
      final prices = results
          .map((json) => FuelPriceModel.fromJson(json))
          .toList();

      // Cache the fetched data using the injected HiveService
      await _hiveService.putCache<List<FuelPriceModel>>(
        _getCacheKey(stationId),
        prices,
      );

      return prices;
    } catch (e) {
      rethrow;
    }
  }

  // Retrieves fuel prices from the local Hive cache
  Future<List<FuelPriceModel>?> getCachedFuelPrices({
    required String stationId,
  }) async {
    final cachedData = _hiveService.getCache<List<dynamic>>(
      _getCacheKey(stationId),
    );
    if (cachedData == null) {
      return null;
    }
    // Hive returns a dynamic list, so we map it to our model list
    return cachedData.cast<FuelPriceModel>();
  }

  // Creates a new fuel price entry
  Future<FuelPriceModel> createFuelPrice({
    required String stationId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _dioClient.dio.post(
      '/station/fuel-prices/create/',
      data: data,
    );
    return FuelPriceModel.fromJson(response.data);
  }
}
