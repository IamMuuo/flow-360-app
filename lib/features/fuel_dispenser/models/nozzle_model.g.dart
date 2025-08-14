// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nozzle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NozzleModelAdapter extends TypeAdapter<NozzleModel> {
  @override
  final int typeId = 5;

  @override
  NozzleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NozzleModel(
      id: fields[0] as String,
      fuelType: fields[1] as String,
      nozzleNumber: fields[2] as int,
      isActive: fields[3] as bool,
      dispenser: fields[4] as String,
      tank: fields[5] as String?,
      initialReading: fields[6] as double?,
      currentReading: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, NozzleModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fuelType)
      ..writeByte(2)
      ..write(obj.nozzleNumber)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.dispenser)
      ..writeByte(5)
      ..write(obj.tank)
      ..writeByte(6)
      ..write(obj.initialReading)
      ..writeByte(7)
      ..write(obj.currentReading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NozzleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NozzleModel _$NozzleModelFromJson(Map<String, dynamic> json) => NozzleModel(
      id: json['id'] as String,
      fuelType: json['fuel_type'] as String,
      nozzleNumber: (json['nozzle_number'] as num).toInt(),
      isActive: json['is_active'] as bool,
      dispenser: json['dispenser'] as String,
      tank: json['tank'] as String?,
      initialReading: NozzleModel._parseDouble(json['initial_reading']),
      currentReading: NozzleModel._parseDouble(json['current_reading']),
    );

Map<String, dynamic> _$NozzleModelToJson(NozzleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fuel_type': instance.fuelType,
      'nozzle_number': instance.nozzleNumber,
      'is_active': instance.isActive,
      'dispenser': instance.dispenser,
      'tank': instance.tank,
      'initial_reading': NozzleModel._doubleToString(instance.initialReading),
      'current_reading': NozzleModel._doubleToString(instance.currentReading),
    };
