// lib/features/shift/presentation/widgets/shift_status_indicator.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';

class ShiftStatusIndicator extends StatelessWidget {
  const ShiftStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final shiftController = Get.find<ShiftController>();

    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: shiftController.hasActiveShift
                    ? [
                        Colors.green.withOpacity(0.1),
                        Colors.green.withOpacity(0.05),
                      ]
                    : [
                        Colors.grey.withOpacity(0.1),
                        Colors.grey.withOpacity(0.05),
                      ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: shiftController.hasActiveShift
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Shift Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Get.theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    if (shiftController.hasActiveShift)
                      _buildPulseAnimation(),
                  ],
                ),
                const SizedBox(height: 12),
                if (shiftController.hasActiveShift) ...[
                  _buildActiveShiftInfo(shiftController),
                ] else ...[
                  _buildInactiveShiftInfo(),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPulseAnimation() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }

  Widget _buildActiveShiftInfo(ShiftController controller) {
    final shift = controller.currentShift.value!;
    final startTime = DateTime.parse(shift.startedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 16,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            Text(
              'Active',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Started at ${DateFormat('HH:mm').format(startTime)}',
          style: TextStyle(
            fontSize: 12,
            color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        _buildDurationTimer(controller),
      ],
    );
  }

  Widget _buildInactiveShiftInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.pause_circle_outline,
              size: 16,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              'Inactive',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'No active shift',
          style: TextStyle(
            fontSize: 12,
            color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildDurationTimer(ShiftController controller) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            controller.shiftDuration,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }
}
