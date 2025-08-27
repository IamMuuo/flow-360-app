// lib/features/shift/controllers/shift_readings_controller.dart

import 'package:get/get.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';
import 'package:flow_360/features/shift/models/station_shift_model.dart';
import 'package:flow_360/features/shift/repository/shift_readings_repository.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/core/failure.dart';
import 'package:get_it/get_it.dart';

class ShiftReadingsController extends GetxController {
  final ShiftReadingsRepository _repository = GetIt.instance<ShiftReadingsRepository>();

  // Observable variables
  final RxList<StationShiftModel> stationShifts = <StationShiftModel>[].obs;
  final RxList<TankModel> stationTanks = <TankModel>[].obs;
  final RxList<ShiftNozzleModel> stationNozzles = <ShiftNozzleModel>[].obs;
  final RxList<TankReadingModel> tankReadings = <TankReadingModel>[].obs;
  final RxList<NozzleReadingModel> nozzleReadings = <NozzleReadingModel>[].obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isCreatingShift = false.obs;
  final RxBool isEndingShift = false.obs;
  final RxBool isSavingReadings = false.obs;
  final RxBool isReconciling = false.obs;
  
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;
  
  final Rx<StationShiftModel?> currentShift = Rx<StationShiftModel?>(null);
  final Rx<Map<String, dynamic>?> shiftSummary = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    loadStationShifts();
    loadStationData();
  }

  Future<void> loadStationShifts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final shifts = await _repository.getStationShifts();
      stationShifts.assignAll(shifts);
      
      // Set current active shift if any
      final activeShift = shifts.where((shift) => shift.isActive).firstOrNull;
      currentShift.value = activeShift;
      
      if (activeShift != null) {
        await loadShiftReadings(activeShift.id);
        await loadShiftSummary(activeShift.id);
      }
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStationData() async {
    try {
      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser?.user.station != null) {
        final stationId = currentUser!.user.station!;
        
        // Load tanks and nozzles for the station
        final tanks = await _repository.getStationTanks(stationId);
        final nozzles = await _repository.getStationNozzles(stationId);
        
        stationTanks.assignAll(tanks);
        stationNozzles.assignAll(nozzles);
      }
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to load station data';
    }
  }

  Future<void> loadShiftReadings(String shiftId) async {
    try {
      final tankReadingsList = await _repository.getTankReadings(shiftId);
      final nozzleReadingsList = await _repository.getNozzleReadings(shiftId);
      
      tankReadings.assignAll(tankReadingsList);
      nozzleReadings.assignAll(nozzleReadingsList);
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to load shift readings';
    }
  }

  Future<void> loadShiftSummary(String shiftId) async {
    try {
      final summary = await _repository.getShiftSummary(shiftId);
      shiftSummary.value = summary;
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to load shift summary';
    }
  }

  Future<Map<String, dynamic>?> loadVarianceSummary(String shiftId) async {
    try {
      final summary = await _repository.getVarianceSummary(shiftId);
      return summary;
    } on Failure catch (e) {
      errorMessage.value = e.message;
      return null;
    } catch (e) {
      errorMessage.value = 'Failed to load variance summary';
      return null;
    }
  }

  Future<void> createStationShift({
    required String shiftDate,
    required String startTime,
    String? notes,
  }) async {
    try {
      isCreatingShift.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser?.user.station == null) {
        throw Failure(message: 'No station assigned to current user');
      }

      // Check for existing active shifts for the same date
      final existingActiveShift = stationShifts.where((shift) => 
        shift.shiftDate == shiftDate && shift.status == 'ACTIVE'
      ).firstOrNull;

      if (existingActiveShift != null) {
        throw Failure(message: 'You already have an active shift for this date. Please end the current shift before creating a new one.');
      }

      // Check shift limit per day (3 shifts per day for regular users, unlimited for staff)
      final isStaff = currentUser?.user.isStaff ?? false;
      if (!isStaff) {
        final existingShiftsCount = stationShifts.where((shift) => 
          shift.shiftDate == shiftDate
        ).length;
        
        if (existingShiftsCount >= 3) {
          throw Failure(message: 'Maximum 3 shifts per day allowed. You have already created 3 shifts for this date.');
        }
      }

      final newShift = await _repository.createStationShift(

        stationId: currentUser!.user.station!,
        shiftDate: shiftDate,
        startTime: startTime,
        notes: notes,
      );

      stationShifts.insert(0, newShift);
      currentShift.value = newShift;
      successMessage.value = 'Station shift created successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to create station shift';
    } finally {
      isCreatingShift.value = false;
    }
  }

  Future<void> endStationShift({
    required String shiftId,
    required String endTime,
    String? notes,
  }) async {
    try {
      isEndingShift.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final updatedShift = await _repository.endStationShift(
        shiftId: shiftId,
        endTime: endTime,
        notes: notes,
      );

      // Update the shift in the list
      final index = stationShifts.indexWhere((shift) => shift.id == shiftId);
      if (index != -1) {
        stationShifts[index] = updatedShift;
      }

      // Clear current shift if it was the active one
      if (currentShift.value?.id == shiftId) {
        currentShift.value = null;
      }

      // Handle variance invoicing silently - user doesn't need to know about it
      successMessage.value = 'Station shift ended successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to end station shift';
    } finally {
      isEndingShift.value = false;
    }
  }

  Future<void> createTankReading({
    required String tankId,
    required String readingType,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      isSavingReadings.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      if (currentShift.value == null) {
        throw Failure(message: 'No active shift found');
      }

      final reading = await _repository.createTankReading(
        shiftId: currentShift.value!.id,
        tankId: tankId,
        readingType: readingType,
        manualReading: manualReading,
        reconciliationNotes: reconciliationNotes,
      );

      tankReadings.add(reading);
      successMessage.value = 'Tank reading recorded successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to record tank reading';
    } finally {
      isSavingReadings.value = false;
    }
  }

  Future<void> createNozzleReading({
    required String nozzleId,
    required String readingType,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      isSavingReadings.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      if (currentShift.value == null) {
        throw Failure(message: 'No active shift found');
      }

      final reading = await _repository.createNozzleReading(
        shiftId: currentShift.value!.id,
        nozzleId: nozzleId,
        readingType: readingType,
        manualReading: manualReading,
        reconciliationNotes: reconciliationNotes,
      );

      nozzleReadings.add(reading);
      successMessage.value = 'Nozzle reading recorded successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to record nozzle reading';
    } finally {
      isSavingReadings.value = false;
    }
  }

  Future<void> updateTankReading({
    required String readingId,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      isSavingReadings.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      if (currentShift.value == null) {
        throw Failure(message: 'No active shift found');
      }

      final updatedReading = await _repository.updateTankReading(
        shiftId: currentShift.value!.id,
        readingId: readingId,
        manualReading: manualReading,
        reconciliationNotes: reconciliationNotes,
      );

      // Update the reading in the list
      final index = tankReadings.indexWhere((reading) => reading.id == readingId);
      if (index != -1) {
        tankReadings[index] = updatedReading;
      }

      successMessage.value = 'Tank reading updated successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to update tank reading';
    } finally {
      isSavingReadings.value = false;
    }
  }

  Future<void> updateNozzleReading({
    required String readingId,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      isSavingReadings.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      if (currentShift.value == null) {
        throw Failure(message: 'No active shift found');
      }

      final updatedReading = await _repository.updateNozzleReading(
        shiftId: currentShift.value!.id,
        readingId: readingId,
        manualReading: manualReading,
        reconciliationNotes: reconciliationNotes,
      );

      // Update the reading in the list
      final index = nozzleReadings.indexWhere((reading) => reading.id == readingId);
      if (index != -1) {
        nozzleReadings[index] = updatedReading;
      }

      successMessage.value = 'Nozzle reading updated successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to update nozzle reading';
    } finally {
      isSavingReadings.value = false;
    }
  }

  Future<void> reconcileShiftReadings() async {
    try {
      isReconciling.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      if (currentShift.value == null) {
        throw Failure(message: 'No active shift found');
      }

      await _repository.reconcileShiftReadings(currentShift.value!.id);
      
      // Reload readings and summary after reconciliation
      await loadShiftReadings(currentShift.value!.id);
      await loadShiftSummary(currentShift.value!.id);

      successMessage.value = 'Shift readings reconciled successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Failed to reconcile shift readings';
    } finally {
      isReconciling.value = false;
    }
  }

  // Helper methods
  List<TankReadingModel> getTankReadingsByType(String readingType) {
    return tankReadings.where((reading) => reading.readingType == readingType).toList();
  }

  List<NozzleReadingModel> getNozzleReadingsByType(String readingType) {
    return nozzleReadings.where((reading) => reading.readingType == readingType).toList();
  }

  TankReadingModel? getTankReading(String tankId, String readingType) {
    return tankReadings.where((reading) => 
      reading.tank == tankId && reading.readingType == readingType
    ).firstOrNull;
  }

  NozzleReadingModel? getNozzleReading(String nozzleId, String readingType) {
    return nozzleReadings.where((reading) => 
      reading.nozzle == nozzleId && reading.readingType == readingType
    ).firstOrNull;
  }

  bool hasOpeningReadings() {
    return tankReadings.any((reading) => reading.readingType == 'OPENING') ||
           nozzleReadings.any((reading) => reading.isOpeningReading);
  }

  bool hasClosingReadings() {
    return tankReadings.any((reading) => reading.readingType == 'CLOSING') ||
           nozzleReadings.any((reading) => reading.isClosingReading);
  }

  bool canEndShift() {
    return currentShift.value != null && 
           currentShift.value!.isActive &&
           hasOpeningReadings() &&
           hasClosingReadings();
  }

  // Get today's shifts
  List<StationShiftModel> getTodayShifts() {
    final today = DateTime.now();
    return stationShifts.where((shift) {
      final shiftDate = DateTime.parse(shift.shiftDate);
      return shiftDate.year == today.year &&
             shiftDate.month == today.month &&
             shiftDate.day == today.day;
    }).toList();
  }

  // Check if user can create more shifts today
  bool get canCreateShiftToday {
    final currentUser = Get.find<AuthController>().currentUser.value;
    if (currentUser == null) return false;
    
    // Admin users can create unlimited shifts
    if (currentUser.user.isStaff) return true;
    
    // Regular users are limited to 3 shifts per day
    final todayShifts = getTodayShifts();
    return todayShifts.length < 3;
  }

  void clearError() {
    errorMessage.value = '';
  }

  void clearSuccess() {
    successMessage.value = '';
  }
}
