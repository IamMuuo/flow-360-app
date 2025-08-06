// lib/features/fuel_dispenser/presentation/screens/create_fuel_dispenser_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/core/failure.dart';
import 'package:go_router/go_router.dart'; // Assuming you have a Failure class

class CreateFuelDispenserPage extends StatefulWidget {
  final String
  stationId; // The ID of the station to associate the dispenser with

  const CreateFuelDispenserPage({super.key, required this.stationId});

  @override
  State<CreateFuelDispenserPage> createState() =>
      _CreateFuelDispenserPageState();
}

class _CreateFuelDispenserPageState extends State<CreateFuelDispenserPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  DateTime? _selectedInstalledDate;
  bool _isActive = true;

  late final FuelDispenserController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FuelDispenserController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _serialNumberController.dispose();
    _manufacturerController.dispose();
    super.dispose();
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

  Future<void> _createDispenser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _controller.createFuelDispenser(
          stationId: widget.stationId,
          name: _nameController.text,
          serialNumber: _serialNumberController.text,
          manufacturer: _manufacturerController.text,
          installedAt: _selectedInstalledDate!.toIso8601String().split(
            'T',
          )[0], // Format to YYYY-MM-DD
          isActive: _isActive,
        );

        if (mounted) {
          context.pop();
          // Pop the current page and show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fuel dispenser created successfully!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } on Failure catch (e) {
        // Show specific error message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create dispenser: ${e.message}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        // Catch any other unexpected errors

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Dispenser'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
                      : 'Installed Date: ${(_selectedInstalledDate!).toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
              // Manual validation for date as it's not a TextFormField
              if (_selectedInstalledDate == null &&
                  _formKey.currentState?.validate() == true)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text(
                    'Please select an installed date',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
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
                onPressed: _createDispenser,
                icon: const Icon(Icons.save),
                label: const Text('Create Dispenser'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
