
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/shift/controllers/shift_readings_controller.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/shift/models/station_shift_model.dart';

class NozzleReadingsScreen extends StatefulWidget {
  const NozzleReadingsScreen({super.key});

  @override
  State<NozzleReadingsScreen> createState() => _NozzleReadingsScreenState();
}

class _NozzleReadingsScreenState extends State<NozzleReadingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load station data when screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<ShiftReadingsController>();
      controller.loadStationData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ShiftReadingsController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Nozzle Readings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        // Show error messages
        if (controller.errorMessage.value.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(controller.errorMessage.value),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
            controller.clearError();
          });
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadStationData();
            if (controller.currentShift.value != null) {
              await controller.loadShiftReadings(controller.currentShift.value!.id);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInstructionsCard(context),
                const SizedBox(height: 24),
                _buildNozzlesList(context, controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInstructionsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Recording Instructions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Record opening readings at the start of your shift\n'
            '• Record closing readings at the end of your shift\n'
            '• Ensure readings match the physical meter displays\n'
            '• System will automatically calculate variances\n'
            '• Readings should be cumulative totals',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNozzlesList(BuildContext context, ShiftReadingsController controller) {
    // Add debugging information
    print('NozzleReadingsScreen: stationNozzles.length = ${controller.stationNozzles.length}');
    
    if (controller.stationNozzles.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.local_gas_station,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No Nozzles Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No nozzles are configured for this station.\nPull down to refresh.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => controller.loadStationData(),
              child: const Text('Load Nozzles'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Station Nozzles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.stationNozzles.length,
          itemBuilder: (context, index) {
            final nozzle = controller.stationNozzles[index];
            return _buildNozzleCard(context, nozzle, controller);
          },
        ),
      ],
    );
  }

  Widget _buildNozzleCard(
    BuildContext context,
    ShiftNozzleModel nozzle,
    ShiftReadingsController controller,
  ) {
    final openingReading = controller.getNozzleReading(nozzle.id, 'OPENING');
    final closingReading = controller.getNozzleReading(nozzle.id, 'CLOSING');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: nozzle.isActive 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nozzle ${nozzle.nozzleNumber}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${nozzle.fuelTypeName} - ${nozzle.dispenser}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${nozzle.currentReading.toStringAsFixed(2)}L',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Total: ${nozzle.totalDispensed.toStringAsFixed(2)}L',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildReadingButton(
                  context,
                  'Opening',
                  openingReading?.manualReading,
                  openingReading?.hasVariance == true,
                  () => _showReadingDialog(context, controller, nozzle, 'OPENING', openingReading),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildReadingButton(
                  context,
                  'Closing',
                  closingReading?.manualReading,
                  closingReading?.hasVariance == true,
                  () => _showReadingDialog(context, controller, nozzle, 'CLOSING', closingReading),
                ),
              ),
            ],
          ),
          if (openingReading != null && closingReading != null) ...[
            const SizedBox(height: 16),
            _buildVarianceInfo(context, openingReading, closingReading),
          ],
        ],
      ),
    );
  }

  Widget _buildReadingButton(
    BuildContext context,
    String label,
    double? reading,
    bool hasVariance,
    VoidCallback onTap,
  ) {
    final isRecorded = reading != null;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isRecorded 
            ? (hasVariance 
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.primaryContainer)
            : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isRecorded 
              ? (hasVariance 
                  ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                  : Theme.of(context).colorScheme.primary.withOpacity(0.3))
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isRecorded 
                  ? (hasVariance 
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            if (isRecorded) ...[
              Text(
                '${reading!.toStringAsFixed(2)}L',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isRecorded 
                    ? (hasVariance 
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary)
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(
                hasVariance ? Icons.warning : Icons.check_circle,
                size: 16,
                color: hasVariance 
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              ),
            ] else ...[
              Text(
                'Not Recorded',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(
                Icons.add_circle_outline,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVarianceInfo(
    BuildContext context,
    NozzleReadingModel openingReading,
    NozzleReadingModel closingReading,
  ) {
    final variance = closingReading.variance ?? 0;
    final variancePercentage = closingReading.variancePercentage ?? 0;
    final isSignificant = variance.abs() > 1.0 || variancePercentage.abs() > 1.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSignificant 
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSignificant 
            ? Theme.of(context).colorScheme.error.withOpacity(0.3)
            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSignificant ? Icons.warning : Icons.info_outline,
            color: isSignificant 
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Variance Analysis',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSignificant 
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manual: ${closingReading.manualReading.toStringAsFixed(2)}L\n'
                  'System: ${closingReading.systemReading?.toStringAsFixed(2) ?? 'N/A'}L\n'
                  'Variance: ${variance.toStringAsFixed(2)}L (${variancePercentage.toStringAsFixed(2)}%)',
                  style: TextStyle(
                    fontSize: 11,
                    color: isSignificant 
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReadingDialog(
    BuildContext context,
    ShiftReadingsController controller,
    ShiftNozzleModel nozzle,
    String readingType,
    NozzleReadingModel? existingReading,
  ) {
    final readingController = TextEditingController(
      text: existingReading?.manualReading.toString() ?? '',
    );
    final notesController = TextEditingController(
      text: existingReading?.reconciliationNotes ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${readingType} Reading - Nozzle ${nozzle.nozzleNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: readingController,
              decoration: InputDecoration(
                labelText: 'Manual Reading (Litres)',
                border: const OutlineInputBorder(),
                suffixText: 'L',
                helperText: 'Enter cumulative meter reading',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            if (existingReading != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Reading Info:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'System Reading: ${existingReading.systemReading?.toStringAsFixed(2) ?? 'N/A'}L\n'
                      'Variance: ${existingReading.variance?.toStringAsFixed(2) ?? 'N/A'}L\n'
                      'Status: ${existingReading.varianceStatus}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: controller.isSavingReadings.value ? null : () async {
              final reading = double.tryParse(readingController.text);
              if (reading == null || reading < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid reading'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              if (existingReading != null) {
                await controller.updateNozzleReading(
                  readingId: existingReading.id,
                  manualReading: reading,
                  reconciliationNotes: notesController.text.isNotEmpty ? notesController.text : null,
                );
              } else {
                await controller.createNozzleReading(
                  nozzleId: nozzle.id,
                  readingType: readingType,
                  manualReading: reading,
                  reconciliationNotes: notesController.text.isNotEmpty ? notesController.text : null,
                );
              }
              Navigator.of(context).pop();
            },
            child: controller.isSavingReadings.value 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(existingReading != null ? 'Update' : 'Record'),
          ),
        ],
      ),
    );
  }
}

