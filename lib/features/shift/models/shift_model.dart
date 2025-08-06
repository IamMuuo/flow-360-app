// lib/features/shift/models/shift_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'shift_model.g.dart';

@JsonSerializable()
class ShiftModel {
  final String id;
  @JsonKey(name: 'started_at')
  final String startedAt;
  @JsonKey(name: 'ended_at')
  final String? endedAt;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String station;
  final int employee;

  ShiftModel({
    required this.id,
    required this.startedAt,
    this.endedAt,
    required this.isActive,
    required this.createdAt,
    required this.station,
    required this.employee,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
}
