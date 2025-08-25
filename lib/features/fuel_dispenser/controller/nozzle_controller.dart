// lib/features/fuel_dispenser/controller/nozzle_controller.dart

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';
import 'package:flow_360/features/fuel_dispenser/repository/nozzle_repository.dart';

// Removed "with StateMixin<List<NozzleModel>>"
class NozzleController extends GetxController {
  final NozzleRepository _repository = GetIt.instance<NozzleRepository>();

  // This will be the single source of truth for your UI
  var nozzles = <NozzleModel>[].obs;

  // Add a loading state variable
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchNozzles(String dispenserId) async {
    isLoading(true);
    errorMessage('');

    try {
      final fetchedNozzles = await _repository.getNozzles(
        dispenserId: dispenserId,
      );
      nozzles.assignAll(fetchedNozzles);
    } on Failure catch (e) {
      errorMessage(e.message);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> createNozzle({
    required String dispenserId,
    required String fuelType,
    required int nozzleNumber,
    required bool isActive,
    double? initialReading,
    String? tankId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "fuel_type": fuelType,
        "nozzle_number": nozzleNumber,
        "is_active": isActive,
        "dispenser": dispenserId,
        "initial_reading": initialReading ?? 0.0,
      };

      // Add tank if provided
      if (tankId != null && tankId.isNotEmpty) {
        data["tank"] = tankId;
      }

      final newNozzle = await _repository.createNozzle(
        dispenserId: dispenserId,
        data: data,
      );
      nozzles.add(newNozzle); // The UI will rebuild automatically
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred: $e');
    }
  }

  Future<void> updateNozzle({
    required String dispenserId,
    required String nozzleId,
    required String fuelType,
    required int nozzleNumber,
    required bool isActive,
    String? tankId,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "fuel_type": fuelType,
        "nozzle_number": nozzleNumber,
        "is_active": isActive,
        "dispenser": dispenserId,
      };

      // Add tank if provided
      if (tankId != null && tankId.isNotEmpty) {
        data["tank"] = tankId;
      }

      await _repository.updateNozzle(
        dispenserId: dispenserId,
        nozzleId: nozzleId,
        data: data,
      );

      // Optimistically update the local list, which triggers a UI rebuild
      final index = nozzles.indexWhere((n) => n.id == nozzleId);
      if (index != -1) {
        // For now, we'll just update the other fields since fuelType is now an object
        // TODO: Create a proper FuelTypeModel from the fuelType string when backend is updated
        nozzles[index] = nozzles[index].copyWith(
          nozzleNumber: nozzleNumber,
          isActive: isActive,
          tank: tankId,
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred: $e');
    }
  }
}
