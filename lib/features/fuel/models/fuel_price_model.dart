// lib/features/fuel/models/fuel_price_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fuel_price_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class FuelPriceModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String station;

  @HiveField(2)
  @JsonKey(name: 'fuel_type')
  final String fuelType;

  @HiveField(3)
  @JsonKey(name: 'fuel_name')
  final String fuelName;

  @HiveField(4)
  @JsonKey(name: 'price_per_litre')
  final String pricePerLitre;

  @HiveField(5)
  @JsonKey(name: 'effective_from')
  final String effectiveFrom;

  @HiveField(6)
  @JsonKey(name: 'color_hex')
  final String colorHex;

  @HiveField(7)
  @JsonKey(name: 'created_at')
  final String createdAt;

  FuelPriceModel({
    required this.id,
    required this.station,
    required this.fuelType,
    required this.fuelName,
    required this.pricePerLitre,
    required this.effectiveFrom,
    required this.colorHex,
    required this.createdAt,
  });

  factory FuelPriceModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPriceModelFromJson(json);
  Map<String, dynamic> toJson() => _$FuelPriceModelToJson(this);
}
