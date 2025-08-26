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
    // Wait for user data to be available before loading shifts
    _waitForUserAndLoadShifts();
  }

  Future<void> _waitForUserAndLoadShifts() async {
    // Wait a bit for AuthController to initialize
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Check if user is available, if not wait and retry
    if (_authController.currentUser.value?.user.station == null) {
      // Wait for user data to be loaded
      await Future.delayed(const Duration(milliseconds: 500));
      
      // If still no user data, don't load shifts yet
      if (_authController.currentUser.value?.user.station == null) {
        return;
      }
    }
    
    // Now load shifts
    await loadStationShifts();
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

  // Check if user can create more shifts today
  bool get canCreateShiftToday {
    final currentUser = _authController.currentUser.value;
    if (currentUser == null) return false;
    
    // Admin users can create unlimited shifts
    if (currentUser.user.isStaff) return true;
    
    // Regular users are limited to 3 shifts per day
    final today = DateTime.now();
    final todayShifts = stationShifts.where((shift) {
      final shiftDate = DateTime.parse(shift.shiftDate);
      return shiftDate.year == today.year &&
             shiftDate.month == today.month &&
             shiftDate.day == today.day;
    }).length;
    
    return todayShifts < 3;
  }

  // Get today's shift count
  int get todayShiftCount {
    final today = DateTime.now();
    return stationShifts.where((shift) {
      final shiftDate = DateTime.parse(shift.shiftDate);
      return shiftDate.year == today.year &&
             shiftDate.month == today.month &&
             shiftDate.day == today.day;
    }).length;
  }

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
        errorMessage.value = 'No station assigned to user. Please contact your administrator.';
        return;
      }
      
      final shifts = await _repository.getStationShifts(stationId: stationId);
      stationShifts.assignAll(shifts);
    } catch (e) {
      errorMessage.value = 'Failed to load station shifts: ${e.toString()}';
      // Error - UI will handle showing snackbar
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh station shifts
  Future<void> refreshStationShifts() async {
    await loadStationShifts();
  }

  // Method to load shifts when user data becomes available
  Future<void> loadShiftsIfUserAvailable() async {
    final currentUser = _authController.currentUser.value;
    if (currentUser?.user.station != null) {
      await loadStationShifts();
    }
  }

  // Create station shift
  Future<void> createStationShift(Map<String, dynamic> data) async {
    try {
      isCreatingShift.value = true;
      
      final shift = await _repository.createStationShift(data: data);
      stationShifts.add(shift);
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      // Error - UI will handle showing snackbar
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
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      // Error - UI will handle showing snackbar
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
      // Error - UI will handle showing snackbar
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
        print('DEBUG: Refreshing tank readings for shift: ${selectedShift.value!.id}');
        await loadTankReadings(selectedShift.value!.id);
        print('DEBUG: Tank readings refreshed. Total readings: ${tankReadings.length}');
      } else {
        print('DEBUG: No selected shift, cannot refresh readings');
      }
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      print('DEBUG: Error creating tank reading: $e');
      // Error - UI will handle showing snackbar
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
      
      // Success - UI will handle showing snackbar and closing dialog
    } catch (e) {
      // Error - UI will handle showing snackbar
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

  // Navigation methods - UI will handle navigation
  void navigateToReadings(StationShiftModel shift) {
    // UI will handle navigation
  }

  void navigateToStationShifts() {
    // UI will handle navigation
  }

  // Helper methods - UI will handle these operations
  void _showSnackBar(String title, String message, {bool isError = false}) {
    // UI will handle showing snackbar
  }

  void _closeDialog() {
    // UI will handle closing dialog
  }
}
