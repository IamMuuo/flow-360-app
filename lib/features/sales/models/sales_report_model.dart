import 'package:json_annotation/json_annotation.dart';

part 'sales_report_model.g.dart';

@JsonSerializable()
class SalesReportModel {
  final String id;
  @JsonKey(name: 'employee_name') final String employeeName;
  @JsonKey(name: 'employee_id') final String employeeId;
  @JsonKey(name: 'fuel_type') final String fuelType;
  @JsonKey(name: 'total_amount') final double totalAmount;
  @JsonKey(name: 'litres_sold') final double litresSold;
  @JsonKey(name: 'price_per_litre') final double pricePerLitre;
  @JsonKey(name: 'payment_mode') final String paymentMode;
  @JsonKey(name: 'sold_at') final DateTime soldAt;
  @JsonKey(name: 'nozzle_number') final String nozzleNumber;
  @JsonKey(name: 'dispenser_name') final String dispenserName;

  SalesReportModel({
    required this.id,
    required this.employeeName,
    required this.employeeId,
    required this.fuelType,
    required this.totalAmount,
    required this.litresSold,
    required this.pricePerLitre,
    required this.paymentMode,
    required this.soldAt,
    required this.nozzleNumber,
    required this.dispenserName,
  });

  factory SalesReportModel.fromJson(Map<String, dynamic> json) => _$SalesReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$SalesReportModelToJson(this);
}

@JsonSerializable()
class DailySalesReport {
  final String date;
  @JsonKey(name: 'total_amount') final double totalAmount;
  @JsonKey(name: 'total_litres') final double totalLitres;
  @JsonKey(name: 'total_sales') final int totalSales;
  final List<SalesReportModel> sales;

  DailySalesReport({
    required this.date,
    required this.totalAmount,
    required this.totalLitres,
    required this.totalSales,
    required this.sales,
  });

  factory DailySalesReport.fromJson(Map<String, dynamic> json) => _$DailySalesReportFromJson(json);
  Map<String, dynamic> toJson() => _$DailySalesReportToJson(this);
}

@JsonSerializable()
class EmployeeSalesReport {
  @JsonKey(name: 'employee_id') final String employeeId;
  @JsonKey(name: 'employee_name') final String employeeName;
  @JsonKey(name: 'total_amount') final double totalAmount;
  @JsonKey(name: 'total_litres') final double totalLitres;
  @JsonKey(name: 'total_sales') final int totalSales;
  final List<SalesReportModel> sales;

  EmployeeSalesReport({
    required this.employeeId,
    required this.employeeName,
    required this.totalAmount,
    required this.totalLitres,
    required this.totalSales,
    required this.sales,
  });

  factory EmployeeSalesReport.fromJson(Map<String, dynamic> json) => _$EmployeeSalesReportFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeSalesReportToJson(this);
}

@JsonSerializable()
class FuelTypeSalesReport {
  @JsonKey(name: 'fuel_type') final String fuelType;
  @JsonKey(name: 'total_amount') final double totalAmount;
  @JsonKey(name: 'total_litres') final double totalLitres;
  @JsonKey(name: 'total_sales') final int totalSales;
  @JsonKey(name: 'average_price') final double averagePrice;
  final List<SalesReportModel> sales;

  FuelTypeSalesReport({
    required this.fuelType,
    required this.totalAmount,
    required this.totalLitres,
    required this.totalSales,
    required this.averagePrice,
    required this.sales,
  });

  factory FuelTypeSalesReport.fromJson(Map<String, dynamic> json) => _$FuelTypeSalesReportFromJson(json);
  Map<String, dynamic> toJson() => _$FuelTypeSalesReportToJson(this);
}

@JsonSerializable()
class SalesReportSummary {
  @JsonKey(name: 'total_revenue') final double totalRevenue;
  @JsonKey(name: 'total_litres') final double totalLitres;
  @JsonKey(name: 'total_sales') final int totalSales;
  @JsonKey(name: 'total_employees') final int totalEmployees;
  @JsonKey(name: 'daily_reports') final List<DailySalesReport> dailyReports;
  @JsonKey(name: 'employee_reports') final List<EmployeeSalesReport> employeeReports;
  @JsonKey(name: 'fuel_type_reports') final List<FuelTypeSalesReport> fuelTypeReports;

  SalesReportSummary({
    required this.totalRevenue,
    required this.totalLitres,
    required this.totalSales,
    required this.totalEmployees,
    required this.dailyReports,
    required this.employeeReports,
    required this.fuelTypeReports,
  });

  factory SalesReportSummary.fromJson(Map<String, dynamic> json) => _$SalesReportSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SalesReportSummaryToJson(this);
}
