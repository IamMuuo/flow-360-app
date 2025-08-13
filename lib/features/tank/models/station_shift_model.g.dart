// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station_shift_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StationShiftModelAdapter extends TypeAdapter<StationShiftModel> {
  @override
  final int typeId = 9;

  @override
  StationShiftModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StationShiftModel(
      id: fields[0] as String,
      station: fields[1] as String,
      supervisor: fields[2] as int,
      shiftDate: fields[3] as String,
      startTime: fields[4] as String,
      endTime: fields[5] as String?,
      status: fields[6] as String,
      notes: fields[7] as String?,
      createdAt: fields[8] as String,
      updatedAt: fields[9] as String?,
      stationName: fields[10] as String,
      supervisorName: fields[11] as String,
      tankReadingsCount: fields[12] as int,
      durationMinutes: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, StationShiftModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.station)
      ..writeByte(2)
      ..write(obj.supervisor)
      ..writeByte(3)
      ..write(obj.shiftDate)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.stationName)
      ..writeByte(11)
      ..write(obj.supervisorName)
      ..writeByte(12)
      ..write(obj.tankReadingsCount)
      ..writeByte(13)
      ..write(obj.durationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StationShiftModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StationShiftModel _$StationShiftModelFromJson(Map<String, dynamic> json) =>
    StationShiftModel(
      id: json['id'] as String,
      station: json['station'] as String,
      supervisor: (json['supervisor'] as num).toInt(),
      shiftDate: json['shift_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String?,
      stationName: json['station_name'] as String,
      supervisorName: json['supervisor_name'] as String,
      tankReadingsCount: (json['tank_readings_count'] as num).toInt(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StationShiftModelToJson(StationShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station': instance.station,
      'supervisor': instance.supervisor,
      'shift_date': instance.shiftDate,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'station_name': instance.stationName,
      'supervisor_name': instance.supervisorName,
      'tank_readings_count': instance.tankReadingsCount,
      'duration_minutes': instance.durationMinutes,
    };
