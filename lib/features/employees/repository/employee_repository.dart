import 'dart:io';

import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class EmployeeRepository {
  final DioClient _dioClient;

  EmployeeRepository() : _dioClient = GetIt.instance<DioClient>();

  Future<UserModel> createEmployee({required Map<String, dynamic> data}) async {
    data.addAll({"password1": data["password"], "password2": data["password"]});
    try {
      final response = await _dioClient.dio.post(
        '/auth/registration/',
        data: data,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to create employee.',
      );
    } catch (e) {
      rethrow;
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
    } on DioException catch (e) {
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
    } on DioException catch (e) {
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
      final formData = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(imageFile.path),
      });

      final response = await _dioClient.dio.put(
        '/accounts/$employeeId/update-picture/',
        data: formData,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to upload picture.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
