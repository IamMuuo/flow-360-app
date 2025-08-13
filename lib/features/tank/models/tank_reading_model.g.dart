// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tank_reading_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TankReadingModelAdapter extends TypeAdapter<TankReadingModel> {
  @override
  final int typeId = 10;

  @override
  TankReadingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TankReadingModel(
      id: fields[0] as String,
      stationShift: fields[1] as String,
      tank: fields[2] as String,
      readingType: fields[3] as String,
      manualReadingLitres: fields[4] as double,
      systemReadingLitres: fields[5] as double?,
      varianceLitres: fields[6] as double?,
      variancePercentage: fields[7] as double?,
      isReconciled: fields[8] as bool,
      reconciliationNotes: fields[9] as String?,
      recordedBy: fields[10] as String,
      recordedAt: fields[11] as String,
      tankName: fields[12] as String,
      recordedByName: fields[13] as String,
      varianceStatus: fields[14] as String,
      hasVariance: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TankReadingModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stationShift)
      ..writeByte(2)
      ..write(obj.tank)
      ..writeByte(3)
      ..write(obj.readingType)
      ..writeByte(4)
      ..write(obj.manualReadingLitres)
      ..writeByte(5)
      ..write(obj.systemReadingLitres)
      ..writeByte(6)
      ..write(obj.varianceLitres)
      ..writeByte(7)
      ..write(obj.variancePercentage)
      ..writeByte(8)
      ..write(obj.isReconciled)
      ..writeByte(9)
      ..write(obj.reconciliationNotes)
      ..writeByte(10)
      ..write(obj.recordedBy)
      ..writeByte(11)
      ..write(obj.recordedAt)
      ..writeByte(12)
      ..write(obj.tankName)
      ..writeByte(13)
      ..write(obj.recordedByName)
      ..writeByte(14)
      ..write(obj.varianceStatus)
      ..writeByte(15)
      ..write(obj.hasVariance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TankReadingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TankReadingModel _$TankReadingModelFromJson(Map<String, dynamic> json) =>
    TankReadingModel(
      id: json['id'] as String,
      stationShift: json['station_shift'] as String,
      tank: json['tank'] as String,
      readingType: json['reading_type'] as String,
      manualReadingLitres:
          TankReadingModel._parseDouble(json['manual_reading_litres']),
      systemReadingLitres:
          TankReadingModel._parseDoubleNullable(json['system_reading_litres']),
      varianceLitres:
          TankReadingModel._parseDoubleNullable(json['variance_litres']),
      variancePercentage:
          TankReadingModel._parseDoubleNullable(json['variance_percentage']),
      isReconciled: json['is_reconciled'] as bool,
      reconciliationNotes: json['reconciliation_notes'] as String?,
      recordedBy: json['recorded_by'] as String,
      recordedAt: json['recorded_at'] as String,
      tankName: json['tank_name'] as String,
      recordedByName: json['recorded_by_name'] as String,
      varianceStatus: json['variance_status'] as String,
      hasVariance: json['has_variance'] as bool,
    );

Map<String, dynamic> _$TankReadingModelToJson(TankReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_shift': instance.stationShift,
      'tank': instance.tank,
      'reading_type': instance.readingType,
      'manual_reading_litres': instance.manualReadingLitres,
      'system_reading_litres': instance.systemReadingLitres,
      'variance_litres': instance.varianceLitres,
      'variance_percentage': instance.variancePercentage,
      'is_reconciled': instance.isReconciled,
      'reconciliation_notes': instance.reconciliationNotes,
      'recorded_by': instance.recordedBy,
      'recorded_at': instance.recordedAt,
      'tank_name': instance.tankName,
      'recorded_by_name': instance.recordedByName,
      'variance_status': instance.varianceStatus,
      'has_variance': instance.hasVariance,
    };
