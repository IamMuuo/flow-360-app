import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/sales/repository/sales_repository.dart';
import 'package:flow_360/features/sales/models/sale_model.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';

class SalesController extends GetxController {
  final SalesRepository _repository = GetIt.instance<SalesRepository>();
  
  var sales = <SaleModel>[].obs;
  var availableNozzles = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var shiftId = ''.obs;
  var stationName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSales();
    fetchAvailableNozzles();
  }

  Future<void> fetchSales() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final salesList = await _repository.getSales();
      sales.value = salesList;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Refresh sales data - used for pull-to-refresh
  Future<void> loadSales() async {
    await fetchSales();
  }

  Future<void> fetchAvailableNozzles() async {
    try {
      final data = await _repository.getAvailableNozzles();
      availableNozzles.value = List<Map<String, dynamic>>.from(data['available_nozzles']);
      shiftId.value = data['shift_id'] ?? '';
      stationName.value = data['station_name'] ?? '';
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    }
  }

  Future<void> createSale({
    required String nozzleId,
    required double totalAmount,
    required String paymentMode,
    int? odometerReading,
    String? carRegistrationNumber,
    String? kraPin,
    String? externalTransactionId,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';
    
    try {
      // First validate the sale
      print('Validating sale...');
      final validation = await _repository.validateSale(
        nozzleId: nozzleId,
        totalAmount: totalAmount,
      );
      
      print('Validation result: ${validation.valid}');
      
      if (!validation.valid) {
        throw Exception('Sale validation failed');
      }
      
      print('Validation successful, creating sale...');
      // Create the sale
      final sale = await _repository.createSale(
        nozzleId: nozzleId,
        totalAmount: totalAmount,
        paymentMode: paymentMode,
        odometerReading: odometerReading,
        carRegistrationNumber: carRegistrationNumber,
        kraPin: kraPin,
        externalTransactionId: externalTransactionId,
      );
      
      sales.add(sale);
      successMessage.value = 'Sale created successfully!';
      
      // Refresh available nozzles
      await fetchAvailableNozzles();
      
      // Refresh tank data to reflect the fuel consumption
      try {
        final tankController = Get.find<TankController>();
        await tankController.refreshTanks();
        print('Tank data refreshed after sale');
      } catch (e) {
        print('Could not refresh tank data: $e');
      }
    } catch (e) {
      rethrow;
      print('Error in createSale: $e');
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<SaleValidationModel?> validateSale({
    required String nozzleId,
    required double totalAmount,
  }) async {
    try {
      return await _repository.validateSale(
        nozzleId: nozzleId,
        totalAmount: totalAmount,
      );
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
      return null;
    }
  }

  void clearSuccess() {
    successMessage.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }
}
