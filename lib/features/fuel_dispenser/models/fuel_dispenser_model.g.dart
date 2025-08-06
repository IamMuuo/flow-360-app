// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_dispenser_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelDispenserModelAdapter extends TypeAdapter<FuelDispenserModel> {
  @override
  final int typeId = 4;

  @override
  FuelDispenserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelDispenserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      serialNumber: fields[2] as String,
      manufacturer: fields[3] as String,
      installedAt: fields[4] as String,
      isActive: fields[5] as bool,
      createdAt: fields[6] as String,
      station: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FuelDispenserModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.serialNumber)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.installedAt)
      ..writeByte(5)
      ..write(obj.isActive)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.station);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelDispenserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuelDispenserModel _$FuelDispenserModelFromJson(Map<String, dynamic> json) =>
    FuelDispenserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      serialNumber: json['serial_number'] as String,
      manufacturer: json['manufacturer'] as String,
      installedAt: json['installed_at'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      station: json['station'] as String,
    );

Map<String, dynamic> _$FuelDispenserModelToJson(FuelDispenserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'serial_number': instance.serialNumber,
      'manufacturer': instance.manufacturer,
      'installed_at': instance.installedAt,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'station': instance.station,
    };
