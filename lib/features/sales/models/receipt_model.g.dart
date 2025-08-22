// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptModel _$ReceiptModelFromJson(Map<String, dynamic> json) => ReceiptModel(
      receiptNumber: json['receipt_number'] as String,
      saleId: json['sale_id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      organizationName: json['organization_name'] as String,
      organizationAddress: json['organization_address'] as String,
      organizationPhone: json['organization_phone'] as String,
      organizationEmail: json['organization_email'] as String,
      kraPin: json['kra_pin'] as String,
      registrationNumber: json['registration_number'] as String,
      stationName: json['station_name'] as String,
      stationLocation: json['station_location'] as String,
      stationCity: json['station_city'] as String,
      stationCounty: json['station_county'] as String,
      fuelType: json['fuel_type'] as String,
      fuelTypeDisplay: json['fuel_type_display'] as String,
      nozzleNumber: _parseInt(json['nozzle_number']),
      dispenserName: json['dispenser_name'] as String,
      unitPrice: _parseDouble(json['unit_price']),
      litresSold: _parseDouble(json['litres_sold']),
      totalAmount: _parseDouble(json['total_amount']),
      paymentMode: json['payment_mode'] as String,
      paymentModeDisplay: json['payment_mode_display'] as String,
      taxableAmount: _parseDouble(json['taxable_amount']),
      vatAmount: _parseDouble(json['vat_amount']),
      vatRate: _parseDouble(json['vat_rate']),
      customerName: json['customer_name'] as String,
      customerKraPin: json['customer_kra_pin'] as String,
      carRegistration: json['car_registration'] as String,
      odometerReading: _parseIntNullable(json['odometer_reading']),
      employeeName: json['employee_name'] as String,
      employeeId: _parseInt(json['employee_id']),
      shiftId: json['shift_id'] as String,
      shiftStartedAt: json['shift_started_at'] as String,
      externalTransactionId: json['external_transaction_id'] as String,
      kraInvoiceNumber: json['kra_invoice_number'] as String,
      kraTrn: json['kra_trn'] as String,
      kraDeviceSerial: json['kra_device_serial'] as String,
      kraBranchId: json['kra_branch_id'] as String,
      mrcNo: json['mrc_no'] as String,
      sdcId: json['sdc_id'] as String,
      receiptNo: json['receipt_no'] as String,
      receiptSignature: json['receipt_signature'] as String,
      internalData: json['internal_data'] as String,
      totalReceiptNo: json['total_receipt_no'] as String,
      vsdcReceiptPbctDate: json['vsdc_receipt_pbct_date'] as String,
      currency: json['currency'] as String,
      currencySymbol: json['currency_symbol'] as String,
    );

Map<String, dynamic> _$ReceiptModelToJson(ReceiptModel instance) =>
    <String, dynamic>{
      'receipt_number': instance.receiptNumber,
      'sale_id': instance.saleId,
      'date': instance.date,
      'time': instance.time,
      'organization_name': instance.organizationName,
      'organization_address': instance.organizationAddress,
      'organization_phone': instance.organizationPhone,
      'organization_email': instance.organizationEmail,
      'kra_pin': instance.kraPin,
      'registration_number': instance.registrationNumber,
      'station_name': instance.stationName,
      'station_location': instance.stationLocation,
      'station_city': instance.stationCity,
      'station_county': instance.stationCounty,
      'fuel_type': instance.fuelType,
      'fuel_type_display': instance.fuelTypeDisplay,
      'nozzle_number': instance.nozzleNumber,
      'dispenser_name': instance.dispenserName,
      'unit_price': instance.unitPrice,
      'litres_sold': instance.litresSold,
      'total_amount': instance.totalAmount,
      'payment_mode': instance.paymentMode,
      'payment_mode_display': instance.paymentModeDisplay,
      'taxable_amount': instance.taxableAmount,
      'vat_amount': instance.vatAmount,
      'vat_rate': instance.vatRate,
      'customer_name': instance.customerName,
      'customer_kra_pin': instance.customerKraPin,
      'car_registration': instance.carRegistration,
      'odometer_reading': instance.odometerReading,
      'employee_name': instance.employeeName,
      'employee_id': instance.employeeId,
      'shift_id': instance.shiftId,
      'shift_started_at': instance.shiftStartedAt,
      'external_transaction_id': instance.externalTransactionId,
      'kra_invoice_number': instance.kraInvoiceNumber,
      'kra_trn': instance.kraTrn,
      'kra_device_serial': instance.kraDeviceSerial,
      'kra_branch_id': instance.kraBranchId,
      'mrc_no': instance.mrcNo,
      'sdc_id': instance.sdcId,
      'receipt_no': instance.receiptNo,
      'receipt_signature': instance.receiptSignature,
      'internal_data': instance.internalData,
      'total_receipt_no': instance.totalReceiptNo,
      'vsdc_receipt_pbct_date': instance.vsdcReceiptPbctDate,
      'currency': instance.currency,
      'currency_symbol': instance.currencySymbol,
    };

ReceiptPrintResponse _$ReceiptPrintResponseFromJson(
        Map<String, dynamic> json) =>
    ReceiptPrintResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      receiptContent: json['receipt_content'] as String?,
      receiptNumber: json['receipt_number'] as String?,
      printerType: json['printer_type'] as String?,
    );

Map<String, dynamic> _$ReceiptPrintResponseToJson(
        ReceiptPrintResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'receipt_content': instance.receiptContent,
      'receipt_number': instance.receiptNumber,
      'printer_type': instance.printerType,
    };

ReceiptPdfUrlResponse _$ReceiptPdfUrlResponseFromJson(
        Map<String, dynamic> json) =>
    ReceiptPdfUrlResponse(
      success: json['success'] as bool,
      qrScanUrl: json['qr_scan_url'] as String,
      qrData: json['qr_data'] as Map<String, dynamic>,
      receiptNumber: json['receipt_number'] as String,
      expiresIn: json['expires_in'] as String,
    );

Map<String, dynamic> _$ReceiptPdfUrlResponseToJson(
        ReceiptPdfUrlResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'qr_scan_url': instance.qrScanUrl,
      'qr_data': instance.qrData,
      'receipt_number': instance.receiptNumber,
      'expires_in': instance.expiresIn,
    };

RecentReceiptsResponse _$RecentReceiptsResponseFromJson(
        Map<String, dynamic> json) =>
    RecentReceiptsResponse(
      success: json['success'] as bool,
      receipts: (json['receipts'] as List<dynamic>)
          .map((e) => ReceiptModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num).toInt(),
      dateRange: Map<String, String>.from(json['date_range'] as Map),
    );

Map<String, dynamic> _$RecentReceiptsResponseToJson(
        RecentReceiptsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'receipts': instance.receipts,
      'count': instance.count,
      'date_range': instance.dateRange,
    };
