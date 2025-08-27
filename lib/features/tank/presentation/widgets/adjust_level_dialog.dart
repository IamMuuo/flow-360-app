import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';

class AdjustLevelDialog extends StatefulWidget {
  final TankModel tank;

  const AdjustLevelDialog({
    super.key,
    required this.tank,
  });

  @override
  State<AdjustLevelDialog> createState() => _AdjustLevelDialogState();
}

class _AdjustLevelDialogState extends State<AdjustLevelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _levelController = TextEditingController();
  final _reasonController = TextEditingController();
  final TankController _tankController = Get.find<TankController>();

  @override
  void initState() {
    super.initState();
    _levelController.text = widget.tank.currentLevelLitres;
    _reasonController.text = 'Manual adjustment';
  }

  @override
  void dispose() {
    _levelController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.tune,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('Adjust Tank Level'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tank info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tank.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Current Level: ${widget.tank.currentLevelLitres}L / ${widget.tank.capacityLitres}L',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // New level input
            TextFormField(
              controller: _levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New Level (Litres)',
                hintText: 'Enter new tank level',
                prefixIcon: Icon(Icons.straighten),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the new level';
                }
                final level = double.tryParse(value);
                if (level == null || level < 0) {
                  return 'Please enter a valid level';
                }
                if (level > widget.tank.capacityLitresDouble) {
                  return 'Level cannot exceed tank capacity';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Reason input
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                hintText: 'e.g., Manual adjustment, Calibration',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a reason';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Obx(() {
          return ElevatedButton(
            onPressed: _tankController.isLoading.value
                ? null
                : _submitForm,
            child: _tankController.isLoading.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Adjust Level'),
          );
        }),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newLevel = double.parse(_levelController.text);
      final reason = _reasonController.text;
      
      try {
        await _tankController.adjustTankLevel(
          widget.tank.id,
          newLevel,
          reason,
        );
        
        // Show success snackbar and close dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.tune, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Tank level adjusted successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Failed to adjust tank level: ${e.toString()}'),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}

