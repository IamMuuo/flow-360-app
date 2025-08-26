// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tank_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TankModelAdapter extends TypeAdapter<TankModel> {
  @override
  final int typeId = 6;

  @override
  TankModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TankModel(
      id: fields[0] as String,
      station: fields[1] as String,
      name: fields[2] as String,
      fuelType: fields[3] as FuelTypeModel?,
      capacityLitres: fields[4] as String,
      currentLevelLitres: fields[5] as String,
      isActive: fields[6] as bool,
      createdAt: fields[7] as String,
      updatedAt: fields[8] as String,
      usagePercentage: fields[9] as double,
      availableFuel: fields[10] as double,
      fuelStatus: fields[11] as String,
      fuelName: fields[12] as String?,
      fuelKraCode: fields[13] as String?,
      fuelColorHex: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TankModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.station)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.fuelType)
      ..writeByte(4)
      ..write(obj.capacityLitres)
      ..writeByte(5)
      ..write(obj.currentLevelLitres)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.usagePercentage)
      ..writeByte(10)
      ..write(obj.availableFuel)
      ..writeByte(11)
      ..write(obj.fuelStatus)
      ..writeByte(12)
      ..write(obj.fuelName)
      ..writeByte(13)
      ..write(obj.fuelKraCode)
      ..writeByte(14)
      ..write(obj.fuelColorHex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TankModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TankModel _$TankModelFromJson(Map<String, dynamic> json) => TankModel(
      id: json['id'] as String,
      station: json['station'] as String,
      name: json['name'] as String,
      fuelType: json['fuel_type'] == null
          ? null
          : FuelTypeModel.fromJson(json['fuel_type'] as Map<String, dynamic>),
      capacityLitres: json['capacity_litres'] as String,
      currentLevelLitres: json['current_level_litres'] as String,
      isActive: json['is_active'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      usagePercentage: _parseDouble(json['usage_percentage']),
      availableFuel: _parseDouble(json['available_fuel']),
      fuelStatus: json['fuel_status'] as String,
      fuelName: json['fuel_name'] as String?,
      fuelKraCode: json['fuel_kra_code'] as String?,
      fuelColorHex: json['fuel_color_hex'] as String?,
    );

Map<String, dynamic> _$TankModelToJson(TankModel instance) => <String, dynamic>{
      'id': instance.id,
      'station': instance.station,
      'name': instance.name,
      'fuel_type': instance.fuelType,
      'capacity_litres': instance.capacityLitres,
      'current_level_litres': instance.currentLevelLitres,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'usage_percentage': instance.usagePercentage,
      'available_fuel': instance.availableFuel,
      'fuel_status': instance.fuelStatus,
      'fuel_name': instance.fuelName,
      'fuel_kra_code': instance.fuelKraCode,
      'fuel_color_hex': instance.fuelColorHex,
    };
