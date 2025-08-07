
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';

class ShiftFAB extends StatelessWidget {
  const ShiftFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShiftController>();

    return Obx(() {
      final currentShift = controller.currentShift.value;
      final isActive = currentShift != null && currentShift.endedAt == null;

      return FloatingActionButton(
        onPressed: () => _showShiftActionDialog(context, controller, isActive),
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

  void _showShiftActionDialog(BuildContext context, ShiftController controller, bool isActive) {
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
                : 'Are you sure you want to start a new shift?',
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
                        } else {
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

