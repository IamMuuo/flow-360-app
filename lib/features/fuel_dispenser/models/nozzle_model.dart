// lib/features/fuel_dispenser/models/nozzle_model.dart

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flow_360/features/shared/models/fuel_type_model.dart';

part 'nozzle_model.g.dart';

@HiveType(typeId: 5)
@JsonSerializable(fieldRename: FieldRename.snake)
class NozzleModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  @JsonKey(name: 'fuel_type')
  final String? fuelTypeId;
  
  @HiveField(8)
  @JsonKey(name: 'fuel_type_name')
  final String? fuelTypeName;
  
  @HiveField(9)
  @JsonKey(name: 'fuel_type_kra_code')
  final String? fuelTypeKraCode;
  @HiveField(2)
  final int nozzleNumber;
  @HiveField(3)
  final bool isActive;
  @HiveField(4)
  final String dispenser;
  @HiveField(10)
  @JsonKey(name: 'dispenser_name')
  final String? dispenserName;
  @HiveField(5)
  final String? tank;
  @HiveField(6)
  @JsonKey(fromJson: _parseDouble, toJson: _doubleToString)
  final double? initialReading;
  @HiveField(7)
  @JsonKey(fromJson: _parseDouble, toJson: _doubleToString)
  final double? currentReading;

  NozzleModel({
    required this.id,
    this.fuelTypeId,
    this.fuelTypeName,
    this.fuelTypeKraCode,
    required this.nozzleNumber,
    required this.isActive,
    required this.dispenser,
    this.dispenserName,
    this.tank,
    this.initialReading,
    this.currentReading,
  });

  factory NozzleModel.fromJson(Map<String, dynamic> json) =>
      _$NozzleModelFromJson(json);

  Map<String, dynamic> toJson() => _$NozzleModelToJson(this);

  NozzleModel copyWith({
    String? id,
    String? fuelTypeId,
    String? fuelTypeName,
    String? fuelTypeKraCode,
    int? nozzleNumber,
    bool? isActive,
    String? dispenser,
    String? dispenserName,
    String? tank,
    double? initialReading,
    double? currentReading,
  }) {
    return NozzleModel(
      id: id ?? this.id,
      fuelTypeId: fuelTypeId ?? this.fuelTypeId,
      fuelTypeName: fuelTypeName ?? this.fuelTypeName,
      fuelTypeKraCode: fuelTypeKraCode ?? this.fuelTypeKraCode,
      nozzleNumber: nozzleNumber ?? this.nozzleNumber,
      isActive: isActive ?? this.isActive,
      dispenser: dispenser ?? this.dispenser,
      dispenserName: dispenserName ?? this.dispenserName,
      tank: tank ?? this.tank,
      initialReading: initialReading ?? this.initialReading,
      currentReading: currentReading ?? this.currentReading,
    );
  }

  // Helper getters to provide default values
  double get initialReadingValue => initialReading ?? 0.0;
  double get currentReadingValue => currentReading ?? 0.0;
  double get totalDispensed => currentReadingValue - initialReadingValue;

  // Helper getters for fuel type
  String get fuelTypeNameValue => fuelTypeName ?? 'Unknown';
  String get fuelTypeKraCodeValue => fuelTypeKraCode ?? '';
  String get fuelTypeColorHex => '#808080'; // Default color since we don't have it in the response
  
  // Helper getter for dispenser name
  String get dispenserNameValue => dispenserName ?? 'Unknown Dispenser';

  // Helper methods for parsing string to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String _doubleToString(double? value) {
    return value?.toString() ?? '0.0';
  }
}
