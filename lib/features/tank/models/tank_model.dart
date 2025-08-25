import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flow_360/features/shared/models/fuel_type_model.dart';

part 'tank_model.g.dart';

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

@HiveType(typeId: 6)
@JsonSerializable()
class TankModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String station;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final FuelTypeModel? fuelType;

  @HiveField(4)
  @JsonKey(name: 'capacity_litres')
  final String capacityLitres;

  @HiveField(5)
  @JsonKey(name: 'current_level_litres')
  final String currentLevelLitres;

  @HiveField(6)
  @JsonKey(name: 'is_active')
  final bool isActive;

  @HiveField(7)
  @JsonKey(name: 'created_at')
  final String createdAt;

  @HiveField(8)
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @HiveField(9)
  @JsonKey(name: 'usage_percentage', fromJson: _parseDouble)
  final double usagePercentage;

  @HiveField(10)
  @JsonKey(name: 'available_fuel', fromJson: _parseDouble)
  final double availableFuel;

  @HiveField(11)
  @JsonKey(name: 'fuel_status')
  final String fuelStatus;

  TankModel({
    required this.id,
    required this.station,
    required this.name,
    this.fuelType,
    required this.capacityLitres,
    required this.currentLevelLitres,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.usagePercentage,
    required this.availableFuel,
    required this.fuelStatus,
  });

  factory TankModel.fromJson(Map<String, dynamic> json) =>
      _$TankModelFromJson(json);
  Map<String, dynamic> toJson() => _$TankModelToJson(this);

  // Helper methods
  double get capacityLitresDouble => double.tryParse(capacityLitres) ?? 0.0;
  double get currentLevelLitresDouble =>
      double.tryParse(currentLevelLitres) ?? 0.0;

  // Get fuel type display name
  String get fuelTypeName => fuelType?.name ?? 'Unknown';
  String get fuelTypeKraCode => fuelType?.kraCode ?? '';
  String get fuelTypeColorHex => fuelType?.colorHex ?? '#808080';
  String? get fuelTypeId => fuelType?.id;

  // Fuel status methods
  bool get hasLowFuel => usagePercentage < 10;
  bool get hasMediumFuel => usagePercentage >= 10 && usagePercentage < 25;
  bool get hasGoodFuel => usagePercentage >= 25;

  // Get fuel status color
  Color get statusColor {
    if (!isActive) return Colors.grey;
    if (hasLowFuel) return Colors.red;
    if (hasMediumFuel) return Colors.orange;
    return Colors.green;
  }

  Color get fuelStatusColor {
    switch (fuelStatus.toLowerCase()) {
      case 'good':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      case 'empty':
        return Colors.grey;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
