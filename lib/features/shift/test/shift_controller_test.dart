// lib/features/shift/test/shift_controller_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';
import 'package:flow_360/features/shift/models/shift_model.dart';

void main() {
  group('ShiftController Tests', () {
    late ShiftController controller;

    setUp(() {
      controller = ShiftController();
    });

    tearDown(() {
      Get.reset();
    });

    test('should initialize with no active shift', () {
      expect(controller.hasActiveShift, false);
      expect(controller.currentShift.value, null);
    });

    test('should calculate shift duration correctly', () {
      // Create a mock shift that started 2 hours ago
      final mockShift = ShiftModel(
        id: 'test-id',
        startedAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        endedAt: null,
        isActive: true,
        createdAt: DateTime.now().toIso8601String(),
        station: 'test-station',
        employee: 1,
      );

      controller.currentShift.value = mockShift;
      
      final duration = controller.shiftDuration;
      expect(duration, contains('2h'));
    });

    test('should clear error message', () {
      controller.errorMessage.value = 'Test error';
      controller.clearError();
      expect(controller.errorMessage.value, '');
    });

    test('should have correct initial state', () {
      expect(controller.isLoading.value, false);
      expect(controller.isStartingShift.value, false);
      expect(controller.isEndingShift.value, false);
      expect(controller.shifts.length, 0);
    });
  });
}
