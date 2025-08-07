// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => SaleModel(
      id: json['id'] as String,
      employee: json['employee'] as String,
      shift: json['shift'] as String,
      nozzle: json['nozzle'] as String,
      litresSold: (json['litresSold'] as num).toDouble(),
      pricePerLitre: (json['pricePerLitre'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      paymentMode: json['paymentMode'] as String,
      soldAt: DateTime.parse(json['soldAt'] as String),
      odometerReading: (json['odometerReading'] as num?)?.toInt(),
      carRegistrationNumber: json['carRegistrationNumber'] as String?,
      kraPin: json['kraPin'] as String?,
      externalTransactionId: json['externalTransactionId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
    );

Map<String, dynamic> _$SaleModelToJson(SaleModel instance) => <String, dynamic>{
      'id': instance.id,
      'employee': instance.employee,
      'shift': instance.shift,
      'nozzle': instance.nozzle,
      'litresSold': instance.litresSold,
      'pricePerLitre': instance.pricePerLitre,
      'totalAmount': instance.totalAmount,
      'paymentMode': instance.paymentMode,
      'soldAt': instance.soldAt.toIso8601String(),
      'odometerReading': instance.odometerReading,
      'carRegistrationNumber': instance.carRegistrationNumber,
      'kraPin': instance.kraPin,
      'externalTransactionId': instance.externalTransactionId,
      'createdAt': instance.createdAt.toIso8601String(),
      'modifiedAt': instance.modifiedAt.toIso8601String(),
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
      litresSold: (json['litresSold'] as num).toDouble(),
      pricePerLitre: (json['pricePerLitre'] as num).toDouble(),
      nozzleInfo:
          NozzleInfoModel.fromJson(json['nozzleInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaleValidationModelToJson(
        SaleValidationModel instance) =>
    <String, dynamic>{
      'valid': instance.valid,
      'litresSold': instance.litresSold,
      'pricePerLitre': instance.pricePerLitre,
      'nozzleInfo': instance.nozzleInfo,
    };

NozzleInfoModel _$NozzleInfoModelFromJson(Map<String, dynamic> json) =>
    NozzleInfoModel(
      id: json['id'] as String,
      nozzleNumber: (json['nozzleNumber'] as num).toInt(),
      fuelType: json['fuelType'] as String,
      fuelTypeDisplay: json['fuelTypeDisplay'] as String,
      dispenserName: json['dispenserName'] as String,
    );

Map<String, dynamic> _$NozzleInfoModelToJson(NozzleInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nozzleNumber': instance.nozzleNumber,
      'fuelType': instance.fuelType,
      'fuelTypeDisplay': instance.fuelTypeDisplay,
      'dispenserName': instance.dispenserName,
    };
