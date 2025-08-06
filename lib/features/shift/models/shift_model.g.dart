// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      id: json['id'] as String,
      startedAt: json['started_at'] as String,
      endedAt: json['ended_at'] as String?,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      station: json['station'] as String,
      employee: (json['employee'] as num).toInt(),
    );

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'started_at': instance.startedAt,
      'ended_at': instance.endedAt,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'station': instance.station,
      'employee': instance.employee,
    };
