import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/employees/controllers/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeProfilePage extends StatelessWidget {
  final String employeeId;

  const EmployeeProfilePage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.find<EmployeeController>();
    final employee = employeeController.employees.firstWhereOrNull(
      (e) => e.id.toString() == employeeId,
    );

    if (employee == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Employee Details')),
        body: const Center(child: Text('Employee not found.')),
      );
    }

    final hasProfilePicture =
        employee.profilePicture != null && employee.profilePicture!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text('${employee.firstName ?? 'Employee'} Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to the new edit page
              EmployeeEditPageRoute(employeeId: employeeId).push(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: hasProfilePicture
                    ? NetworkImage(employee.profilePicture!)
                    : null,
                child: !hasProfilePicture
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    '${employee.firstName ?? 'N/A'} ${employee.lastName ?? ''}',
                  ),
                  subtitle: const Text('Full Name'),
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(employee.role),
                  subtitle: const Text('Role'),
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(employee.phoneNumber ?? 'N/A'),
                  subtitle: const Text('Phone Number'),
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(employee.email ?? 'N/A'),
                  subtitle: const Text('Email'),
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: employee.isActive
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                        )
                      : const Icon(Icons.cancel_outlined, color: Colors.red),
                  title: Text(employee.isActive ? 'Active' : 'Inactive'),
                  subtitle: const Text('Status'),
                ),
              ),
              Card(
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: Text(employee.username),
                  subtitle: const Text('Username'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
