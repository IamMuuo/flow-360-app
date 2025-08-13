import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';
import 'package:flow_360/features/tank/repository/station_shift_repository.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';

class StationShiftController extends GetxController {
  final StationShiftRepository _repository = GetIt.instance<StationShiftRepository>();
  final AuthController _authController = Get.find<AuthController>();

  // Observable lists
  final RxList<StationShiftModel> stationShifts = <StationShiftModel>[].obs;
  final RxList<TankReadingModel> tankReadings = <TankReadingModel>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isCreatingShift = false.obs;
  final RxBool isUpdatingShift = false.obs;
  final RxBool isCreatingReading = false.obs;
  final RxBool isReconciling = false.obs;

  // Error messages
  final RxString errorMessage = ''.obs;

  // Selected shift
  final Rx<StationShiftModel?> selectedShift = Rx<StationShiftModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadStationShifts();
  }

  // Computed properties
  List<StationShiftModel> get activeShifts => 
      stationShifts.where((shift) => shift.status == 'ACTIVE').toList();

  List<StationShiftModel> get completedShifts => 
      stationShifts.where((shift) => shift.status == 'COMPLETED').toList();

  List<TankReadingModel> get readingsWithVariance => 
      tankReadings.where((reading) => reading.hasVariance).toList();

  List<TankReadingModel> get readingsNeedingReconciliation => 
      tankReadings.where((reading) => reading.needsReconciliation).toList();

  // Get current user's station ID
  String? get _currentStationId {
    final currentUser = _authController.currentUser.value;
    return currentUser?.user.station;
  }

  // Load station shifts
  Future<void> loadStationShifts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final stationId = _currentStationId;
      if (stationId == null) {
        errorMessage.value = 'No station assigned to user';
        return;
      }
      
      final shifts = await _repository.getStationShifts(stationId: stationId);
      stationShifts.assignAll(shifts);
    } catch (e) {
      errorMessage.value = 'Failed to load station shifts: ${e.toString()}';
      _showSnackBar('Error', errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh station shifts
  Future<void> refreshStationShifts() async {
    await loadStationShifts();
  }

  // Create station shift
  Future<void> createStationShift(Map<String, dynamic> data) async {
    try {
      isCreatingShift.value = true;
      
      final shift = await _repository.createStationShift(data: data);
      stationShifts.add(shift);
      
      _showSnackBar('Success', 'Station shift created successfully');
      _closeDialog();
    } catch (e) {
      _showSnackBar('Error', 'Failed to create station shift: ${e.toString()}', isError: true);
    } finally {
      isCreatingShift.value = false;
    }
  }

  // Update station shift
  Future<void> updateStationShift(String shiftId, Map<String, dynamic> data) async {
    try {
      isUpdatingShift.value = true;
      
      final updatedShift = await _repository.updateStationShift(
        shiftId: shiftId,
        data: data,
      );
      final index = stationShifts.indexWhere((shift) => shift.id == shiftId);
      
      if (index != -1) {
        stationShifts[index] = updatedShift;
      }
      
      _showSnackBar('Success', 'Station shift updated successfully');
      _closeDialog();
    } catch (e) {
      _showSnackBar('Error', 'Failed to update station shift: ${e.toString()}', isError: true);
    } finally {
      isUpdatingShift.value = false;
    }
  }

  // Load tank readings for a shift
  Future<void> loadTankReadings(String shiftId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final readings = await _repository.getTankReadings(shiftId: shiftId);
      tankReadings.assignAll(readings);
    } catch (e) {
      rethrow;
      errorMessage.value = 'Failed to load tank readings: ${e.toString()}';
      _showSnackBar('Error', errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Create tank reading
  Future<void> createTankReading(Map<String, dynamic> data) async {
    try {
      isCreatingReading.value = true;
      
      print('DEBUG: Creating tank reading with data: $data');
      final reading = await _repository.createTankReading(data: data);
      print('DEBUG: Created reading: ${reading.id}');
      
      // Refresh the entire list to ensure UI updates
      if (selectedShift.value != null) {
        await loadTankReadings(selectedShift.value!.id);
      }
      
      print('DEBUG: Refreshed readings list. Total readings: ${tankReadings.length}');
      
      _showSnackBar('Success', 'Tank reading created successfully');
      _closeDialog();
    } catch (e) {
      print('DEBUG: Error creating tank reading: $e');
      _showSnackBar('Error', 'Failed to create tank reading: ${e.toString()}', isError: true);
    } finally {
      isCreatingReading.value = false;
    }
  }

  // Reconcile tank reading
  Future<void> reconcileTankReading(String readingId, Map<String, dynamic> data) async {
    try {
      isReconciling.value = true;
      
      final reconciledReading = await _repository.reconcileTankReading(
        readingId: readingId,
        data: data,
      );
      final index = tankReadings.indexWhere((reading) => reading.id == readingId);
      
      if (index != -1) {
        tankReadings[index] = reconciledReading;
      }
      
      _showSnackBar('Success', 'Tank reading reconciled successfully');
      _closeDialog();
    } catch (e) {
      _showSnackBar('Error', 'Failed to reconcile tank reading: ${e.toString()}', isError: true);
    } finally {
      isReconciling.value = false;
    }
  }

  // Select a shift
  void selectShift(StationShiftModel shift) {
    selectedShift.value = shift;
    loadTankReadings(shift.id);
  }

  // Clear selected shift
  void clearSelectedShift() {
    selectedShift.value = null;
    tankReadings.clear();
  }

  // Navigation methods using GoRouter
  void navigateToReadings(StationShiftModel shift) {
    final context = Get.context;
    if (context != null) {
      context.push('/station-shifts/${shift.id}/readings', extra: shift);
    }
  }

  void navigateToStationShifts() {
    final context = Get.context;
    if (context != null) {
      context.push('/station-shifts');
    }
  }

  // Helper methods
  void _showSnackBar(String title, String message, {bool isError = false}) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError ? Icons.error : Icons.check_circle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(message),
              ),
            ],
          ),
          backgroundColor: isError ? Colors.red : Colors.green,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _closeDialog() {
    final context = Get.context;
    if (context != null && Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  }
}
