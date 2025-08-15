// lib/features/employee/controller/employee_controller.dart

import 'dart:io';

import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/employees/repository/employee_repository.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/failure.dart';

class EmployeeController extends GetxController {
  final EmployeeRepository _repository = GetIt.instance<EmployeeRepository>();

  var employees = <UserModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchEmployees({required String stationId}) async {
    isLoading(true);
    errorMessage('');
    try {
      final fetchedEmployees = await _repository.getEmployees(
        stationId: stationId,
      );
      employees.assignAll(fetchedEmployees);
    } on Failure catch (e) {
      errorMessage(e.message);
    } finally {
      isLoading(false);
    }
  }

  Future<void> addEmployee({required Map<String, dynamic> data}) async {
    try {
      final newEmployee = await _repository.createEmployee(data: data);
      employees.add(newEmployee);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> updateEmployee(
    String employeeId,
    Map<String, dynamic> data,
  ) async {
    try {
      final updatedEmployee = await _repository.updateEmployee(
        employeeId: employeeId,
        data: data,
      );
      final index = employees.indexWhere((e) => e.id == updatedEmployee.id);
      if (index != -1) {
        employees[index] = updatedEmployee;
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<void> uploadProfilePicture({
    required String employeeId,
    required File imageFile,
  }) async {
    isLoading(true);
    try {
      final updatedEmployee = await _repository.uploadProfilePicture(
        employeeId: employeeId,
        imageFile: imageFile,
      );
      // Update the employee in the local list
      final index = employees.indexWhere((e) => e.id == updatedEmployee.id);
      if (index != -1) {
        employees[index] = updatedEmployee;
      }
      // Success - UI will handle showing snackbar
    } on Failure catch (e) {
      // Error - UI will handle showing snackbar
    } finally {
      isLoading(false);
    }
  }
}
