import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';

class CreateTankDialog extends StatefulWidget {
  const CreateTankDialog({super.key});

  @override
  State<CreateTankDialog> createState() => _CreateTankDialogState();
}

class _CreateTankDialogState extends State<CreateTankDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _capacityController = TextEditingController();
  final _currentLevelController = TextEditingController();
  final TankController _tankController = Get.find<TankController>();

  String? _selectedFuelTypeId;

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _currentLevelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text('Create New Tank'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info card about tank setup
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tanks store fuel and supply it to nozzles. Each tank can only hold one type of fuel.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tank name
              Text(
                'Tank Name *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tank Name',
                  hintText: 'e.g., Tank 1, Main Tank, Diesel Tank',
                  prefixIcon: Icon(Icons.storage),
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tank name';
                  }
                  if (value.length < 2) {
                    return 'Tank name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Fuel type dropdown
              Text(
                'Fuel Type *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (_tankController.fuelTypes.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Theme.of(context).colorScheme.error,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No Fuel Types Available',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please contact your administrator to set up fuel types.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return DropdownButtonFormField<String>(
                  value: _selectedFuelTypeId,
                  decoration: const InputDecoration(
                    labelText: 'Select Fuel Type',
                    hintText: 'Choose the type of fuel this tank will store',
                    prefixIcon: Icon(Icons.local_gas_station),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  items: _tankController.fuelTypes.map((fuelType) {
                    return DropdownMenuItem<String>(
                      value: fuelType['id'],
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Color(int.parse(fuelType['color_hex']?.replaceAll('#', '0xFF') ?? '0xFF808080')),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  fuelType['name'] ?? 'Unknown',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  fuelType['kra_code'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFuelTypeId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select fuel type';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 20),

              // Capacity
              Text(
                'Tank Capacity *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _capacityController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Capacity (Litres)',
                  hintText: 'e.g., 50000.00',
                  prefixIcon: Icon(Icons.straighten),
                  border: OutlineInputBorder(),
                  filled: true,
                  helperText: 'Maximum amount of fuel the tank can hold',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  final capacity = double.tryParse(value);
                  if (capacity == null || capacity <= 0) {
                    return 'Please enter a valid capacity';
                  }
                  if (capacity > 1000000) {
                    return 'Capacity cannot exceed 1,000,000 litres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Current level
              Text(
                'Initial Fuel Level',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _currentLevelController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Current Level (Litres)',
                  hintText: 'e.g., 0.00 (leave empty if tank is empty)',
                  prefixIcon: Icon(Icons.water_drop),
                  border: OutlineInputBorder(),
                  filled: true,
                  helperText: 'Current amount of fuel in the tank (optional)',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null; // Optional field
                  }
                  final level = double.tryParse(value);
                  if (level == null || level < 0) {
                    return 'Please enter a valid level';
                  }

                  final capacity = double.tryParse(_capacityController.text);
                  if (capacity != null && level > capacity) {
                    return 'Current level cannot exceed capacity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Active status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: null, // Always active for new tanks
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Enable this tank for fuel dispensing',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        Obx(() {
          return ElevatedButton.icon(
            onPressed: _tankController.isLoading.value ? null : _submitForm,
            icon: _tankController.isLoading.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add),
            label: Text(_tankController.isLoading.value ? 'Creating...' : 'Create Tank'),
          );
        }),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final AuthController authController = Get.find<AuthController>();
      
      final tankData = {
        'name': _nameController.text.trim(),
        'fuel_type': _selectedFuelTypeId,
        'capacity_litres': _capacityController.text,
        'current_level_litres': _currentLevelController.text.isEmpty 
            ? '0.00' 
            : _currentLevelController.text,
        'is_active': true,
        'station': authController.currentUser.value!.user.station,
      };

      try {
        await _tankController.createTank(tankData);
        
        // Show success snackbar and close dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Tank "${_nameController.text.trim()}" created successfully'),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
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
                  Expanded(
                    child: Text('Failed to create tank: ${e.toString()}'),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}

