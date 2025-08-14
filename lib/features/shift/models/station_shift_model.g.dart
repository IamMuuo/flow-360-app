// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_shift_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NozzleReadingModelAdapter extends TypeAdapter<NozzleReadingModel> {
  @override
  final int typeId = 20;

  @override
  NozzleReadingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NozzleReadingModel(
      id: fields[0] as String,
      stationShift: fields[1] as String,
      nozzle: fields[2] as String,
      readingType: fields[3] as String,
      manualReading: fields[4] as double,
      systemReading: fields[5] as double?,
      variance: fields[6] as double?,
      variancePercentage: fields[7] as double?,
      isReconciled: fields[8] as bool,
      reconciliationNotes: fields[9] as String?,
      recordedBy: fields[10] as String,
      recordedAt: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NozzleReadingModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.stationShift)
      ..writeByte(2)
      ..write(obj.nozzle)
      ..writeByte(3)
      ..write(obj.readingType)
      ..writeByte(4)
      ..write(obj.manualReading)
      ..writeByte(5)
      ..write(obj.systemReading)
      ..writeByte(6)
      ..write(obj.variance)
      ..writeByte(7)
      ..write(obj.variancePercentage)
      ..writeByte(8)
      ..write(obj.isReconciled)
      ..writeByte(9)
      ..write(obj.reconciliationNotes)
      ..writeByte(10)
      ..write(obj.recordedBy)
      ..writeByte(11)
      ..write(obj.recordedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NozzleReadingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShiftNozzleModelAdapter extends TypeAdapter<ShiftNozzleModel> {
  @override
  final int typeId = 21;

  @override
  ShiftNozzleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShiftNozzleModel(
      id: fields[0] as String,
      dispenser: fields[1] as String,
      tank: fields[2] as String?,
      fuelType: fields[3] as String,
      nozzleNumber: fields[4] as int,
      isActive: fields[5] as bool,
      initialReading: fields[6] as double,
      currentReading: fields[7] as double,
      lastUpdated: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShiftNozzleModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dispenser)
      ..writeByte(2)
      ..write(obj.tank)
      ..writeByte(3)
      ..write(obj.fuelType)
      ..writeByte(4)
      ..write(obj.nozzleNumber)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.initialReading)
      ..writeByte(7)
      ..write(obj.currentReading)
      ..writeByte(8)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftNozzleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NozzleReadingModel _$NozzleReadingModelFromJson(Map<String, dynamic> json) =>
    NozzleReadingModel(
      id: json['id'] as String,
      stationShift: json['station_shift'] as String,
      nozzle: json['nozzle'] as String,
      readingType: json['reading_type'] as String,
      manualReading: NozzleReadingModel._parseDouble(json['manual_reading']),
      systemReading:
          NozzleReadingModel._parseDoubleNullable(json['system_reading']),
      variance: NozzleReadingModel._parseDoubleNullable(json['variance']),
      variancePercentage:
          NozzleReadingModel._parseDoubleNullable(json['variance_percentage']),
      isReconciled: json['is_reconciled'] as bool,
      reconciliationNotes: json['reconciliation_notes'] as String?,
      recordedBy: json['recorded_by'] as String,
      recordedAt: json['recorded_at'] as String,
    );

Map<String, dynamic> _$NozzleReadingModelToJson(NozzleReadingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station_shift': instance.stationShift,
      'nozzle': instance.nozzle,
      'reading_type': instance.readingType,
      'manual_reading': instance.manualReading,
      'system_reading': instance.systemReading,
      'variance': instance.variance,
      'variance_percentage': instance.variancePercentage,
      'is_reconciled': instance.isReconciled,
      'reconciliation_notes': instance.reconciliationNotes,
      'recorded_by': instance.recordedBy,
      'recorded_at': instance.recordedAt,
    };

ShiftNozzleModel _$ShiftNozzleModelFromJson(Map<String, dynamic> json) =>
    ShiftNozzleModel(
      id: json['id'] as String,
      dispenser: json['dispenser'] as String,
      tank: json['tank'] as String?,
      fuelType: json['fuel_type'] as String,
      nozzleNumber: (json['nozzle_number'] as num).toInt(),
      isActive: json['is_active'] as bool,
      initialReading: ShiftNozzleModel._parseDouble(json['initial_reading']),
      currentReading: ShiftNozzleModel._parseDouble(json['current_reading']),
      lastUpdated: json['last_updated'] as String,
    );

Map<String, dynamic> _$ShiftNozzleModelToJson(ShiftNozzleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dispenser': instance.dispenser,
      'tank': instance.tank,
      'fuel_type': instance.fuelType,
      'nozzle_number': instance.nozzleNumber,
      'is_active': instance.isActive,
      'initial_reading': instance.initialReading,
      'current_reading': instance.currentReading,
      'last_updated': instance.lastUpdated,
    };
