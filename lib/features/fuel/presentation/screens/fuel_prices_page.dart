import 'package:flow_360/core/failure.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/fuel/controllers/fuel_price_controller.dart';
import 'package:flow_360/features/fuel/models/fuel_price_model.dart';
import 'package:go_router/go_router.dart';

class FuelPricesPage extends StatelessWidget {
  const FuelPricesPage({super.key});

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

    final controller = Get.put(FuelPriceController());
    controller.fetchFuelPrices(stationId);

    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Prices'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: controller.obx(
          (state) {
            return _buildPriceList(state!);
          },
          onLoading: const Center(child: CircularProgressIndicator()),
          onEmpty: const Center(child: Text('No fuel prices available.')),
          onError: (error) => Center(child: Text('Error: $error')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            _showAddFuelPriceDialog(context, controller, stationId),
        label: const Text('Add Fuel Price'),
        icon: const Icon(Icons.local_gas_station),
      ),
    );
  }

  Widget _buildPriceList(List<FuelPriceModel> prices) {
    return ListView.builder(
      itemCount: prices.length,
      itemBuilder: (context, index) {
        final price = prices[index];

        // Safely parse the price string to a double
        final priceValue = double.tryParse(price.pricePerLitre) ?? 0.0;

        // Safely parse the created_at string to a DateTime
        final lastUpdated =
            DateTime.tryParse(price.createdAt) ?? DateTime.now();
        final Color cardColor = Color(
          int.parse(price.colorHex.substring(1), radix: 16),
        ).withAlpha(50);

        return Card(
          color: cardColor,
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text(price.fuelName),
            trailing: Text(
              '${priceValue.toStringAsFixed(2)} KES',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            subtitle: Text(
              'Last updated: ${lastUpdated.toLocal().toString().split('.')[0]}',
            ),
          ),
        );
      },
    );
  }

  void _showAddFuelPriceDialog(
    BuildContext context,
    FuelPriceController controller,
    String stationId,
  ) {
    // ... (Your existing _showAddFuelPriceDialog widget, now using the stationId parameter)
    const List<String> fuelTypes = ['PMS', 'AGO', 'IK', 'VPOWER'];

    String? selectedFuelType; // Holds the selected value
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Fuel Price'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Fuel Type'),
                value: selectedFuelType,
                items: fuelTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedFuelType = newValue;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price per Litre'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final price = double.tryParse(priceController.text);
                // Check if a fuel type and a valid price have been selected
                // if (selectedFuelType != null && price != null) {
                //   await controller.updateFuelPrice(
                //     stationId: stationId,
                //     fuelType: selectedFuelType!,
                //     newPrice: price,
                //   );
                // } else {
                //   Get.snackbar(
                //     'Invalid Input',
                //     'Please select a fuel type and enter a valid price.',
                //     snackPosition: SnackPosition.BOTTOM,
                //   );
                // }

                if (selectedFuelType != null && price != null) {
                  // Use a try-catch block here to handle the Failure
                  try {
                    await controller.updateFuelPrice(
                      stationId: stationId,
                      fuelType: selectedFuelType!,
                      newPrice: price,
                    );

                    // Close the dialog and show a success message
                    if (!context.mounted) return;
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fuel price updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } on Failure catch (e) {
                    // Catch the specific Failure and show its message
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Update Failed: ${e.message}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Validation error: Please ensure you fill the form',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
