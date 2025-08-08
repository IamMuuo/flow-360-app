// lib/features/shift/presentation/screens/shift_management_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';
import 'package:flow_360/features/shift/models/shift_model.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';

class ShiftManagementScreen extends StatelessWidget {
  const ShiftManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shiftController = Get.put(ShiftController());

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Shift Management',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Get.theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (shiftController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await shiftController.loadShifts();
            await shiftController.checkCurrentShift();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentShiftCard(shiftController),
                const SizedBox(height: 24),
                _buildShiftActions(shiftController),
                const SizedBox(height: 24),
                _buildShiftHistory(shiftController),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCurrentShiftCard(ShiftController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 8,
        shadowColor: Get.theme.colorScheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: controller.hasActiveShift
                  ? [
                      Get.theme.colorScheme.primary,
                      Get.theme.colorScheme.primary.withOpacity(0.8),
                    ]
                  : [
                      Get.theme.colorScheme.surface,
                      Get.theme.colorScheme.surface,
                    ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.hasActiveShift
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    controller.hasActiveShift ? 'Active Shift' : 'No Active Shift',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: controller.hasActiveShift
                          ? Colors.white
                          : Get.theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (controller.hasActiveShift) ...[
                _buildShiftInfo(controller),
                const SizedBox(height: 16),
                _buildShiftTimer(controller),
              ] else ...[
                Text(
                  'You are not currently on shift',
                  style: TextStyle(
                    fontSize: 14,
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShiftInfo(ShiftController controller) {
    final shift = controller.currentShift.value!;
    final startTime = DateTime.parse(shift.startedAt);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Started at ${DateFormat('HH:mm').format(startTime)}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, MMMM d, y').format(startTime),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildShiftTimer(ShiftController controller) {
    return TweenAnimationBuilder<Duration>(
      tween: Tween(begin: Duration.zero, end: Duration.zero),
      duration: const Duration(seconds: 1),
      builder: (context, duration, child) {
        return StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.shiftDuration,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShiftActions(ShiftController controller) {
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    final isSupervisor = currentUser?.user.role == 'Supervisor' || currentUser?.user.role == 'Manager';
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shift Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            
            if (isSupervisor) ...[
              // Show start/end shift buttons for supervisors
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      controller,
                      title: 'Start Shift',
                      icon: Icons.play_arrow,
                      color: Colors.green,
                      isLoading: controller.isStartingShift.value,
                      onPressed: controller.hasActiveShift ? null : controller.startShift,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionButton(
                      controller,
                      title: 'End Shift',
                      icon: Icons.stop,
                      color: Colors.red,
                      isLoading: controller.isEndingShift.value,
                      onPressed: controller.hasActiveShift ? controller.endShift : null,
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Show informational message for employees
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Get.theme.colorScheme.primary.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Get.theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Shift Management',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Only supervisors and managers can start shifts. Please contact your supervisor to begin your shift.',
                      style: TextStyle(
                        color: Get.theme.colorScheme.onPrimaryContainer,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Show end shift button for employees (if they have an active shift)
              if (controller.hasActiveShift)
                SizedBox(
                  width: double.infinity,
                  child: _buildActionButton(
                    controller,
                    title: 'End Shift',
                    icon: Icons.stop,
                    color: Colors.red,
                    isLoading: controller.isEndingShift.value,
                    onPressed: controller.endShift,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    ShiftController controller, {
    required String title,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback? onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: isLoading ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildShiftHistory(ShiftController controller) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shift History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${controller.shifts.length} shifts',
                  style: TextStyle(
                    fontSize: 12,
                    color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (controller.shifts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 48,
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No shifts yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.shifts.length,
                itemBuilder: (context, index) {
                  final shift = controller.shifts[index];
                  return _buildShiftHistoryItem(shift, index);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftHistoryItem(ShiftModel shift, int index) {
    final startTime = DateTime.parse(shift.startedAt);
    final endTime = shift.endedAt != null ? DateTime.parse(shift.endedAt!) : null;
    final duration = endTime != null ? endTime.difference(startTime) : null;
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutBack,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Get.theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: shift.isActive ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('MMM d, y').format(startTime),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${DateFormat('HH:mm').format(startTime)} - ${endTime != null ? DateFormat('HH:mm').format(endTime) : 'Ongoing'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (duration != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${duration.inHours}h ${duration.inMinutes % 60}m',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
