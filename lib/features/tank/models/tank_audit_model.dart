import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tank_audit_model.g.dart';

@HiveType(typeId: 7)
@JsonSerializable()
class TankAuditModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tank;

  @HiveField(2)
  @JsonKey(name: 'tank_name')
  final String tankName;

  @HiveField(3)
  @JsonKey(name: 'previous_level')
  final String previousLevel;

  @HiveField(4)
  @JsonKey(name: 'new_level')
  final String newLevel;

  @HiveField(5)
  @JsonKey(name: 'change_amount')
  final String changeAmount;

  @HiveField(6)
  @JsonKey(name: 'change_type')
  final String changeType;

  @HiveField(7)
  final String reason;

  @HiveField(8)
  @JsonKey(name: 'recorded_by')
  final int? recordedBy;

  @HiveField(9)
  @JsonKey(name: 'recorded_by_name')
  final String? recordedByName;

  @HiveField(10)
  @JsonKey(name: 'sale_reference')
  final String? saleReference;

  @HiveField(11)
  @JsonKey(name: 'recorded_at')
  final String recordedAt;

  TankAuditModel({
    required this.id,
    required this.tank,
    required this.tankName,
    required this.previousLevel,
    required this.newLevel,
    required this.changeAmount,
    required this.changeType,
    required this.reason,
    this.recordedBy,
    this.recordedByName,
    this.saleReference,
    required this.recordedAt,
  });

  factory TankAuditModel.fromJson(Map<String, dynamic> json) =>
      _$TankAuditModelFromJson(json);
  Map<String, dynamic> toJson() => _$TankAuditModelToJson(this);

  // Helper methods
  double get previousLevelDouble => double.tryParse(previousLevel) ?? 0.0;
  double get newLevelDouble => double.tryParse(newLevel) ?? 0.0;
  double get changeAmountDouble => double.tryParse(changeAmount) ?? 0.0;

  bool get isAddition => changeType == 'ADDITION';
  bool get isConsumption => changeType == 'CONSUMPTION';
  bool get isAdjustment => changeType == 'ADJUSTMENT';
  bool get isDelivery => changeType == 'DELIVERY';

  String get changeTypeDisplay {
    switch (changeType) {
      case 'ADDITION':
        return 'Fuel Added';
      case 'CONSUMPTION':
        return 'Fuel Sold';
      case 'ADJUSTMENT':
        return 'Manual Adjustment';
      case 'DELIVERY':
        return 'Fuel Delivery';
      default:
        return changeType;
    }
  }
}

