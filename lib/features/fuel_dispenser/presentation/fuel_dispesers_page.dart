import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';

class FuelDispensersPage extends StatelessWidget {
  const FuelDispensersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AuthController to access the current user's data
    final authController = Get.find<AuthController>();
    final stationId = authController.currentUser.value?.user.station;

    if (stationId == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No station found for this user.')),
      );
    }

    // Use Get.put to initialize the controller and make it available in the widget tree.
    // The instance is retrieved from GetIt's service locator.
    final controller = Get.find<FuelDispenserController>();
    controller.fetchFuelDispensers(stationId);

    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Dispensers'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: controller.obx(
          (state) {
            return _buildDispenserList(state!);
          },
          onLoading: const Center(child: CircularProgressIndicator()),
          onEmpty: const Center(child: Text('No fuel dispensers available.')),
          onError: (error) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final authController = Get.find<AuthController>();
          final stationId = authController.currentUser.value?.user.station;

          if (stationId != null) {
            // Use the generated method with the required parameter
            CreateFuelDispenserRoute(stationId: stationId).push(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not find station ID.')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDispenserList(List<FuelDispenserModel> dispensers) {
    return ListView.builder(
      itemCount: dispensers.length,
      itemBuilder: (context, index) {
        final dispenser = dispensers[index];
        // final installedDate =
        //     DateTime.tryParse(dispenser.installedAt) ?? DateTime.now();

        return Card(
          color: dispenser.isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.errorContainer,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () {
              DispenserDetailsRoute(dispenserId: dispenser.id).push(context);
            },
            title: Text(dispenser.name),
            subtitle: Text(
              'Serial: ${dispenser.serialNumber}\nManufacturer: ${dispenser.manufacturer}',
            ),
            trailing: Text(dispenser.isActive ? 'Active' : 'Inactive'),
            leading: const Icon(Icons.local_gas_station_outlined),
          ),
        );
      },
    );
  }
}
