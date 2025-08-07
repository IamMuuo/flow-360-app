// lib/features/shift/controllers/shift_controller.dart

import 'package:get/get.dart';
import 'package:flow_360/features/shift/models/shift_model.dart';
import 'package:flow_360/features/shift/repository/shift_repository.dart';
import 'package:flow_360/core/failure.dart';

class ShiftController extends GetxController {
  final ShiftRepository _shiftRepository = ShiftRepository();

  // Observable variables
  final Rx<ShiftModel?> currentShift = Rx<ShiftModel?>(null);
  final RxList<ShiftModel> shifts = <ShiftModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isStartingShift = false.obs;
  final RxBool isEndingShift = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadShifts();
    checkCurrentShift();
  }

  Future<void> loadShifts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final shiftsList = await _shiftRepository.getShifts();
      shifts.assignAll(shiftsList);
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkCurrentShift() async {
    try {
      final shift = await _shiftRepository.getCurrentShift();
      currentShift.value = shift;
    } catch (e) {
      currentShift.value = null;
    }
  }

  Future<void> startShift() async {
    try {
      isStartingShift.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final newShift = await _shiftRepository.startShift();
      currentShift.value = newShift;
      shifts.insert(0, newShift);
      successMessage.value = 'Your shift has been started successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isStartingShift.value = false;
    }
  }

  Future<void> endShift() async {
    if (currentShift.value == null) return;

    try {
      isEndingShift.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final endedShift = await _shiftRepository.endShift(currentShift.value!.id);
      
      // Update the current shift
      currentShift.value = null;
      
      // Update the shift in the list
      final index = shifts.indexWhere((shift) => shift.id == endedShift.id);
      if (index != -1) {
        shifts[index] = endedShift;
      }
      successMessage.value = 'Your shift has been ended successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isEndingShift.value = false;
    }
  }

  bool get hasActiveShift => currentShift.value != null;
  
  String get shiftDuration {
    if (currentShift.value == null) return '';
    
    final startTime = DateTime.parse(currentShift.value!.startedAt);
    final now = DateTime.now();
    final duration = now.difference(startTime);
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    return '${hours}h ${minutes}m';
  }

  void clearError() {
    errorMessage.value = '';
  }

  void clearSuccess() {
    successMessage.value = '';
  }
}
