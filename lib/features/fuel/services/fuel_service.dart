import 'package:dio/dio.dart';
import 'package:flow_360/core/network/dio_client.dart';

class FuelService {
  final DioClient _dioClient;

  FuelService({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  Future<List<Map<String, dynamic>>> getFuels() async {
    try {
      final response = await _dioClient.dio.get('/station/fuels/');
      
      if (response.statusCode == 200) {
        // Handle both paginated and non-paginated responses
        List<dynamic> results;
        if (response.data is Map && response.data.containsKey('results')) {
          results = response.data['results'];
        } else if (response.data is List) {
          results = response.data;
        } else {
          results = [];
        }
        
        // Convert to the expected format for the dropdown
        return results.map<Map<String, dynamic>>((fuel) {
          return {
            'id': fuel['id']?.toString(),
            'name': fuel['name']?.toString() ?? 'Unknown',
            'color_hex': fuel['color_hex']?.toString() ?? '#808080',
            'kra_code': fuel['kra_code']?.toString() ?? '',
          };
        }).toList();
      } else {
        throw Exception('Failed to load fuel types');
      }
    } catch (e) {
      print('FuelService Error: ${e.toString()}');
      throw Exception('Failed to load fuel types: ${e.toString()}');
    }
  }
}
