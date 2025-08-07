// lib/features/shift/controllers/supervisor_shift_controller.dart

import 'package:get/get.dart';
import 'package:flow_360/features/shift/models/shift_model.dart';
import 'package:flow_360/features/shift/repository/shift_repository.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/employees/repository/employee_repository.dart';
import 'package:flow_360/core/failure.dart';

class SupervisorShiftController extends GetxController {
  final ShiftRepository _shiftRepository = ShiftRepository();
  final EmployeeRepository _employeeRepository = EmployeeRepository();

  // Observable variables
  final RxList<ShiftModel> employeeShifts = <ShiftModel>[].obs;
  final RxList<UserModel> employees = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreatingShift = false.obs;
  final RxBool isEndingShift = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedEmployeeId = ''.obs;
  final RxString successMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadEmployeeShifts();
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get current user's station ID
      final currentUser = Get.find<AuthController>().currentUser.value;
      if (currentUser?.user.station != null) {
        final employeesList = await _employeeRepository.getEmployees(
          stationId: currentUser!.user.station!,
        );
        employees.assignAll(employeesList);
      }
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEmployeeShifts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final shiftsList = await _shiftRepository.getEmployeeShifts();
      employeeShifts.assignAll(shiftsList);
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createEmployeeShift({
    required String employeeId,
    required DateTime startTime,
  }) async {
    try {
      isCreatingShift.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final newShift = await _shiftRepository.createEmployeeShift(
        employeeId: employeeId,
        startTime: startTime,
      );
      employeeShifts.insert(0, newShift);
      successMessage.value = 'Employee shift has been created successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isCreatingShift.value = false;
    }
  }

  Future<void> endEmployeeShift(String shiftId) async {
    try {
      isEndingShift.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final endedShift = await _shiftRepository.endEmployeeShift(shiftId);
      
      // Update the shift in the list
      final index = employeeShifts.indexWhere((shift) => shift.id == endedShift.id);
      if (index != -1) {
        employeeShifts[index] = endedShift;
      }
      successMessage.value = 'Employee shift has been ended successfully!';
    } on Failure catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isEndingShift.value = false;
    }
  }

  List<ShiftModel> get activeEmployeeShifts {
    return employeeShifts.where((shift) => shift.isActive && shift.endedAt == null).toList();
  }

  List<ShiftModel> get todayEmployeeShifts {
    final today = DateTime.now();
    return employeeShifts.where((shift) {
      final shiftDate = DateTime.parse(shift.startedAt);
      return shiftDate.year == today.year &&
          shiftDate.month == today.month &&
          shiftDate.day == today.day;
    }).toList();
  }

  UserModel? getEmployeeById(String employeeId) {
    try {
      return employees.firstWhere((employee) => employee.id.toString() == employeeId);
    } catch (e) {
      return null;
    }
  }

  void selectEmployee(String employeeId) {
    selectedEmployeeId.value = employeeId;
  }

  void clearError() {
    errorMessage.value = '';
  }

  void clearSuccess() {
    successMessage.value = '';
  }

  String getShiftDuration(ShiftModel shift) {
    final startTime = DateTime.parse(shift.startedAt);
    final endTime = shift.endedAt != null ? DateTime.parse(shift.endedAt!) : DateTime.now();
    final duration = endTime.difference(startTime);
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    return '${hours}h ${minutes}m';
  }
}
