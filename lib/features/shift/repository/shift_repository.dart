// lib/features/shift/repository/shift_repository.dart

import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/shift/models/shift_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class ShiftRepository {
  final DioClient _dioClient;

  ShiftRepository() : _dioClient = GetIt.instance<DioClient>();

  Future<ShiftModel> startShift() async {
    try {
      final response = await _dioClient.dio.post('/shift/create/', data: {
        'started_at': DateTime.now().toIso8601String(),
      });
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to start shift.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ShiftModel> endShift(String shiftId) async {
    try {
      final response = await _dioClient.dio.patch(
        '/shift/$shiftId/update/',
        data: {
          'ended_at': DateTime.now().toIso8601String(),
          'is_active': false,
        },
      );
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to end shift.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<ShiftModel>> getShifts() async {
    try {
      final response = await _dioClient.dio.get('/shift/list/');
      final List<dynamic> data = response.data;
      return data.map((json) => ShiftModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch shifts.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ShiftModel?> getCurrentShift() async {
    try {
      final response = await _dioClient.dio.get('/shift/current/');
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // No active shift found
        return null;
      }
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch current shift.',
      );
    } catch (e) {
      return null;
    }
  }

  Future<ShiftModel> getShiftById(String shiftId) async {
    try {
      final response = await _dioClient.dio.get('/shift/$shiftId/');
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch shift.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  // Employee shift management methods
  Future<List<ShiftModel>> getEmployeeShifts() async {
    try {
      final response = await _dioClient.dio.get('/shift/list-employee/');
      
      // Handle paginated response
      if (response.data is Map<String, dynamic> && response.data.containsKey('results')) {
        final List<dynamic> data = response.data['results'];
        return data.map((json) => ShiftModel.fromJson(json)).toList();
      } else {
        // Handle non-paginated response (fallback)
        final List<dynamic> data = response.data;
        return data.map((json) => ShiftModel.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch employee shifts.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ShiftModel> createEmployeeShift({
    required String employeeId,
    required DateTime startTime,
  }) async {
    try {
      final response = await _dioClient.dio.post('/shift/create-employee/', data: {
        'employee_id': employeeId,
        'started_at': startTime.toIso8601String(),
      });
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to create employee shift.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ShiftModel> endEmployeeShift(String shiftId) async {
    try {
      final response = await _dioClient.dio.patch(
        '/shift/$shiftId/end/',
        data: {
          'ended_at': DateTime.now().toIso8601String(),
        },
      );
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to end employee shift.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
