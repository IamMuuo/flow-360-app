
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';

class ShiftFAB extends StatelessWidget {
  const ShiftFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShiftController>();
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    final isSupervisor = currentUser?.user.role == 'Supervisor' || currentUser?.user.role == 'Manager';

    return Obx(() {
      final currentShift = controller.currentShift.value;
      final isActive = currentShift != null && currentShift.endedAt == null;

      // Only show FAB for supervisors, or for employees who have an active shift to end
      if (!isSupervisor && !isActive) {
        return const SizedBox.shrink();
      }

      return FloatingActionButton(
        onPressed: () => _showShiftActionDialog(context, controller, isActive, isSupervisor),
        backgroundColor: isActive 
            ? Colors.red 
            : Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: Icon(
          isActive ? Icons.stop : Icons.play_arrow,
        ),
      );
    });
  }

  void _showShiftActionDialog(BuildContext context, ShiftController controller, bool isActive, bool isSupervisor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isActive ? 'End Shift' : 'Start Shift',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          content: Text(
            isActive 
                ? 'Are you sure you want to end your current shift?'
                : isSupervisor
                    ? 'Are you sure you want to start a new shift?'
                    : 'Only supervisors can start shifts. Please contact your supervisor.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
            if (isActive || isSupervisor)
              Obx(() => ElevatedButton(
                onPressed: (isActive ? controller.isEndingShift.value : controller.isStartingShift.value)
                    ? null
                    : () async {
                        Navigator.of(context).pop();
                        try {
                          if (isActive) {
                            await controller.endShift();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Shift ended successfully!'),
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          } else if (isSupervisor) {
                            await controller.startShift();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Shift started successfully!'),
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Theme.of(context).colorScheme.error,
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: isActive ? Colors.red : Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: (isActive ? controller.isEndingShift.value : controller.isStartingShift.value)
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(isActive ? 'End Shift' : 'Start Shift'),
            )),
          ],
        );
      },
    );
  }
}

