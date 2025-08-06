import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/fuel/models/fuel_price_model.dart';
import 'package:flow_360/features/fuel/repository/fuel_price_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class FuelPriceController extends GetxController
    with StateMixin<List<FuelPriceModel>> {
  final FuelPriceRepository _repository = GetIt.instance<FuelPriceRepository>();

  final RxList<FuelPriceModel> fuelPrices = <FuelPriceModel>[].obs;

  Future<void> fetchFuelPrices(String stationId) async {
    // 1. Try to load from cache first
    final cachedPrices = await _repository.getCachedFuelPrices(
      stationId: stationId,
    );

    if (cachedPrices != null && cachedPrices.isNotEmpty) {
      fuelPrices.assignAll(cachedPrices);
      change(cachedPrices, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.loading());
    }

    // 2. Fetch from network and update cache and UI
    try {
      final prices = await _repository.getFuelPrices(stationId: stationId);
      if (prices.isEmpty) {
        change(prices, status: RxStatus.empty());
      } else {
        fuelPrices.assignAll(prices);
        change(prices, status: RxStatus.success());
      }
    } on Failure catch (e) {
      if (fuelPrices.isEmpty) {
        // Only show an error if there was no cached data to display
        change(null, status: RxStatus.error(e.message));
      } else {
        // Show a snackbar to inform the user of the network error while displaying cached data
        Get.snackbar(
          'Network Error',
          'Failed to fetch latest prices. Displaying cached data.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Method to update a fuel price
  Future<void> updateFuelPrice({
    required String stationId,
    required String fuelType,
    required double newPrice,
  }) async {
    try {
      // Create the new price record in the backend
      final Map<String, dynamic> data = {
        "station": stationId,
        'fuel_type': fuelType,
        'price_per_litre': newPrice.toStringAsFixed(2),
        "effective_from": DateTime.now().toUtc().toIso8601String(),
      };
      await _repository.createFuelPrice(stationId: stationId, data: data);

      // After a successful update, refresh the list by calling the network
      await fetchFuelPrices(stationId);
    } on Failure {
      rethrow;
    }
  }
}
