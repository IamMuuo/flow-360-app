import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'station_shift_model.g.dart';

@HiveType(typeId: 9)
@JsonSerializable()
class StationShiftModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  @JsonKey(name: 'station')
  final String station;

  @HiveField(2)
  @JsonKey(name: 'supervisor')
  final int supervisor;

  @HiveField(3)
  @JsonKey(name: 'shift_date')
  final String shiftDate;

  @HiveField(4)
  @JsonKey(name: 'start_time')
  final String startTime;

  @HiveField(5)
  @JsonKey(name: 'end_time')
  final String? endTime;

  @HiveField(6)
  final String status;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  @JsonKey(name: 'created_at')
  final String createdAt;

  @HiveField(9)
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  // Computed fields from backend
  @HiveField(10)
  @JsonKey(name: 'station_name')
  final String stationName;

  @HiveField(11)
  @JsonKey(name: 'supervisor_name')
  final String supervisorName;

  @HiveField(12)
  @JsonKey(name: 'tank_readings_count')
  final int tankReadingsCount;

  @HiveField(13)
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;

  StationShiftModel({
    required this.id,
    required this.station,
    required this.supervisor,
    required this.shiftDate,
    required this.startTime,
    this.endTime,
    required this.status,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    required this.stationName,
    required this.supervisorName,
    required this.tankReadingsCount,
    this.durationMinutes,
  });

  factory StationShiftModel.fromJson(Map<String, dynamic> json) =>
      _$StationShiftModelFromJson(json);

  Map<String, dynamic> toJson() => _$StationShiftModelToJson(this);

  // Computed properties
  bool get isActive => status == 'ACTIVE';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';

  String get durationText {
    final minutes = durationMinutes;
    if (minutes == null) return 'Ongoing';
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else {
      return '${remainingMinutes}m';
    }
  }

  String get formattedShiftDate {
    final date = DateTime.tryParse(shiftDate);
    if (date == null) return shiftDate;
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedStartTime {
    return _formatTime(startTime);
  }

  String? get formattedEndTime {
    if (endTime == null) return null;
    return _formatTime(endTime!);
  }

  String get statusText {
    switch (status) {
      case 'ACTIVE':
        return 'Active';
      case 'COMPLETED':
        return 'Completed';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
      case 'CANCELLED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper methods
  String _formatTime(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return time;
    
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}
