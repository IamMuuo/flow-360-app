import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/sales/repository/sales_report_repository.dart';
import 'package:flow_360/features/sales/models/sales_report_model.dart';

class SalesReportController extends GetxController {
  final SalesReportRepository _repository = GetIt.instance<SalesReportRepository>();
  
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  
  // Report data
  var salesReportSummary = Rxn<SalesReportSummary>();
  var dailyReports = <DailySalesReport>[].obs;
  var employeeReports = <EmployeeSalesReport>[].obs;
  var fuelTypeReports = <FuelTypeSalesReport>[].obs;
  
  // Filter options
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();
  var selectedEmployeeId = Rxn<String>();
  var selectedFuelType = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    // Set default date range to last 30 days
    selectedEndDate.value = DateTime.now();
    selectedStartDate.value = DateTime.now().subtract(const Duration(days: 30));
    fetchSalesReport();
  }

  Future<void> fetchSalesReport() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      print('Fetching sales report with filters:');
      print('Start date: ${selectedStartDate.value}');
      print('End date: ${selectedEndDate.value}');
      print('Employee ID: ${selectedEmployeeId.value}');
      print('Fuel type: ${selectedFuelType.value}');
      
      final summary = await _repository.getSalesReport(
        startDate: selectedStartDate.value,
        endDate: selectedEndDate.value,
        employeeId: selectedEmployeeId.value,
        fuelType: selectedFuelType.value,
      );
      
      print('Sales report summary received:');
      print('Total revenue: ${summary.totalRevenue}');
      print('Total litres: ${summary.totalLitres}');
      print('Total sales: ${summary.totalSales}');
      print('Total employees: ${summary.totalEmployees}');
      print('Daily reports count: ${summary.dailyReports.length}');
      print('Employee reports count: ${summary.employeeReports.length}');
      print('Fuel type reports count: ${summary.fuelTypeReports.length}');
      
      salesReportSummary.value = summary;
      dailyReports.value = summary.dailyReports;
      employeeReports.value = summary.employeeReports;
      fuelTypeReports.value = summary.fuelTypeReports;
      
      successMessage.value = 'Sales report loaded successfully!';
    } catch (e) {
      print('Error fetching sales report: $e');
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDailySalesReport() async {
    try {
      final reports = await _repository.getDailySalesReport(
        startDate: selectedStartDate.value,
        endDate: selectedEndDate.value,
      );
      dailyReports.value = reports;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    }
  }

  Future<void> fetchEmployeeSalesReport() async {
    try {
      final reports = await _repository.getEmployeeSalesReport(
        startDate: selectedStartDate.value,
        endDate: selectedEndDate.value,
      );
      employeeReports.value = reports;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    }
  }

  Future<void> fetchFuelTypeSalesReport() async {
    try {
      final reports = await _repository.getFuelTypeSalesReport(
        startDate: selectedStartDate.value,
        endDate: selectedEndDate.value,
      );
      fuelTypeReports.value = reports;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    }
  }

  void setDateRange(DateTime? startDate, DateTime? endDate) {
    selectedStartDate.value = startDate;
    selectedEndDate.value = endDate;
    fetchSalesReport();
  }

  void setEmployeeFilter(String? employeeId) {
    selectedEmployeeId.value = employeeId;
    fetchSalesReport();
  }

  void setFuelTypeFilter(String? fuelType) {
    selectedFuelType.value = fuelType;
    fetchSalesReport();
  }

  void clearFilters() {
    selectedEmployeeId.value = null;
    selectedFuelType.value = null;
    fetchSalesReport();
  }

  void clearSuccess() {
    successMessage.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }

  // Helper methods for statistics
  double get totalRevenue => salesReportSummary.value?.totalRevenue ?? 0.0;
  double get totalLitres => salesReportSummary.value?.totalLitres ?? 0.0;
  int get totalSales => salesReportSummary.value?.totalSales ?? 0;
  int get totalEmployees => salesReportSummary.value?.totalEmployees ?? 0;
  
  double get averageSaleAmount => totalSales > 0 ? totalRevenue / totalSales : 0.0;
  double get averageLitresPerSale => totalSales > 0 ? totalLitres / totalSales : 0.0;
}
