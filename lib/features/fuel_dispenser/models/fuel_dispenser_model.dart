// lib/features/fuel/models/fuel_dispenser_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fuel_dispenser_model.g.dart';

@HiveType(typeId: 4) // Make sure this is a unique typeId
@JsonSerializable()
class FuelDispenserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  @JsonKey(name: 'serial_number')
  final String? serialNumber;

  @HiveField(3)
  final String? manufacturer;

  @HiveField(4)
  @JsonKey(name: 'installed_at')
  final String installedAt;

  @HiveField(5)
  @JsonKey(name: 'is_active')
  final bool isActive;

  @HiveField(6)
  @JsonKey(name: 'created_at')
  final String createdAt;

  @HiveField(7)
  final String station;

  FuelDispenserModel({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.manufacturer,
    required this.installedAt,
    required this.isActive,
    required this.createdAt,
    required this.station,
  });

  factory FuelDispenserModel.fromJson(Map<String, dynamic> json) =>
      _$FuelDispenserModelFromJson(json);
  Map<String, dynamic> toJson() => _$FuelDispenserModelToJson(this);

  // Add the copyWith method here
  FuelDispenserModel copyWith({
    String? id,
    String? name,
    String? serialNumber,
    String? manufacturer,
    String? installedAt,
    bool? isActive,
    String? createdAt,
    String? station,
  }) {
    return FuelDispenserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      serialNumber: serialNumber ?? this.serialNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      installedAt: installedAt ?? this.installedAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      station: station ?? this.station,
    );
  }
}
