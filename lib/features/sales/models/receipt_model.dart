import 'package:json_annotation/json_annotation.dart';

part 'receipt_model.g.dart';

// Helper methods for parsing string to double (following project pattern)
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

double? _parseDoubleNullable(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    if (value.isEmpty || value == 'null') return null;
    return int.tryParse(value);
  }
  return null;
}

@JsonSerializable()
class ReceiptModel {
  // Header Information
  @JsonKey(name: 'receipt_number')
  final String receiptNumber;
  @JsonKey(name: 'sale_id')
  final String saleId;
  final String date;
  final String time;
  
  // Organization Details
  @JsonKey(name: 'organization_name')
  final String organizationName;
  @JsonKey(name: 'organization_address')
  final String organizationAddress;
  @JsonKey(name: 'organization_phone')
  final String organizationPhone;
  @JsonKey(name: 'organization_email')
  final String organizationEmail;
  @JsonKey(name: 'kra_pin')
  final String kraPin;
  @JsonKey(name: 'registration_number')
  final String registrationNumber;
  
  // Station Details
  @JsonKey(name: 'station_name')
  final String stationName;
  @JsonKey(name: 'station_location')
  final String stationLocation;
  @JsonKey(name: 'station_city')
  final String stationCity;
  @JsonKey(name: 'station_county')
  final String stationCounty;
  
  // Sale Details
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @JsonKey(name: 'fuel_type_display')
  final String fuelTypeDisplay;
  @JsonKey(name: 'nozzle_number', fromJson: _parseInt)
  final int nozzleNumber;
  @JsonKey(name: 'dispenser_name')
  final String dispenserName;
  @JsonKey(name: 'unit_price', fromJson: _parseDouble)
  final double unitPrice;
  @JsonKey(name: 'litres_sold', fromJson: _parseDouble)
  final double litresSold;
  @JsonKey(name: 'total_amount', fromJson: _parseDouble)
  final double totalAmount;
  @JsonKey(name: 'payment_mode')
  final String paymentMode;
  @JsonKey(name: 'payment_mode_display')
  final String paymentModeDisplay;
  
  // VAT Breakdown
  @JsonKey(name: 'taxable_amount', fromJson: _parseDouble)
  final double taxableAmount;
  @JsonKey(name: 'vat_amount', fromJson: _parseDouble)
  final double vatAmount;
  @JsonKey(name: 'vat_rate', fromJson: _parseDouble)
  final double vatRate;
  
  // Customer Details
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_kra_pin')
  final String customerKraPin;
  @JsonKey(name: 'car_registration')
  final String carRegistration;
  @JsonKey(name: 'odometer_reading', fromJson: _parseIntNullable)
  final int? odometerReading;
  
  // Employee Details
  @JsonKey(name: 'employee_name')
  final String employeeName;
  @JsonKey(name: 'employee_id', fromJson: _parseInt)
  final int employeeId;
  
  // Shift Details
  @JsonKey(name: 'shift_id')
  final String shiftId;
  @JsonKey(name: 'shift_started_at')
  final String shiftStartedAt;
  
  // External Transaction Details
  @JsonKey(name: 'external_transaction_id')
  final String externalTransactionId;
  
  // KRA VSCU Details
  @JsonKey(name: 'kra_invoice_number')
  final String kraInvoiceNumber;
  @JsonKey(name: 'kra_trn')
  final String kraTrn;
  @JsonKey(name: 'kra_device_serial')
  final String kraDeviceSerial;
  @JsonKey(name: 'kra_branch_id')
  final String kraBranchId;
  
  // Receipt Formatting
  final String currency;
  @JsonKey(name: 'currency_symbol')
  final String currencySymbol;

  ReceiptModel({
    required this.receiptNumber,
    required this.saleId,
    required this.date,
    required this.time,
    required this.organizationName,
    required this.organizationAddress,
    required this.organizationPhone,
    required this.organizationEmail,
    required this.kraPin,
    required this.registrationNumber,
    required this.stationName,
    required this.stationLocation,
    required this.stationCity,
    required this.stationCounty,
    required this.fuelType,
    required this.fuelTypeDisplay,
    required this.nozzleNumber,
    required this.dispenserName,
    required this.unitPrice,
    required this.litresSold,
    required this.totalAmount,
    required this.paymentMode,
    required this.paymentModeDisplay,
    required this.taxableAmount,
    required this.vatAmount,
    required this.vatRate,
    required this.customerName,
    required this.customerKraPin,
    required this.carRegistration,
    this.odometerReading,
    required this.employeeName,
    required this.employeeId,
    required this.shiftId,
    required this.shiftStartedAt,
    required this.externalTransactionId,
    required this.kraInvoiceNumber,
    required this.kraTrn,
    required this.kraDeviceSerial,
    required this.kraBranchId,
    required this.currency,
    required this.currencySymbol,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) => _$ReceiptModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptModelToJson(this);
}

@JsonSerializable()
class ReceiptPrintResponse {
  final bool success;
  final String message;
  @JsonKey(name: 'receipt_content')
  final String? receiptContent;
  @JsonKey(name: 'receipt_number')
  final String? receiptNumber;
  @JsonKey(name: 'printer_type')
  final String? printerType;

  ReceiptPrintResponse({
    required this.success,
    required this.message,
    this.receiptContent,
    this.receiptNumber,
    this.printerType,
  });

  factory ReceiptPrintResponse.fromJson(Map<String, dynamic> json) => _$ReceiptPrintResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptPrintResponseToJson(this);
}

@JsonSerializable()
class ReceiptPdfUrlResponse {
  final bool success;
  @JsonKey(name: 'qr_scan_url')
  final String qrScanUrl;
  @JsonKey(name: 'qr_data')
  final Map<String, dynamic> qrData;
  @JsonKey(name: 'receipt_number')
  final String receiptNumber;
  @JsonKey(name: 'expires_in')
  final String expiresIn;

  ReceiptPdfUrlResponse({
    required this.success,
    required this.qrScanUrl,
    required this.qrData,
    required this.receiptNumber,
    required this.expiresIn,
  });

  factory ReceiptPdfUrlResponse.fromJson(Map<String, dynamic> json) => _$ReceiptPdfUrlResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ReceiptPdfUrlResponseToJson(this);
}

@JsonSerializable()
class RecentReceiptsResponse {
  final bool success;
  final List<ReceiptModel> receipts;
  final int count;
  @JsonKey(name: 'date_range')
  final Map<String, String> dateRange;

  RecentReceiptsResponse({
    required this.success,
    required this.receipts,
    required this.count,
    required this.dateRange,
  });

  factory RecentReceiptsResponse.fromJson(Map<String, dynamic> json) => _$RecentReceiptsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RecentReceiptsResponseToJson(this);
}
