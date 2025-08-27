// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesReportModel _$SalesReportModelFromJson(Map<String, dynamic> json) =>
    SalesReportModel(
      id: json['id'] as String,
      employeeName: json['employee_name'] as String,
      employeeId: json['employee_id'] as String,
      fuelType: json['fuel_type'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      litresSold: (json['litres_sold'] as num).toDouble(),
      pricePerLitre: (json['price_per_litre'] as num).toDouble(),
      paymentMode: json['payment_mode'] as String,
      soldAt: DateTime.parse(json['sold_at'] as String),
      nozzleNumber: json['nozzle_number'] as String,
      dispenserName: json['dispenser_name'] as String,
    );

Map<String, dynamic> _$SalesReportModelToJson(SalesReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employee_name': instance.employeeName,
      'employee_id': instance.employeeId,
      'fuel_type': instance.fuelType,
      'total_amount': instance.totalAmount,
      'litres_sold': instance.litresSold,
      'price_per_litre': instance.pricePerLitre,
      'payment_mode': instance.paymentMode,
      'sold_at': instance.soldAt.toIso8601String(),
      'nozzle_number': instance.nozzleNumber,
      'dispenser_name': instance.dispenserName,
    };

DailySalesReport _$DailySalesReportFromJson(Map<String, dynamic> json) =>
    DailySalesReport(
      date: json['date'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      totalLitres: (json['total_litres'] as num).toDouble(),
      totalSales: (json['total_sales'] as num).toInt(),
      sales: (json['sales'] as List<dynamic>)
          .map((e) => SalesReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailySalesReportToJson(DailySalesReport instance) =>
    <String, dynamic>{
      'date': instance.date,
      'total_amount': instance.totalAmount,
      'total_litres': instance.totalLitres,
      'total_sales': instance.totalSales,
      'sales': instance.sales,
    };

EmployeeSalesReport _$EmployeeSalesReportFromJson(Map<String, dynamic> json) =>
    EmployeeSalesReport(
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      totalLitres: (json['total_litres'] as num).toDouble(),
      totalSales: (json['total_sales'] as num).toInt(),
      sales: (json['sales'] as List<dynamic>)
          .map((e) => SalesReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeSalesReportToJson(
        EmployeeSalesReport instance) =>
    <String, dynamic>{
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'total_amount': instance.totalAmount,
      'total_litres': instance.totalLitres,
      'total_sales': instance.totalSales,
      'sales': instance.sales,
    };

FuelTypeSalesReport _$FuelTypeSalesReportFromJson(Map<String, dynamic> json) =>
    FuelTypeSalesReport(
      fuelType: json['fuel_type'] as String?,
      totalAmount: (json['total_amount'] as num).toDouble(),
      totalLitres: (json['total_litres'] as num).toDouble(),
      totalSales: (json['total_sales'] as num).toInt(),
      averagePrice: (json['average_price'] as num).toDouble(),
      sales: (json['sales'] as List<dynamic>)
          .map((e) => SalesReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FuelTypeSalesReportToJson(
        FuelTypeSalesReport instance) =>
    <String, dynamic>{
      'fuel_type': instance.fuelType,
      'total_amount': instance.totalAmount,
      'total_litres': instance.totalLitres,
      'total_sales': instance.totalSales,
      'average_price': instance.averagePrice,
      'sales': instance.sales,
    };

SalesReportSummary _$SalesReportSummaryFromJson(Map<String, dynamic> json) =>
    SalesReportSummary(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalLitres: (json['total_litres'] as num).toDouble(),
      totalSales: (json['total_sales'] as num).toInt(),
      totalEmployees: (json['total_employees'] as num).toInt(),
      dailyReports: (json['daily_reports'] as List<dynamic>)
          .map((e) => DailySalesReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      employeeReports: (json['employee_reports'] as List<dynamic>)
          .map((e) => EmployeeSalesReport.fromJson(e as Map<String, dynamic>))
          .toList(),
      fuelTypeReports: (json['fuel_type_reports'] as List<dynamic>)
          .map((e) => FuelTypeSalesReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SalesReportSummaryToJson(SalesReportSummary instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'total_litres': instance.totalLitres,
      'total_sales': instance.totalSales,
      'total_employees': instance.totalEmployees,
      'daily_reports': instance.dailyReports,
      'employee_reports': instance.employeeReports,
      'fuel_type_reports': instance.fuelTypeReports,
    };
