// lib/features/shift/repository/shift_repository.dart

import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/shift/models/shift_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

class ShiftRepository {
  final DioClient _dioClient;

  ShiftRepository() : _dioClient = GetIt.instance<DioClient>();

  Future<ShiftModel> createShift({required Map<String, dynamic> data}) async {
    try {
      // Corrected API endpoint
      final response = await _dioClient.dio.post('/shift/create/', data: data);
      return ShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to start shift.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  // ... (other methods remain the same)
}
