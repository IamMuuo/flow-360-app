import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';

class AdjustLevelDialog extends StatefulWidget {
  final TankModel tank;

  const AdjustLevelDialog({
    super.key,
    required this.tank,
  });

  @override
  State<AdjustLevelDialog> createState() => _AdjustLevelDialogState();
}

class _AdjustLevelDialogState extends State<AdjustLevelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _levelController = TextEditingController();
  final _reasonController = TextEditingController();
  final TankController _tankController = Get.find<TankController>();
  
  // Supplier information controllers
  final _supplierTinController = TextEditingController();
  final _supplierBhfIdController = TextEditingController();
  final _supplierNameController = TextEditingController();
  final _supplierInvoiceNoController = TextEditingController();
  
  // State variables
  bool _isPurchaseMode = false;

  @override
  void initState() {
    super.initState();
    _levelController.text = widget.tank.currentLevelLitres;
    _reasonController.text = 'Manual adjustment';
  }

  @override
  void dispose() {
    _levelController.dispose();
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
            _isPurchaseMode ? Icons.shopping_cart : Icons.tune,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(_isPurchaseMode ? 'Purchase Fuel' : 'Adjust Tank Level'),
        ],
      ),
      content: Form(
        key: _formKey,
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
            
            // New level input
            TextFormField(
              controller: _levelController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New Level (Litres)',
                hintText: 'Enter new tank level',
                prefixIcon: Icon(Icons.straighten),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the new level';
                }
                final level = double.tryParse(value);
                if (level == null || level < 0) {
                  return 'Please enter a valid level';
                }
                if (level > widget.tank.capacityLitresDouble) {
                  return 'Level cannot exceed tank capacity';
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
                hintText: 'e.g., Manual adjustment, Calibration',
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
            
            // Purchase mode toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Purchase Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enable this if you are adding fuel from a supplier (will create KRA purchase transaction)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('This is a fuel purchase'),
                      value: _isPurchaseMode,
                      onChanged: (value) {
                        setState(() {
                          _isPurchaseMode = value;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            
            // Supplier information (only show if purchase mode is enabled)
            if (_isPurchaseMode) ...[
              const SizedBox(height: 16),
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
                          const Text(
                            'Supplier Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Supplier TIN
                      TextFormField(
                        controller: _supplierTinController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier TIN',
                          hintText: 'e.g., P123456789Z',
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(),
                        ),
                        validator: _isPurchaseMode ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Supplier TIN is required for purchases';
                          }
                          return null;
                        } : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Supplier BHF ID
                      TextFormField(
                        controller: _supplierBhfIdController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier BHF ID',
                          hintText: 'e.g., 00',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        validator: _isPurchaseMode ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Supplier BHF ID is required for purchases';
                          }
                          return null;
                        } : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Supplier Name
                      TextFormField(
                        controller: _supplierNameController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier Name',
                          hintText: 'e.g., ABC Fuel Suppliers Ltd',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(),
                        ),
                        validator: _isPurchaseMode ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Supplier name is required for purchases';
                          }
                          return null;
                        } : null,
                      ),
                      const SizedBox(height: 12),
                      
                      // Supplier Invoice Number
                      TextFormField(
                        controller: _supplierInvoiceNoController,
                        decoration: const InputDecoration(
                          labelText: 'Supplier Invoice Number',
                          hintText: 'e.g., INV-2024-001',
                          prefixIcon: Icon(Icons.receipt),
                          border: OutlineInputBorder(),
                        ),
                        validator: _isPurchaseMode ? (value) {
                          if (value == null || value.isEmpty) {
                            return 'Supplier invoice number is required for purchases';
                          }
                          return null;
                        } : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
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
                : Text(_isPurchaseMode ? 'Purchase Fuel' : 'Adjust Level'),
          );
        }),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final newLevel = double.parse(_levelController.text);
      final reason = _reasonController.text;
      
      // Prepare supplier info if in purchase mode
      Map<String, dynamic>? supplierInfo;
      if (_isPurchaseMode) {
        supplierInfo = {
          'tin': _supplierTinController.text.trim(),
          'bhf_id': _supplierBhfIdController.text.trim(),
          'name': _supplierNameController.text.trim(),
          'invoice_no': _supplierInvoiceNoController.text.trim(),
        };
      }
      
      try {
        await _tankController.adjustTankLevel(
          widget.tank.id,
          newLevel,
          reason,
          supplierInfo: supplierInfo,
        );
        
        // Show success snackbar and close dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    _isPurchaseMode ? Icons.shopping_cart : Icons.tune,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isPurchaseMode 
                      ? 'Fuel purchase completed successfully'
                      : 'Tank level adjusted successfully',
                  ),
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
                  Text('Failed to adjust tank level: ${e.toString()}'),
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

