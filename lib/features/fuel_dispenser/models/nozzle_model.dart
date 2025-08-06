// lib/features/fuel_dispenser/models/nozzle_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'nozzle_model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable(fieldRename: FieldRename.snake)
class NozzleModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String fuelType;
  @HiveField(2)
  final int nozzleNumber;
  @HiveField(3)
  final bool isActive;
  @HiveField(4)
  final String dispenser;

  NozzleModel({
    required this.id,
    required this.fuelType,
    required this.nozzleNumber,
    required this.isActive,
    required this.dispenser,
  });

  factory NozzleModel.fromJson(Map<String, dynamic> json) =>
      _$NozzleModelFromJson(json);

  Map<String, dynamic> toJson() => _$NozzleModelToJson(this);

  NozzleModel copyWith({
    String? id,
    String? fuelType,
    int? nozzleNumber,
    bool? isActive,
    String? dispenser,
  }) {
    return NozzleModel(
      id: id ?? this.id,
      fuelType: fuelType ?? this.fuelType,
      nozzleNumber: nozzleNumber ?? this.nozzleNumber,
      isActive: isActive ?? this.isActive,
      dispenser: dispenser ?? this.dispenser,
    );
  }
}
