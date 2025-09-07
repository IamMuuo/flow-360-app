// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tank_audit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TankAuditModelAdapter extends TypeAdapter<TankAuditModel> {
  @override
  final int typeId = 7;

  @override
  TankAuditModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TankAuditModel(
      id: fields[0] as String,
      tank: fields[1] as String,
      tankName: fields[2] as String,
      previousLevel: fields[3] as String,
      newLevel: fields[4] as String,
      changeAmount: fields[5] as String,
      changeType: fields[6] as String,
      reason: fields[7] as String,
      recordedBy: (fields[8] as num?)?.toInt(),
      recordedByName: fields[9] as String?,
      saleReference: fields[10] as String?,
      recordedAt: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TankAuditModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tank)
      ..writeByte(2)
      ..write(obj.tankName)
      ..writeByte(3)
      ..write(obj.previousLevel)
      ..writeByte(4)
      ..write(obj.newLevel)
      ..writeByte(5)
      ..write(obj.changeAmount)
      ..writeByte(6)
      ..write(obj.changeType)
      ..writeByte(7)
      ..write(obj.reason)
      ..writeByte(8)
      ..write(obj.recordedBy)
      ..writeByte(9)
      ..write(obj.recordedByName)
      ..writeByte(10)
      ..write(obj.saleReference)
      ..writeByte(11)
      ..write(obj.recordedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TankAuditModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TankAuditModel _$TankAuditModelFromJson(Map<String, dynamic> json) =>
    TankAuditModel(
      id: json['id'] as String,
      tank: json['tank'] as String,
      tankName: json['tank_name'] as String,
      previousLevel: json['previous_level'] as String,
      newLevel: json['new_level'] as String,
      changeAmount: json['change_amount'] as String,
      changeType: json['change_type'] as String,
      reason: json['reason'] as String,
      recordedBy: (json['recorded_by'] as num?)?.toInt(),
      recordedByName: json['recorded_by_name'] as String?,
      saleReference: json['sale_reference'] as String?,
      recordedAt: json['recorded_at'] as String,
    );

Map<String, dynamic> _$TankAuditModelToJson(TankAuditModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tank': instance.tank,
      'tank_name': instance.tankName,
      'previous_level': instance.previousLevel,
      'new_level': instance.newLevel,
      'change_amount': instance.changeAmount,
      'change_type': instance.changeType,
      'reason': instance.reason,
      'recorded_by': instance.recordedBy,
      'recorded_by_name': instance.recordedByName,
      'sale_reference': instance.saleReference,
      'recorded_at': instance.recordedAt,
    };
