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

  String _selectedFuelType = 'PMS';

  final List<Map<String, String>> _fuelTypes = [
    {'value': 'PMS', 'label': 'Petrol'},
    {'value': 'AGO', 'label': 'Diesel'},
    {'value': 'IK', 'label': 'Kerosene'},
    {'value': 'VPOWER', 'label': 'Vpower'},
  ];

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
          Icon(Icons.add_circle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Create New Tank'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tank name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tank Name',
                  hintText: 'e.g., Tank 1, Main Tank',
                  prefixIcon: Icon(Icons.storage),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter tank name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fuel type dropdown
              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                decoration: const InputDecoration(
                  labelText: 'Fuel Type',
                  prefixIcon: Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(),
                ),
                items: _fuelTypes.map((fuelType) {
                  return DropdownMenuItem<String>(
                    value: fuelType['value'],
                    child: Text(fuelType['label']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select fuel type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Capacity
              TextFormField(
                controller: _capacityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Capacity (Litres)',
                  hintText: 'Enter tank capacity',
                  prefixIcon: Icon(Icons.straighten),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  final capacity = double.tryParse(value);
                  if (capacity == null || capacity <= 0) {
                    return 'Please enter a valid capacity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Current level
              TextFormField(
                controller: _currentLevelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Current Level (Litres)',
                  hintText: 'Enter current fuel level',
                  prefixIcon: Icon(Icons.water_drop),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current level';
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
          return ElevatedButton(
            onPressed: _tankController.isLoading.value ? null : _submitForm,
            child: _tankController.isLoading.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create Tank'),
          );
        }),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final AuthController authController = Get.find<AuthController>();

      final tankData = {
        'name': _nameController.text,
        'fuel_type': _selectedFuelType,
        'capacity_litres': _capacityController.text,
        'current_level_litres': _currentLevelController.text,
        'is_active': true,
        'station': authController.currentUser.value!.user.station,
      };

      _tankController.createTank(tankData);
    }
  }
}

