// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuel_price_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FuelPriceModelAdapter extends TypeAdapter<FuelPriceModel> {
  @override
  final int typeId = 3;

  @override
  FuelPriceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FuelPriceModel(
      id: (fields[0] as num).toInt(),
      station: fields[1] as String,
      fuelName: fields[2] as String?,
      pricePerLitre: fields[3] as String,
      effectiveFrom: fields[4] as String,
      createdAt: fields[5] as String,
      colorHex: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FuelPriceModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.station)
      ..writeByte(2)
      ..write(obj.fuelName)
      ..writeByte(3)
      ..write(obj.pricePerLitre)
      ..writeByte(4)
      ..write(obj.effectiveFrom)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.colorHex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FuelPriceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FuelPriceModel _$FuelPriceModelFromJson(Map<String, dynamic> json) =>
    FuelPriceModel(
      id: (json['id'] as num).toInt(),
      station: json['station'] as String,
      fuelName: json['fuel_name'] as String?,
      pricePerLitre: json['price_per_litre'] as String,
      effectiveFrom: json['effective_from'] as String,
      createdAt: json['created_at'] as String,
      colorHex: json['color_hex'] as String?,
    );

Map<String, dynamic> _$FuelPriceModelToJson(FuelPriceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'station': instance.station,
      'fuel_name': instance.fuelName,
      'price_per_litre': instance.pricePerLitre,
      'effective_from': instance.effectiveFrom,
      'created_at': instance.createdAt,
      'color_hex': instance.colorHex,
    };
