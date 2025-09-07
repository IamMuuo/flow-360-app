import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tank_reading_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class TankReadingModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  @JsonKey(name: 'station_shift')
  final String stationShift;

  @HiveField(2)
  final String tank;

  @HiveField(3)
  @JsonKey(name: 'reading_type')
  final String readingType;

  @HiveField(4)
  @JsonKey(name: 'manual_reading_litres', fromJson: _parseDouble)
  final double manualReadingLitres;

  @HiveField(5)
  @JsonKey(name: 'system_reading_litres', fromJson: _parseDoubleNullable)
  final double? systemReadingLitres;

  @HiveField(6)
  @JsonKey(name: 'variance_litres', fromJson: _parseDoubleNullable)
  final double? varianceLitres;

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

  // Computed fields from backend
  @HiveField(12)
  @JsonKey(name: 'tank_name')
  final String tankName;

  @HiveField(13)
  @JsonKey(name: 'recorded_by_name')
  final String recordedByName;

  @HiveField(14)
  @JsonKey(name: 'variance_status')
  final String varianceStatus;

  @HiveField(15)
  @JsonKey(name: 'has_variance')
  final bool hasVariance;

  TankReadingModel({
    required this.id,
    required this.stationShift,
    required this.tank,
    required this.readingType,
    required this.manualReadingLitres,
    this.systemReadingLitres,
    this.varianceLitres,
    this.variancePercentage,
    required this.isReconciled,
    this.reconciliationNotes,
    required this.recordedBy,
    required this.recordedAt,
    required this.tankName,
    required this.recordedByName,
    required this.varianceStatus,
    required this.hasVariance,
  });

  factory TankReadingModel.fromJson(Map<String, dynamic> json) =>
      _$TankReadingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TankReadingModelToJson(this);

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

  // Computed properties with conversion to double
  double get manualReadingLitresDouble => manualReadingLitres;
  double? get systemReadingLitresDouble => systemReadingLitres;
  double? get varianceLitresDouble => varianceLitres;
  double? get variancePercentageDouble => variancePercentage;

  // Computed properties
  bool get needsReconciliation => hasVariance && !isReconciled;

  String get readingTypeText {
    switch (readingType) {
      case 'OPENING':
        return 'Opening Reading';
      case 'CLOSING':
        return 'Closing Reading';
      case 'RECONCILIATION':
        return 'Reconciliation Reading';
      default:
        return readingType;
    }
  }

  String get varianceText {
    if (varianceLitres == null) return 'N/A';
    final sign = varianceLitres! >= 0 ? '+' : '';
    return '$sign${varianceLitres!.toStringAsFixed(2)}L';
  }

  String get variancePercentageText {
    if (variancePercentage == null) return 'N/A';
    final sign = variancePercentage! >= 0 ? '+' : '';
    return '$sign${variancePercentage!.toStringAsFixed(2)}%';
  }

  String get varianceStatusText {
    switch (varianceStatus) {
      case 'OK':
        return 'OK';
      case 'MINOR':
        return 'Minor Variance';
      case 'MODERATE':
        return 'Moderate Variance';
      case 'MAJOR':
        return 'Major Variance';
      default:
        return varianceStatus;
    }
  }

  Color get varianceColor {
    switch (varianceStatus) {
      case 'OK':
        return Colors.green;
      case 'MINOR':
        return Colors.orange;
      case 'MODERATE':
        return Colors.deepOrange;
      case 'MAJOR':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get formattedRecordedAt {
    final date = DateTime.tryParse(recordedAt);
    if (date == null) return recordedAt;
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
