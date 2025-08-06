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
    } finally {
      isLoading(false);
    }
  }

  Future<void> createNozzle({
    required String dispenserId,
    required String fuelType,
    required int nozzleNumber,
    required bool isActive,
  }) async {
    try {
      final Map<String, dynamic> data = {
        "fuel_type": fuelType,
        "nozzle_number": nozzleNumber,
        "is_active": isActive,
        "dispenser": dispenserId,
      };

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
  }) async {
    try {
      final Map<String, dynamic> data = {
        "fuel_type": fuelType,
        "nozzle_number": nozzleNumber,
        "is_active": isActive,
        "dispenser": dispenserId,
      };

      await _repository.updateNozzle(
        dispenserId: dispenserId,
        nozzleId: nozzleId,
        data: data,
      );

      // Optimistically update the local list, which triggers a UI rebuild
      final index = nozzles.indexWhere((n) => n.id == nozzleId);
      if (index != -1) {
        nozzles[index] = nozzles[index].copyWith(
          fuelType: fuelType,
          nozzleNumber: nozzleNumber,
          isActive: isActive,
        );
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred: $e');
    }
  }
}
