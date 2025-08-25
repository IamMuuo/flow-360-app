// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelTypeModelAdapter extends TypeAdapter<FuelTypeModel> {
  @override
  final int typeId = 25;

  @override
  FuelTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelTypeModel(
      id: fields[0] as String,
      name: fields[1] as String,
      kraCode: fields[2] as String,
      colorHex: fields[3] as String,
      isActive: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FuelTypeModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.kraCode)
      ..writeByte(3)
      ..write(obj.colorHex)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuelTypeModel _$FuelTypeModelFromJson(Map<String, dynamic> json) =>
    FuelTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      kraCode: json['kra_code'] as String,
      colorHex: json['color_hex'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$FuelTypeModelToJson(FuelTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kra_code': instance.kraCode,
      'color_hex': instance.colorHex,
      'is_active': instance.isActive,
    };
