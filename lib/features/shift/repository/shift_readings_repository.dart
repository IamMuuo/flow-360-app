// lib/features/shift/repository/station_shift_repository.dart

import 'package:dio/dio.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';
import 'package:flow_360/features/shift/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';

class ShiftReadingsRepository {
  final DioClient _dioClient = DioClient();

  // Station Shift Operations
  Future<List<StationShiftModel>> getStationShifts() async {
    try {
      final response = await _dioClient.dio.get('/station/shifts/');
      final List<dynamic> data = response.data['results'] ?? response.data;
      return data.map((json) => StationShiftModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to load station shifts: $e');
    }
  }

  Future<StationShiftModel> createStationShift({
    required String stationId,
    required String shiftDate,
    required String startTime,
    String? notes,
  }) async {
    try {
      final response = await _dioClient.dio.post('/station/shifts/create/', data: {
        'station': stationId,
        'shift_date': shiftDate,
        'start_time': startTime,
        'notes': notes,
      });
      return StationShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to create station shift: $e');
    }
  }

  Future<StationShiftModel> endStationShift({
    required String shiftId,
    required String endTime,
    String? notes,
  }) async {
    try {
      final response = await _dioClient.dio.patch('/station/shifts/$shiftId/', data: {
        'end_time': endTime,
        'status': 'COMPLETED',
        'notes': notes,
      });
      
      return StationShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to end station shift: $e');
    }
  }

  Future<StationShiftModel> getStationShift(String shiftId) async {
    try {
      final response = await _dioClient.dio.get('/station/shifts/$shiftId/');
      return StationShiftModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to load station shift: $e');
    }
  }

  // Tank Reading Operations
  Future<List<TankReadingModel>> getTankReadings(String shiftId) async {
    try {
      final response = await _dioClient.dio.get('/station/shifts/$shiftId/tank-readings/');
      final List<dynamic> data = response.data['results'] ?? response.data;
      return data.map((json) => TankReadingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to load tank readings: $e');
    }
  }

  Future<TankReadingModel> createTankReading({
    required String shiftId,
    required String tankId,
    required String readingType,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      final response = await _dioClient.dio.post('/station/shifts/$shiftId/tank-readings/create/', data: {
        'tank': tankId,
        'reading_type': readingType,
        'manual_reading_litres': manualReading,
        'reconciliation_notes': reconciliationNotes,
      });
      return TankReadingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to create tank reading: $e');
    }
  }

  Future<TankReadingModel> updateTankReading({
    required String shiftId,
    required String readingId,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      final response = await _dioClient.dio.patch('/station/shifts/$shiftId/tank-readings/$readingId/', data: {
        'manual_reading_litres': manualReading,
        'reconciliation_notes': reconciliationNotes,
      });
      return TankReadingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to update tank reading: $e');
    }
  }

  // Nozzle Reading Operations
  Future<List<NozzleReadingModel>> getNozzleReadings(String shiftId) async {
    try {
      final response = await _dioClient.dio.get('/station/shifts/$shiftId/nozzle-readings/');
      final List<dynamic> data = response.data['results'] ?? response.data;
      return data.map((json) => NozzleReadingModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to load nozzle readings: $e');
    }
  }

  Future<NozzleReadingModel> createNozzleReading({
    required String shiftId,
    required String nozzleId,
    required String readingType,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      final response = await _dioClient.dio.post('/station/shifts/$shiftId/nozzle-readings/create/', data: {
        'nozzle': nozzleId,
        'reading_type': readingType,
        'manual_reading': manualReading,
        'reconciliation_notes': reconciliationNotes,
      });
      return NozzleReadingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to create nozzle reading: $e');
    }
  }

  Future<NozzleReadingModel> updateNozzleReading({
    required String shiftId,
    required String readingId,
    required double manualReading,
    String? reconciliationNotes,
  }) async {
    try {
      final response = await _dioClient.dio.patch('/station/shifts/$shiftId/nozzle-readings/$readingId/', data: {
        'manual_reading': manualReading,
        'reconciliation_notes': reconciliationNotes,
      });
      return NozzleReadingModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to update nozzle reading: $e');
    }
  }

  // Get available tanks and nozzles for the station
  Future<List<TankModel>> getStationTanks(String stationId) async {
    try {
      final response = await _dioClient.dio.get('/station/$stationId/tanks/');
      final List<dynamic> data = response.data['results'] ?? response.data;
      return data.map((json) => TankModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to load station tanks: $e');
    }
  }

  Future<List<ShiftNozzleModel>> getStationNozzles(String stationId) async {
    try {
      final response = await _dioClient.dio.get('/station/$stationId/nozzles/');
      final List<dynamic> data = response.data['results'] ?? response.data;
      return data.map((json) => ShiftNozzleModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to load station nozzles: $e');
    }
  }

  // Reconciliation operations
  Future<Map<String, dynamic>> reconcileShiftReadings(String shiftId) async {
    try {
      final response = await _dioClient.dio.post('/station/shifts/$shiftId/reconcile/');
      return response.data;
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to reconcile shift readings: $e');
    }
  }

  Future<Map<String, dynamic>> getShiftSummary(String shiftId) async {
    try {
      final response = await _dioClient.dio.get('/station/shifts/$shiftId/summary/');
      return response.data;
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to get shift summary: $e');
    }
  }

  Future<Map<String, dynamic>> getVarianceSummary(String shiftId) async {
    try {
      final response = await _dioClient.dio.get('/station/shifts/$shiftId/variance-summary/');
      return response.data;
    } on DioException catch (e) {
      throw Failure(message: _handleDioError(e));
    } catch (e) {
      throw Failure(message: 'Failed to get variance summary: $e');
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      if (data.containsKey('detail')) {
        return data['detail'];
      }
      if (data.containsKey('message')) {
        return data['message'];
      }
      if (data.containsKey('error')) {
        return data['error'];
      }
    }
    return e.message ?? 'Network error occurred';
  }
}
