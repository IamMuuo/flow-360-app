import 'package:dio/dio.dart' as dio;
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/features/sales/models/sales_report_model.dart';

class SalesReportRepository {
  final DioClient _dioClient;

  SalesReportRepository() : _dioClient = DioClient();

  Future<SalesReportSummary> getSalesReport({
    DateTime? startDate,
    DateTime? endDate,
    String? employeeId,
    String? fuelType,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }
      if (employeeId != null) {
        queryParams['employee_id'] = employeeId;
      }
      if (fuelType != null) {
        queryParams['fuel_type'] = fuelType;
      }

      print('Making API call to /sales/reports/ with params: $queryParams');

      final response = await _dioClient.dio.get(
        '/sales/reports/',
        queryParameters: queryParams,
      );

      print('Response status: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');
      print('Response data keys: ${response.data.keys}');

      print('Response data sample: ${response.data.toString().substring(0, 500)}...');
      return SalesReportSummary.fromJson(response.data);
    } on dio.DioException catch (e) {
      print('DioException in getSalesReport: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch sales report.',
      );
    } catch (e) {
      print('Unexpected error in getSalesReport: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<DailySalesReport>> getDailySalesReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }

      final response = await _dioClient.dio.get(
        '/sales/reports/daily/',
        queryParameters: queryParams,
      );

      final List<dynamic> results = response.data['results'] as List;
      return results.map((json) => DailySalesReport.fromJson(json)).toList();
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch daily sales report.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<EmployeeSalesReport>> getEmployeeSalesReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }

      final response = await _dioClient.dio.get(
        '/sales/reports/employees/',
        queryParameters: queryParams,
      );

      final List<dynamic> results = response.data['results'] as List;
      return results.map((json) => EmployeeSalesReport.fromJson(json)).toList();
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch employee sales report.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<List<FuelTypeSalesReport>> getFuelTypeSalesReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }

      final response = await _dioClient.dio.get(
        '/sales/reports/fuel-types/',
        queryParameters: queryParams,
      );

      final List<dynamic> results = response.data['results'] as List;
      return results.map((json) => FuelTypeSalesReport.fromJson(json)).toList();
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['detail'] ?? 'Failed to fetch fuel type sales report.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
