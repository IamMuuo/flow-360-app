import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/station_shift_controller.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';

class ReconcileReadingDialog extends StatefulWidget {
  final TankReadingModel reading;

  const ReconcileReadingDialog({
    super.key,
    required this.reading,
  });

  @override
  State<ReconcileReadingDialog> createState() => _ReconcileReadingDialogState();
}

class _ReconcileReadingDialogState extends State<ReconcileReadingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  bool _isReconciled = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reconcile Tank Reading'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Reading Information
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reading Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('Tank', widget.reading.tankName),
                      _buildInfoRow('Type', widget.reading.readingTypeText),
                      _buildInfoRow('Manual Reading', '${widget.reading.manualReadingLitres.toStringAsFixed(2)}L'),
                      if (widget.reading.systemReadingLitres != null)
                        _buildInfoRow('System Reading', '${widget.reading.systemReadingLitres!.toStringAsFixed(2)}L'),
                      if (widget.reading.hasVariance) ...[
                        _buildInfoRow('Variance', widget.reading.varianceText, color: widget.reading.varianceColor),
                        _buildInfoRow('Variance %', widget.reading.variancePercentageText, color: widget.reading.varianceColor),
                        _buildInfoRow('Status', widget.reading.varianceStatusText, color: widget.reading.varianceColor),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Reconciliation Options
              Text(
                'Reconciliation Options',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Mark as Reconciled
              CheckboxListTile(
                title: const Text('Mark as Reconciled'),
                subtitle: const Text('Update tank level to manual reading'),
                value: _isReconciled,
                onChanged: (value) {
                  setState(() {
                    _isReconciled = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Reconciliation Notes',
                  hintText: 'Explain the reason for reconciliation...',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
                validator: (value) {
                  if (_isReconciled && (value == null || value.trim().isEmpty)) {
                    return 'Notes are required when marking as reconciled';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Warning
              if (widget.reading.hasVariance) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orange[700],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This reading has a variance of ${widget.reading.varianceText} (${widget.reading.variancePercentageText}). Please provide a reason for reconciliation.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Reconcile'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: color != null ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<StationShiftController>();
      
      final data = {
        'is_reconciled': _isReconciled,
        if (_notesController.text.trim().isNotEmpty) 'reconciliation_notes': _notesController.text.trim(),
      };

      controller.reconcileTankReading(widget.reading.id, data);
    }
  }
}
