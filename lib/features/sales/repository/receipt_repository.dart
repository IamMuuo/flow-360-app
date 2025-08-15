import 'package:dio/dio.dart' as dio;
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/network/dio_client.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';

class ReceiptRepository {
  final DioClient _dioClient;

  ReceiptRepository() : _dioClient = GetIt.instance<DioClient>();

  Future<ReceiptModel> getSaleReceipt(String saleId) async {
    print('ReceiptRepository: Fetching receipt for sale ID: $saleId');
    try {
      final response = await _dioClient.dio.get('/sales/$saleId/receipt/');
      print('ReceiptRepository: Response received: ${response.statusCode}');
      print('ReceiptRepository: Response data: ${response.data}');
      return ReceiptModel.fromJson(response.data['receipt']);
    } on dio.DioException catch (e) {
      print('ReceiptRepository: DioException: ${e.message}');
      print('ReceiptRepository: Response status: ${e.response?.statusCode}');
      print('ReceiptRepository: Response data: ${e.response?.data}');
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to fetch receipt.',
      );
    } catch (e) {
      print('ReceiptRepository: Unexpected error: $e');
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<String> getSaleReceiptText(String saleId) async {
    try {
      final response = await _dioClient.dio.get('/sales/$saleId/receipt/text/');
      return response.data['receipt_text'];
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to fetch receipt text.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<String> getSaleReceiptHtml(String saleId) async {
    try {
      final response = await _dioClient.dio.get('/sales/$saleId/receipt/html/');
      return response.data;
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to fetch receipt HTML.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ReceiptPrintResponse> printSaleReceipt({
    required String saleId,
    required String printerType,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/sales/$saleId/receipt/print/',
        data: {'printer_type': printerType},
      );
      return ReceiptPrintResponse.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to print receipt.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ReceiptModel> getReceiptByNumber(String receiptNumber) async {
    try {
      final response = await _dioClient.dio.get('/sales/receipt/$receiptNumber/');
      return ReceiptModel.fromJson(response.data['receipt']);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to fetch receipt.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<RecentReceiptsResponse> getRecentReceipts({
    int days = 7,
    String? stationId,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'days': days,
        'limit': limit,
      };
      
      if (stationId != null) {
        queryParams['station_id'] = stationId;
      }

      final response = await _dioClient.dio.get(
        '/sales/receipts/recent/',
        queryParameters: queryParams,
      );
      return RecentReceiptsResponse.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to fetch recent receipts.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }

  Future<ReceiptPdfUrlResponse> getSaleReceiptPdfUrl(String saleId) async {
    try {
      final response = await _dioClient.dio.get('/sales/$saleId/receipt/pdf-url/');
      return ReceiptPdfUrlResponse.fromJson(response.data);
    } on dio.DioException catch (e) {
      throw Failure(
        message: e.response?.data['error'] ?? 'Failed to generate PDF URL.',
      );
    } catch (e) {
      throw Failure(message: 'An unexpected error occurred.');
    }
  }
}
