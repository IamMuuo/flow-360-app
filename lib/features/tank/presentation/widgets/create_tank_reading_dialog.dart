import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/station_shift_controller.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';

class CreateTankReadingDialog extends StatefulWidget {
  final StationShiftModel shift;

  const CreateTankReadingDialog({
    super.key,
    required this.shift,
  });

  @override
  State<CreateTankReadingDialog> createState() => _CreateTankReadingDialogState();
}

class _CreateTankReadingDialogState extends State<CreateTankReadingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _manualReadingController = TextEditingController();
  String? _selectedTankId;
  String _readingType = 'OPENING';

  @override
  void initState() {
    super.initState();
    // Load tanks when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tankController = Get.find<TankController>();
      tankController.loadTanks();
    });
  }

  TankModel? get selectedTank {
    final tankController = Get.find<TankController>();
    return tankController.tanks.firstWhereOrNull((tank) => tank.id == _selectedTankId);
  }

  @override
  void dispose() {
    _manualReadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tankController = Get.find<TankController>();
    
    // Debug logging
    print('DEBUG: Tanks count: ${tankController.tanks.length}');
    print('DEBUG: Tanks: ${tankController.tanks.map((t) => '${t.name} (${t.id})').toList()}');
    print('DEBUG: Is loading: ${tankController.isLoading.value}');
    print('DEBUG: Error message: ${tankController.errorMessage.value}');

    return AlertDialog(
      title: const Text('Create Tank Reading'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tank Selection
              Obx(() {
                if (tankController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (tankController.errorMessage.value.isNotEmpty) {
                  return Card(
                    color: Colors.red[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Error: ${tankController.errorMessage.value}',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  );
                }

                if (tankController.tanks.isEmpty) {
                  return Card(
                    color: Colors.orange[50],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            'No tanks available',
                            style: TextStyle(color: Colors.orange[700]),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => tankController.loadTanks(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  value: _selectedTankId,
                  decoration: const InputDecoration(
                    labelText: 'Select Tank',
                    prefixIcon: Icon(Icons.storage),
                  ),
                  items: tankController.tanks.map((tank) {
                    return DropdownMenuItem(
                      value: tank.id,
                      child: Text('${tank.name} (${tank.fuelTypeName})'),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a tank';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedTankId = value;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),

              // Reading Type
              DropdownButtonFormField<String>(
                value: _readingType,
                decoration: const InputDecoration(
                  labelText: 'Reading Type',
                  prefixIcon: Icon(Icons.science),
                ),
                items: const [
                  DropdownMenuItem(value: 'OPENING', child: Text('Opening Reading')),
                  DropdownMenuItem(value: 'CLOSING', child: Text('Closing Reading')),
                  DropdownMenuItem(value: 'RECONCILIATION', child: Text('Reconciliation Reading')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select reading type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _readingType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Manual Reading
              TextFormField(
                controller: _manualReadingController,
                decoration: const InputDecoration(
                  labelText: 'Manual Reading (Litres)',
                  hintText: 'Enter the manual reading...',
                  prefixIcon: Icon(Icons.edit),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter manual reading';
                  }
                  final reading = double.tryParse(value);
                  if (reading == null) {
                    return 'Please enter a valid number';
                  }
                  if (reading < 0) {
                    return 'Reading cannot be negative';
                  }
                  if (selectedTank != null && reading > selectedTank!.capacityLitresDouble) {
                    return 'Reading cannot exceed tank capacity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tank Info (if tank is selected)
              if (selectedTank != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tank Information',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow('Name', selectedTank!.name),
                        _buildInfoRow('Fuel Type', selectedTank!.fuelTypeName),
                        _buildInfoRow('Capacity', '${selectedTank!.capacityLitresDouble.toStringAsFixed(2)}L'),
                        _buildInfoRow('Current Level', '${selectedTank!.currentLevelLitresDouble.toStringAsFixed(2)}L'),
                        _buildInfoRow('Usage', '${selectedTank!.usagePercentage.toStringAsFixed(1)}%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Additional null check for safety
      if (_selectedTankId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a tank')),
        );
        return;
      }
      
      final controller = Get.find<StationShiftController>();
      
      final data = {
        'station_shift': widget.shift.id,
        'tank': _selectedTankId!,
        'reading_type': _readingType,
        'manual_reading_litres': double.parse(_manualReadingController.text),
      };

      controller.createTankReading(data);
    }
  }
}
