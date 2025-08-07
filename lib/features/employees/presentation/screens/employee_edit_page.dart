import 'dart:io';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/employees/controllers/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeEditPage extends StatefulWidget {
  final String employeeId;

  const EmployeeEditPage({super.key, required this.employeeId});

  @override
  State<EmployeeEditPage> createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _selectedImage;
  late final EmployeeController _controller;
  UserModel? _employee;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<EmployeeController>();
    _employee = _controller.employees.firstWhereOrNull(
      (e) => e.id.toString() == widget.employeeId,
    );
    _firstNameController = TextEditingController(
      text: _employee?.firstName ?? '',
    );
    _lastNameController = TextEditingController(
      text: _employee?.lastName ?? '',
    );
    _phoneNumberController = TextEditingController(
      text: _employee?.phoneNumber ?? '',
    );
    _isActive = _employee?.isActive ?? false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      if (_employee == null) return;

      try {
        final data = {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'phone_number': _phoneNumberController.text,
          'is_active': _isActive,
        };
        await _controller.updateEmployee(_employee!.id.toString(), data);

        if (_selectedImage != null) {
          await _controller.uploadProfilePicture(
            employeeId: _employee!.id.toString(),
            imageFile: _selectedImage!,
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Employee updated successfully!"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } on Failure catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update employee: ${e.message}"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update employee: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_employee == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Employee')),
        body: const Center(child: Text('Employee not found.')),
      );
    }

    final hasExistingPicture =
        _employee!.profilePicture != null &&
        _employee!.profilePicture!.isNotEmpty;
    final displayImage = _selectedImage != null
        ? FileImage(_selectedImage!)
        : (hasExistingPicture
              ? NetworkImage(_employee!.profilePicture!)
              : null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _saveChanges),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: displayImage == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          child: Icon(Icons.camera_alt, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'First Name cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Last Name cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) =>
                      value!.isEmpty ? 'Phone Number cannot be empty' : null,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Is Active'),
                  value: _isActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
