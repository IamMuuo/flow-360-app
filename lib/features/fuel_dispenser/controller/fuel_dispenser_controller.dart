import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:flow_360/features/fuel_dispenser/repository/fuel_dispenser_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class FuelDispenserController extends GetxController
    with StateMixin<List<FuelDispenserModel>> {
  final FuelDispenserRepository _repository =
      GetIt.instance<FuelDispenserRepository>();

  final RxList<FuelDispenserModel> dispensers = <FuelDispenserModel>[].obs;

  Future<void> fetchFuelDispensers(String stationId) async {
    // Attempt to load cached data first
    final cachedDispensers = await _repository.getCachedFuelDispensers(
      stationId: stationId,
    );

    if (cachedDispensers != null && cachedDispensers.isNotEmpty) {
      dispensers.assignAll(cachedDispensers);
      change(cachedDispensers, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.loading());
    }

    // Then, fetch fresh data from the network
    try {
      final freshDispensers = await _repository.getFuelDispensers(
        stationId: stationId,
      );
      if (freshDispensers.isEmpty) {
        change(freshDispensers, status: RxStatus.empty());
      } else {
        dispensers.assignAll(freshDispensers);
        change(freshDispensers, status: RxStatus.success());
      }
    } on Failure catch (e) {
      // If there's no cached data, set the state to error
      if (dispensers.isEmpty) {
        change(null, status: RxStatus.error(e.message));
      } else {
        // If there is cached data, rethrow the exception
        // The UI will catch this and show a snackbar
        rethrow;
      }
    }
  }

  Future<void> createFuelDispenser({
    required String stationId,
    required String name,
    required String serialNumber,
    required String manufacturer,
    required String installedAt, // YYYY-MM-DD format
    required bool isActive,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "station": stationId,
        "name": name,
        "serial_number": serialNumber,
        "manufacturer": manufacturer,
        "installed_at": installedAt,
        "is_active": isActive,
      };

      // Assuming your API endpoint for creating a dispenser is just /fuel-dispensers/create/
      // or similar, not nested under station/:id for POST
      // If it's nested under station/:id, adjust the URL in repository
      await _repository.createFuelDispenser(data: data);

      // After successful creation, refresh the list of dispensers
      await fetchFuelDispensers(stationId);
    } on Failure {
      rethrow; // Rethrow the specific failure for the UI to handle
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred: $e');
    }
  }

  Future<void> updateFuelDispenser({
    required String stationId,
    required String dispenserId,
    required String name,
    required String serialNumber,
    required String manufacturer,
    required String installedAt,
    required bool isActive,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "station": stationId,
        "name": name,
        "serial_number": serialNumber,
        "manufacturer": manufacturer,
        "installed_at": installedAt,
        "is_active": isActive,
      };

      await _repository.updateFuelDispenser(
        dispenserId: dispenserId,
        data: data,
      );

      final currentDispenser = dispensers.firstWhere(
        (d) => d.id == dispenserId,
      );
      final updatedDispenser = currentDispenser.copyWith(
        name: name,
        serialNumber: serialNumber,
        manufacturer: manufacturer,
        installedAt: installedAt,
        isActive: isActive,
      );

      // Update the list of dispensers
      final index = dispensers.indexOf(currentDispenser);
      dispensers[index] = updatedDispenser;
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred: $e');
    }
  }
}
