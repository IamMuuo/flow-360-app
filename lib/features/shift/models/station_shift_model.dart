// lib/features/shift/models/station_shift_model.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flow_360/features/shared/models/fuel_type_model.dart';

part 'station_shift_model.g.dart';

@HiveType(typeId: 20)
@JsonSerializable()
class NozzleReadingModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  @JsonKey(name: 'station_shift')
  final String stationShift;
  
  @HiveField(2)
  final String nozzle;
  
  @HiveField(3)
  @JsonKey(name: 'reading_type')
  final String readingType;
  
  @HiveField(4)
  @JsonKey(name: 'manual_reading', fromJson: _parseDouble)
  final double manualReading;
  
  @HiveField(5)
  @JsonKey(name: 'system_reading', fromJson: _parseDoubleNullable)
  final double? systemReading;
  
  @HiveField(6)
  @JsonKey(fromJson: _parseDoubleNullable)
  final double? variance;
  
  @HiveField(7)
  @JsonKey(name: 'variance_percentage', fromJson: _parseDoubleNullable)
  final double? variancePercentage;
  
  @HiveField(8)
  @JsonKey(name: 'is_reconciled')
  final bool isReconciled;
  
  @HiveField(9)
  @JsonKey(name: 'reconciliation_notes')
  final String? reconciliationNotes;
  
  @HiveField(10)
  @JsonKey(name: 'recorded_by')
  final String recordedBy;
  
  @HiveField(11)
  @JsonKey(name: 'recorded_at')
  final String recordedAt;

  NozzleReadingModel({
    required this.id,
    required this.stationShift,
    required this.nozzle,
    required this.readingType,
    required this.manualReading,
    this.systemReading,
    this.variance,
    this.variancePercentage,
    required this.isReconciled,
    this.reconciliationNotes,
    required this.recordedBy,
    required this.recordedAt,
  });

  factory NozzleReadingModel.fromJson(Map<String, dynamic> json) =>
      _$NozzleReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$NozzleReadingModelToJson(this);

  // Helper methods for parsing string to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static double? _parseDoubleNullable(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool get isOpeningReading => readingType == 'OPENING';
  bool get isClosingReading => readingType == 'CLOSING';
  bool get isReconciliationReading => readingType == 'RECONCILIATION';
  bool get hasVariance => variance != null && (variance?.abs() ?? 0) > 0.01;
  String get varianceStatus {
    if (!hasVariance) return 'OK';
    final percentage = variancePercentage?.abs() ?? 0;
    if (percentage <= 1) return 'MINOR';
    if (percentage <= 5) return 'MODERATE';
    return 'MAJOR';
  }
}

@HiveType(typeId: 21)
@JsonSerializable()
class ShiftNozzleModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String dispenser;
  
  @HiveField(2)
  final String? tank;
  
  @HiveField(3)
  final FuelTypeModel? fuelType;
  
  @HiveField(4)
  @JsonKey(name: 'nozzle_number')
  final int nozzleNumber;
  
  @HiveField(5)
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @HiveField(6)
  @JsonKey(name: 'initial_reading', fromJson: _parseDouble)
  final double initialReading;
  
  @HiveField(7)
  @JsonKey(name: 'current_reading', fromJson: _parseDouble)
  final double currentReading;
  
  @HiveField(8)
  @JsonKey(name: 'last_updated')
  final String lastUpdated;

  ShiftNozzleModel({
    required this.id,
    required this.dispenser,
    this.tank,
    this.fuelType,
    required this.nozzleNumber,
    required this.isActive,
    required this.initialReading,
    required this.currentReading,
    required this.lastUpdated,
  });

  factory ShiftNozzleModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftNozzleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftNozzleModelToJson(this);

  // Helper methods for parsing string to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  double get totalDispensed => currentReading - initialReading;
  
  // Helper getters for fuel type
  String get fuelTypeName => fuelType?.name ?? 'Unknown';
  String get fuelTypeKraCode => fuelType?.kraCode ?? '';
  String get fuelTypeColorHex => fuelType?.colorHex ?? '#808080';
}


