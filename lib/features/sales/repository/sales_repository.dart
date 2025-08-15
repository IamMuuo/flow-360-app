import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/sales/models/sale_model.dart';

class SalesRepository {
  final DioClient _dioClient;

  SalesRepository() : _dioClient = GetIt.instance<DioClient>();

  Future<List<SaleModel>> getSales() async {
    try {
      final response = await _dioClient.dio.get('/sales/');
      final List<dynamic> results = response.data['results'] as List;
      return results.map((json) => SaleModel.fromJson(json)).toList();
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch sales.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<SaleModel> createSale({
    required String nozzleId,
    required double totalAmount,
    required String paymentMode,
    int? odometerReading,
    String? carRegistrationNumber,
    String? kraPin,
    String? customerName,
    String? externalTransactionId,
  }) async {
    print('here');
    try {
      final data = {
        'nozzle': nozzleId,
        'total_amount': totalAmount,
        'payment_mode': paymentMode,
        if (odometerReading != null) 'odometer_reading': odometerReading,
        if (carRegistrationNumber != null) 'car_resistration_number': carRegistrationNumber,
        if (kraPin != null) 'kra_pin': kraPin,
        if (customerName != null) 'customer_name': customerName,
        if (externalTransactionId != null) 'external_transaction_id': externalTransactionId,
      };

      print('Creating sale with data: $data');
      final response = await _dioClient.dio.post('/sales/create/', data: data);
      print('Sale creation response: ${response.data}');
      print('Response status: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data keys: ${response.data.keys}');
      return SaleModel.fromJson(response.data);
    } on dio.DioException catch (e) {
      print('DioException in createSale: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      
      String errorMessage;
      if (e.response?.data is Map) {
        errorMessage = e.response?.data['detail'] ?? 'Failed to create sale.';
      } else {
        errorMessage = 'An unexpected server error occurred.';
      }
      throw Failure(message: errorMessage);
    } catch (e) {
      rethrow;
      print('Unexpected error in createSale: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<Map<String, dynamic>> getAvailableNozzles() async {
    try {
      final response = await _dioClient.dio.get('/sales/employee/nozzles/');
      return response.data;
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch available nozzles.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<SaleValidationModel> validateSale({
    required String nozzleId,
    required double totalAmount,
  }) async {
    try {
      final data = {
        'nozzle_id': nozzleId,
        'total_amount': totalAmount,
      };

      final response = await _dioClient.dio.post('/sales/employee/validate/', data: data);
      return SaleValidationModel.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to validate sale.',
      );
    } catch (e) {
      rethrow;
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
