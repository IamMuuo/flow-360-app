import 'package:flow_360/config/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';

class DispenserDetailPage extends StatelessWidget {
  final String dispenserId;

  const DispenserDetailPage({super.key, required this.dispenserId});

  @override
  Widget build(BuildContext context) {
    // We'll use Get.put to get a new instance of the controller if needed
    // or find the existing one
    final controller = Get.find<FuelDispenserController>();
    final dispenser = controller.dispensers.firstWhereOrNull(
      (d) => d.id == dispenserId,
    );

    if (dispenser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dispenser Not Found')),
        body: const Center(child: Text('Dispenser details not available.')),
      );
    }

    // You will add the UI for viewing, adding, and updating nozzles here later.
    return Scaffold(
      appBar: AppBar(
        title: Text(dispenser.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              EditDispenserRoute(dispenserId: dispenser.id).go(context);
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDispenserInfo(dispenser),
            const Divider(height: 32),
            _buildNozzleSection(context), // Placeholder for nozzle management
          ],
        ),
      ),
    );
  }

  Widget _buildDispenserInfo(FuelDispenserModel dispenser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dispenser Information', style: Get.textTheme.headlineSmall),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('Serial Number'),
          subtitle: Text(dispenser.serialNumber),
        ),
        ListTile(
          leading: const Icon(Icons.business),
          title: const Text('Manufacturer'),
          subtitle: Text(dispenser.manufacturer),
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Installed At'),
          subtitle: Text(dispenser.installedAt),
        ),
        ListTile(
          leading: const Icon(Icons.check_circle),
          title: const Text('Status'),
          subtitle: Text(dispenser.isActive ? 'Active' : 'Inactive'),
          trailing: Icon(
            dispenser.isActive ? Icons.circle : Icons.do_not_disturb_on,
            color: dispenser.isActive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildNozzleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nozzles', style: Get.textTheme.headlineSmall),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                // TODO: Implement navigation to add nozzle page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Add Nozzle functionality coming soon!'),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Center(child: Text('Nozzles will be displayed here.')),
      ],
    );
  }
}
