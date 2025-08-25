import 'package:dio/dio.dart';
import 'package:flow_360/core/network/dio_client.dart';

class FuelService {
  final DioClient _dioClient;

  FuelService({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<Map<String, dynamic>>> getFuels() async {
    try {
      final response = await _dioClient.dio.get('/station/fuels/');
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? response.data;
        return results.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load fuel types');
      }
    } catch (e) {
      throw Exception('Failed to load fuel types: ${e.toString()}');
    }
  }
}
