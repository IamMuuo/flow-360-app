// lib/features/fuel/models/fuel_price_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flow_360/features/shared/models/fuel_type_model.dart';

part 'fuel_price_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class FuelPriceModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String station;

  @HiveField(2)
  final FuelTypeModel? fuelType;

  @HiveField(3)
  @JsonKey(name: 'price_per_litre')
  final String pricePerLitre;

  @HiveField(4)
  @JsonKey(name: 'effective_from')
  final String effectiveFrom;

  @HiveField(5)
  @JsonKey(name: 'created_at')
  final String createdAt;

  FuelPriceModel({
    required this.id,
    required this.station,
    this.fuelType,
    required this.pricePerLitre,
    required this.effectiveFrom,
    required this.createdAt,
  });

  factory FuelPriceModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPriceModelFromJson(json);
  Map<String, dynamic> toJson() => _$FuelPriceModelToJson(this);

  // Helper getters
  String get fuelTypeName => fuelType?.name ?? 'Unknown';
  String get fuelTypeKraCode => fuelType?.kraCode ?? '';
  String get fuelTypeColorHex => fuelType?.colorHex ?? '#808080';
}
