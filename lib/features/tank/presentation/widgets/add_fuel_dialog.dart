import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';

class AddFuelDialog extends StatefulWidget {
  final TankModel tank;

  const AddFuelDialog({
    super.key,
    required this.tank,
  });

  @override
  State<AddFuelDialog> createState() => _AddFuelDialogState();
}

class _AddFuelDialogState extends State<AddFuelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _litresController = TextEditingController();
  final _reasonController = TextEditingController();
  
  // Supplier information controllers
  final _supplierTinController = TextEditingController();
  final _supplierBhfIdController = TextEditingController();
  final _supplierNameController = TextEditingController();
  final _supplierInvoiceNoController = TextEditingController();
  
  final TankController _tankController = Get.find<TankController>();

  @override
  void initState() {
    super.initState();
    _reasonController.text = 'Manual addition';
  }

  @override
  void dispose() {
    _litresController.dispose();
    _reasonController.dispose();
    _supplierTinController.dispose();
    _supplierBhfIdController.dispose();
    _supplierNameController.dispose();
    _supplierInvoiceNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.add_circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text('Add Fuel'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tank info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.tank.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Current Level: ${widget.tank.currentLevelLitres}L / ${widget.tank.capacityLitres}L',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Litres input
                TextFormField(
                  controller: _litresController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Litres to Add',
                    hintText: 'Enter amount in litres',
                    prefixIcon: Icon(Icons.local_gas_station),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount';
                    }
                    final litres = double.tryParse(value);
                    if (litres == null || litres <= 0) {
                      return 'Please enter a valid amount';
                    }
                    final newTotal = litres + widget.tank.currentLevelLitresDouble;
                    if (newTotal > widget.tank.capacityLitresDouble) {
                      return 'Adding this amount would exceed tank capacity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Reason input
                TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    hintText: 'e.g., Fuel delivery, Manual addition',
                    prefixIcon: Icon(Icons.note),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Supplier Information Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Supplier Information (KRA VSCU Required)',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Supplier information is required for all fuel additions to comply with KRA VSCU purchase requirements.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Supplier TIN
                        TextFormField(
                          controller: _supplierTinController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier TIN *',
                            hintText: 'e.g., P123456789Z',
                            prefixIcon: Icon(Icons.numbers),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Supplier TIN is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        
                        // Supplier BHF ID
                        TextFormField(
                          controller: _supplierBhfIdController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier BHF ID *',
                            hintText: 'e.g., 00',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Supplier BHF ID is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        
                        // Supplier Name
                        TextFormField(
                          controller: _supplierNameController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier Name *',
                            hintText: 'e.g., ABC Fuel Suppliers Ltd',
                            prefixIcon: Icon(Icons.business),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Supplier name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        
                        // Supplier Invoice Number
                        TextFormField(
                          controller: _supplierInvoiceNoController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier Invoice Number *',
                            hintText: 'e.g., INV-2024-001',
                            prefixIcon: Icon(Icons.receipt),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Supplier invoice number is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
            onPressed: _tankController.isLoading.value
                ? null
                : _submitForm,
            child: _tankController.isLoading.value
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Add Fuel'),
          );
        }),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final litres = double.parse(_litresController.text);
      final reason = _reasonController.text;
      
      // Prepare supplier info for KRA VSCU compliance
      final supplierInfo = {
        'tin': _supplierTinController.text.trim(),
        'bhf_id': _supplierBhfIdController.text.trim(),
        'name': _supplierNameController.text.trim(),
        'invoice_no': _supplierInvoiceNoController.text.trim(),
      };
      
      try {
        await _tankController.addFuelToTank(
          widget.tank.id,
          litres,
          reason,
          supplierInfo: supplierInfo,
        );
        
        // Show success snackbar and close dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.add_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Fuel added successfully'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Show error snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Failed to add fuel: ${e.toString()}'),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
