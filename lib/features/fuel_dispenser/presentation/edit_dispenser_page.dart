// lib/features/fuel_dispenser/presentation/screens/edit_dispenser_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:go_router/go_router.dart';

class EditDispenserPage extends StatefulWidget {
  final String dispenserId;

  const EditDispenserPage({super.key, required this.dispenserId});

  @override
  State<EditDispenserPage> createState() => _EditDispenserPageState();
}

class _EditDispenserPageState extends State<EditDispenserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  DateTime? _selectedInstalledDate;
  bool _isActive = true;

  late final FuelDispenserController _controller;
  late final FuelDispenserModel _initialDispenser;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FuelDispenserController>();
    _initialDispenser = _controller.dispensers.firstWhere(
      (d) => d.id == widget.dispenserId,
    );

    // Pre-populate the form with existing data
    _nameController.text = _initialDispenser.name;
    _serialNumberController.text = _initialDispenser.serialNumber;
    _manufacturerController.text = _initialDispenser.manufacturer;
    _selectedInstalledDate = DateTime.tryParse(_initialDispenser.installedAt);
    _isActive = _initialDispenser.isActive;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialNumberController.dispose();
    _manufacturerController.dispose();
    super.dispose();
  }

  // ... (_selectDate method remains the same)

  Future<void> _updateDispenser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _controller.updateFuelDispenser(
          stationId: _initialDispenser.station,
          dispenserId: widget.dispenserId,
          name: _nameController.text,
          serialNumber: _serialNumberController.text,
          manufacturer: _manufacturerController.text,
          installedAt: _selectedInstalledDate!.toIso8601String().split('T')[0],
          isActive: _isActive,
        );

        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispenser updated successfully!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on Failure catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update dispenser: ${e.message}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedInstalledDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedInstalledDate) {
      setState(() {
        _selectedInstalledDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (Your build method is the same as CreateDispenserPage, but the onPressed callback is different)
    // Make sure to change the button text to 'Update Dispenser' and the onPressed to _updateDispenser
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Dispenser'), centerTitle: true),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Dispenser Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a dispenser name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _serialNumberController,
              decoration: const InputDecoration(
                labelText: 'Serial Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a serial number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _manufacturerController,
              decoration: const InputDecoration(
                labelText: 'Manufacturer',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a manufacturer';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                _selectedInstalledDate == null
                    ? 'Select Installed Date'
                    : 'Installed Date: ${_selectedInstalledDate!.toLocal().toString().split(' ')[0]}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Is Active'),
                Switch(
                  value: _isActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _updateDispenser, // <-- Change here
              icon: const Icon(Icons.save),
              label: const Text('Update Dispenser'), // <-- Change here
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
