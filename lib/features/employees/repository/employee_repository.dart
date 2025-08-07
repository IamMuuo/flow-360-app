import 'dart:io';

import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

class EmployeeRepository {
  final DioClient _dioClient;

  EmployeeRepository() : _dioClient = GetIt.instance<DioClient>();

  Future<UserModel> createEmployee({required Map<String, dynamic> data}) async {
    // Get the current user's station ID
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    final stationId = currentUser?.user.station;
    
    if (stationId == null) {
      throw Failure(message: 'No station found for current user.');
    }
    
    // Remove password1 and password2 as the backend expects just password
    // data.addAll({
    //   "password1": data["password"], 
    //   "password2": data["password"],
    //   "station": stationId,
    // });
    
    try {
      print('Sending data to create employee: $data');
      print('Endpoint: /station/$stationId/employees/create/');
      final response = await _dioClient.dio.post(
        '/station/$stationId/employees/create/',
        data: data,
      );
      print('Response received: ${response.data}');
      return UserModel.fromJson(response.data);
    } on dio.DioException catch (e) {
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['detail'] ?? 'Failed to create employee.';
      } else {
        errorMessage = 'An unexpected server error occurred.';
      }
      print('DioException: ${e.message}');
      print('Response data: ${e.response?.data}');
      print('Response status: ${e.response?.statusCode}');
      throw Failure(message: errorMessage);
    } catch (e) {
      print('Unexpected error: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<UserModel>> getEmployees({required String stationId}) async {
    try {
      final response = await _dioClient.dio.get(
        '/station/$stationId/employees/',
      );
      final List<dynamic> results = response.data['results'] as List;
      return results.map((json) => UserModel.fromJson(json)).toList();
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch employees.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<UserModel> updateEmployee({
    required String employeeId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _dioClient.dio.put(
        '/accounts/$employeeId/update/',
        data: data,
      );

      return UserModel.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to update employee.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<UserModel> uploadProfilePicture({
    required String employeeId,
    required File imageFile,
  }) async {
    try {
      final formData = dio.FormData.fromMap({
        'profile_picture': await dio.MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dioClient.dio.put(
        '/accounts/$employeeId/update-picture/',
        data: formData,
      );
      return UserModel.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to upload picture.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
