import 'package:json_annotation/json_annotation.dart';

part 'sale_model.g.dart';

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@JsonSerializable()
class SaleModel {
  final String id;
  final int employee;
  final String shift;
  final String nozzle;
  @JsonKey(name: 'litres_sold', fromJson: _parseDouble)
  final double litresSold;
  @JsonKey(name: 'price_per_litre', fromJson: _parseDouble)
  final double pricePerLitre;
  @JsonKey(name: 'total_amount', fromJson: _parseDouble)
  final double totalAmount;
  @JsonKey(name: 'payment_mode')
  final String paymentMode;
  @JsonKey(name: 'sold_at')
  final DateTime soldAt;
  @JsonKey(name: 'odometer_reading')
  final int? odometerReading;
  @JsonKey(name: 'car_resistration_number')
  final String? carRegistrationNumber;
  @JsonKey(name: 'kra_pin')
  final String? kraPin;
  @JsonKey(name: 'external_transaction_id')
  final String? externalTransactionId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'modified_at')
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
  @JsonKey(name: 'valid')
  final bool valid;
  @JsonKey(name: 'litres_sold')
  final double litresSold;
  @JsonKey(name: 'price_per_litre')
  final double pricePerLitre;
  @JsonKey(name: 'nozzle_info')
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
  @JsonKey(name: 'nozzle_number')
  final int nozzleNumber;
  @JsonKey(name: 'fuel_type')
  final String fuelType;
  @JsonKey(name: 'fuel_type_display')
  final String fuelTypeDisplay;
  @JsonKey(name: 'dispenser_name')
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

