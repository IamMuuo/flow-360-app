// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => SaleModel(
      id: json['id'] as String,
      employee: (json['employee'] as num).toInt(),
      shift: json['shift'] as String,
      nozzle: json['nozzle'] as String,
      litresSold: _parseDouble(json['litres_sold']),
      pricePerLitre: _parseDouble(json['price_per_litre']),
      totalAmount: _parseDouble(json['total_amount']),
      paymentMode: json['payment_mode'] as String,
      soldAt: DateTime.parse(json['sold_at'] as String),
      odometerReading: (json['odometer_reading'] as num?)?.toInt(),
      carRegistrationNumber: json['car_resistration_number'] as String?,
      kraPin: json['kra_pin'] as String?,
      customerName: json['customer_name'] as String?,
      receiptNumber: json['receipt_number'] as String?,
      externalTransactionId: json['external_transaction_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      modifiedAt: DateTime.parse(json['modified_at'] as String),
    );

Map<String, dynamic> _$SaleModelToJson(SaleModel instance) => <String, dynamic>{
      'id': instance.id,
      'employee': instance.employee,
      'shift': instance.shift,
      'nozzle': instance.nozzle,
      'litres_sold': instance.litresSold,
      'price_per_litre': instance.pricePerLitre,
      'total_amount': instance.totalAmount,
      'payment_mode': instance.paymentMode,
      'sold_at': instance.soldAt.toIso8601String(),
      'odometer_reading': instance.odometerReading,
      'car_resistration_number': instance.carRegistrationNumber,
      'kra_pin': instance.kraPin,
      'customer_name': instance.customerName,
      'receipt_number': instance.receiptNumber,
      'external_transaction_id': instance.externalTransactionId,
      'created_at': instance.createdAt.toIso8601String(),
      'modified_at': instance.modifiedAt.toIso8601String(),
    };

AvailableNozzleModel _$AvailableNozzleModelFromJson(
        Map<String, dynamic> json) =>
    AvailableNozzleModel(
      id: json['id'] as String,
      nozzleNumber: (json['nozzleNumber'] as num).toInt(),
      fuelType: json['fuelType'] as String,
      fuelTypeDisplay: json['fuelTypeDisplay'] as String,
      dispenserName: json['dispenserName'] as String,
      pricePerLitre: (json['pricePerLitre'] as num).toDouble(),
      colorHex: json['colorHex'] as String,
    );

Map<String, dynamic> _$AvailableNozzleModelToJson(
        AvailableNozzleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nozzleNumber': instance.nozzleNumber,
      'fuelType': instance.fuelType,
      'fuelTypeDisplay': instance.fuelTypeDisplay,
      'dispenserName': instance.dispenserName,
      'pricePerLitre': instance.pricePerLitre,
      'colorHex': instance.colorHex,
    };

SaleValidationModel _$SaleValidationModelFromJson(Map<String, dynamic> json) =>
    SaleValidationModel(
      valid: json['valid'] as bool,
      litresSold: (json['litres_sold'] as num).toDouble(),
      pricePerLitre: (json['price_per_litre'] as num).toDouble(),
      nozzleInfo:
          NozzleInfoModel.fromJson(json['nozzle_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaleValidationModelToJson(
        SaleValidationModel instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'litres_sold': instance.litresSold,
      'price_per_litre': instance.pricePerLitre,
      'nozzle_info': instance.nozzleInfo,
    };

NozzleInfoModel _$NozzleInfoModelFromJson(Map<String, dynamic> json) =>
    NozzleInfoModel(
      id: json['id'] as String,
      nozzleNumber: (json['nozzle_number'] as num).toInt(),
      fuelType: json['fuel_type'] as String,
      fuelTypeDisplay: json['fuel_type_display'] as String,
      dispenserName: json['dispenser_name'] as String,
    );

Map<String, dynamic> _$NozzleInfoModelToJson(NozzleInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nozzle_number': instance.nozzleNumber,
      'fuel_type': instance.fuelType,
      'fuel_type_display': instance.fuelTypeDisplay,
      'dispenser_name': instance.dispenserName,
    };
