import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/features/fuel_dispenser/controller/nozzle_controller.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';

const Map<String, String> _fuelTypeNames = {
  'PMS': 'Petrol',
  'AGO': 'Diesel',
  'IK': 'Kerosene',
  'VPOWER': 'Vpower',
};

String getFriendlyFuelTypeName(String fuelType) {
  return _fuelTypeNames[fuelType] ?? fuelType;
}

class DispenserDetailPage extends StatelessWidget {
  final String dispenserId;

  const DispenserDetailPage({super.key, required this.dispenserId});

  @override
  Widget build(BuildContext context) {
    // Controller for fetching dispenser data from the main list
    final dispenserController = Get.find<FuelDispenserController>();
    final dispenser = dispenserController.dispensers.firstWhereOrNull(
      (d) => d.id == dispenserId,
    );

    if (dispenser == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dispenser Not Found')),
        body: const Center(child: Text('Dispenser details not available.')),
      );
    }

    final nozzleController = Get.find<NozzleController>();
    // Fetch the nozzles for this specific dispenser
    nozzleController.fetchNozzles(dispenserId);

    return Scaffold(
      appBar: AppBar(
        title: Text(dispenser.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              EditDispenserRoute(dispenserId: dispenser.id).go(context);
            },
            icon: const Icon(Icons.edit),
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
            // Updated to use the new nozzle section
            _buildNozzleSection(context, dispenserId, nozzleController),
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

  Widget _buildNozzleSection(
    BuildContext context,
    String dispenserId,
    NozzleController nozzleController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nozzles', style: Get.textTheme.headlineSmall),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () =>
                  _showAddNozzleDialog(context, dispenserId, nozzleController),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Use Obx to directly listen to the nozzles list
        Obx(() {
          if (nozzleController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (nozzleController.errorMessage.isNotEmpty) {
            return Center(
              child: Text('Error: ${nozzleController.errorMessage.value}'),
            );
          }
          if (nozzleController.nozzles.isEmpty) {
            return const Center(child: Text('No nozzles available.'));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: nozzleController.nozzles.length,
            itemBuilder: (context, index) {
              final nozzle = nozzleController.nozzles[index];
              return Card(
                child: ListTile(
                  title: Text('Nozzle ${nozzle.nozzleNumber}'),
                  subtitle: Text(
                    'Fuel Type: ${getFriendlyFuelTypeName(nozzle.fuelType)}',
                  ),
                  trailing: Text(nozzle.isActive ? 'Active' : 'Inactive'),
                  leading: const Icon(Icons.water_drop_outlined),
                  onTap: () {
                    _showEditNozzleDialog(context, nozzle);
                  },
                ),
              );
            },
          );
        }),
      ],
    );
  }

  // lib/features/fuel_dispenser/presentation/screens/dispenser_detail_page.dart

  // ... (after _showAddNozzleDialog function)

  void _showEditNozzleDialog(BuildContext context, NozzleModel nozzle) {
    bool isActive = nozzle.isActive;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit Nozzle'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nozzle Number: ${nozzle.nozzleNumber}',
                    style: Get.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fuel Type: ${getFriendlyFuelTypeName(nozzle.fuelType)}',
                    style: Get.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Is Active'),
                      Switch(
                        value: isActive,
                        onChanged: (bool value) {
                          setState(() {
                            isActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              child: const Text('Update'),
              onPressed: () async {
                try {
                  print(nozzle.toJson());
                  final controller = Get.find<NozzleController>();
                  await controller.updateNozzle(
                    dispenserId: nozzle.dispenser,
                    nozzleId: nozzle.id,
                    fuelType: nozzle.fuelType, // Pass the existing value
                    nozzleNumber:
                        nozzle.nozzleNumber, // Pass the existing value
                    isActive: isActive, // Only this value is updated
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nozzle updated successfully!'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update nozzle: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddNozzleDialog(
    BuildContext context,
    String dispenserId,
    NozzleController controller,
  ) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nozzleNumberController =
        TextEditingController();
    String? fuelType;
    bool isActive = true;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Add New Nozzle'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Fuel Type'),
                    value: fuelType,
                    items: const [
                      DropdownMenuItem(value: 'PMS', child: Text('Petrol')),
                      DropdownMenuItem(value: 'AGO', child: Text('Diesel')),
                      DropdownMenuItem(value: 'IK', child: Text('Kerosene')),
                      DropdownMenuItem(value: 'VPOWER', child: Text('Vpower')),
                    ],
                    onChanged: (value) {
                      fuelType = value;
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a fuel type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nozzleNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Nozzle Number',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a nozzle number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Is Active'),
                          Switch(
                            value: isActive,
                            onChanged: (bool value) {
                              setState(() {
                                isActive = value;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await controller.createNozzle(
                      dispenserId: dispenserId,
                      fuelType: fuelType!,
                      nozzleNumber: int.parse(nozzleNumberController.text),
                      isActive: isActive,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nozzle added successfully!'),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add nozzle: $e')),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
