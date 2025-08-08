// lib/features/shift/presentation/screens/shift_demo_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/shift/presentation/widgets/shift_status_indicator.dart';
import 'package:flow_360/features/shift/presentation/widgets/shift_fab.dart';

class ShiftDemoScreen extends StatelessWidget {
  const ShiftDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shiftController = Get.put(ShiftController());
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    final isSupervisor = currentUser?.user.role == 'Supervisor' || currentUser?.user.role == 'Manager';

    return Scaffold(
      backgroundColor: Get.theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Shift Demo',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Get.theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
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
              // Quick Actions Card
              Card(
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
                        'Quick Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Get.theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        return Row(
                          children: [
                            if (isSupervisor) ...[
                              Expanded(
                                child: _buildQuickActionButton(
                                  title: 'Start Shift',
                                  icon: Icons.play_arrow,
                                  color: Colors.green,
                                  onPressed: shiftController.hasActiveShift 
                                      ? null 
                                      : () => shiftController.startShift(),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: _buildQuickActionButton(
                                title: 'End Shift',
                                icon: Icons.stop,
                                color: Colors.red,
                                onPressed: shiftController.hasActiveShift 
                                    ? () => shiftController.endShift()
                                    : null,
                              ),
                            ),
                          ],
                        );
                      }),
                      if (!isSupervisor) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Get.theme.colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Get.theme.colorScheme.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Only supervisors can start shifts. Contact your supervisor.',
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.onPrimaryContainer,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const ShiftFAB(),
    );
  }

  Widget _buildQuickActionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: onPressed != null ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Row(
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
    );
  }

  Widget _buildInstructionItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Get.theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
