import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/employees/controllers/employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeManagementPage extends StatelessWidget {
  const EmployeeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.put(EmployeeController());
    final userController = Get.find<AuthController>();

    // Correctly get the stationId directly from the user model
    final stationId = userController.currentUser.value?.user.station;
    if (stationId != null) {
      employeeController.fetchEmployees(stationId: stationId);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Attendants'), centerTitle: true),
      body: Obx(() {
        if (employeeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (employeeController.errorMessage.isNotEmpty) {
          return Center(child: Text(employeeController.errorMessage.value));
        }

        if (employeeController.employees.isEmpty) {
          return const Center(child: Text('No employees found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: employeeController.employees.length,
          itemBuilder: (context, index) {
            final employee = employeeController.employees[index];
            return _EmployeeCard(employee: employee);
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          EmployeeCreatePageRoute().push(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final UserModel employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    final employeeController = Get.find<EmployeeController>();
    // final hasProfilePicture =
    //     employee.profilePicture != null && employee.profilePicture!.isNotEmpty;

    // Safely get the first letter, handling potential null or empty strings
    final firstLetter = (employee.firstName?.isNotEmpty ?? false)
        ? employee.firstName![0].toUpperCase()
        : '?';

    return Card(
      elevation: 0,
      color: employee.isActive
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.errorContainer,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            firstLetter,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text('${employee.firstName ?? ''} ${employee.lastName ?? ''}'),
        subtitle: Text('Phone: ${employee.phoneNumber ?? 'N/A'}'),
        trailing: Switch(
          value: employee.isActive,
          onChanged: (bool value) async {
            try {
              await employeeController.updateEmployee(employee.id.toString(), {
                'is_active': value,
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Status updated for ${employee.firstName}'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update status: $e')),
              );
            }
          },
        ),
        onTap: () {
          EmployeeDetailsPageRoute(
            employeeId: employee.id.toString(),
          ).push(context);
        },
      ),
    );
  }
}
