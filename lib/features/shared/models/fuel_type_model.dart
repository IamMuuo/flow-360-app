import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fuel_type_model.g.dart';

@HiveType(typeId: 25)
@JsonSerializable()
class FuelTypeModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  @JsonKey(name: 'kra_code')
  final String kraCode;
  @HiveField(3)
  @JsonKey(name: 'color_hex')
  final String colorHex;
  @HiveField(4)
  @JsonKey(name: 'is_active')
  final bool isActive;

  FuelTypeModel({
    required this.id,
    required this.name,
    required this.kraCode,
    required this.colorHex,
    required this.isActive,
  });

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) =>
      _$FuelTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$FuelTypeModelToJson(this);
}
