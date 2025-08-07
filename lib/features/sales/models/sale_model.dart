import 'package:json_annotation/json_annotation.dart';

part 'sale_model.g.dart';

@JsonSerializable()
class SaleModel {
  final String id;
  final String employee;
  final String shift;
  final String nozzle;
  final double litresSold;
  final double pricePerLitre;
  final double totalAmount;
  final String paymentMode;
  final DateTime soldAt;
  final int? odometerReading;
  final String? carRegistrationNumber;
  final String? kraPin;
  final String? externalTransactionId;
  final DateTime createdAt;
  final DateTime modifiedAt;

  SaleModel({
    required this.id,
    required this.employee,
    required this.shift,
    required this.nozzle,
    required this.litresSold,
    required this.pricePerLitre,
    required this.totalAmount,
    required this.paymentMode,
    required this.soldAt,
    this.odometerReading,
    this.carRegistrationNumber,
    this.kraPin,
    this.externalTransactionId,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) => _$SaleModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleModelToJson(this);
}

@JsonSerializable()
class AvailableNozzleModel {
  final String id;
  final int nozzleNumber;
  final String fuelType;
  final String fuelTypeDisplay;
  final String dispenserName;
  final double pricePerLitre;
  final String colorHex;

  AvailableNozzleModel({
    required this.id,
    required this.nozzleNumber,
    required this.fuelType,
    required this.fuelTypeDisplay,
    required this.dispenserName,
    required this.pricePerLitre,
    required this.colorHex,
  });

  factory AvailableNozzleModel.fromJson(Map<String, dynamic> json) => _$AvailableNozzleModelFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableNozzleModelToJson(this);
}

@JsonSerializable()
class SaleValidationModel {
  final bool valid;
  final double litresSold;
  final double pricePerLitre;
  final NozzleInfoModel nozzleInfo;

  SaleValidationModel({
    required this.valid,
    required this.litresSold,
    required this.pricePerLitre,
    required this.nozzleInfo,
  });

  factory SaleValidationModel.fromJson(Map<String, dynamic> json) => _$SaleValidationModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleValidationModelToJson(this);
}

@JsonSerializable()
class NozzleInfoModel {
  final String id;
  final int nozzleNumber;
  final String fuelType;
  final String fuelTypeDisplay;
  final String dispenserName;

  NozzleInfoModel({
    required this.id,
    required this.nozzleNumber,
    required this.fuelType,
    required this.fuelTypeDisplay,
    required this.dispenserName,
  });

  factory NozzleInfoModel.fromJson(Map<String, dynamic> json) => _$NozzleInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$NozzleInfoModelToJson(this);
}

