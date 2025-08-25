// lib/features/shift/presentation/screens/shift_readings_screen.dart

import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flow_360/features/shift/controllers/shift_readings_controller.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/shift/presentation/screens/tank_readings_screen.dart';
import 'package:flow_360/features/shift/presentation/screens/nozzle_readings_screen.dart';

class ShiftReadingsScreen extends StatelessWidget {
  const ShiftReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftReadingsController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Shift Readings',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (controller.currentShift.value?.isActive == true)
            IconButton(
              onPressed: () => _showEndShiftDialog(context, controller),
              icon: const Icon(Icons.stop_circle),
              tooltip: 'End Shift',
            ),
        ],
      ),
      body: Obx(() {
        // Show success/error messages
        if (controller.successMessage.value.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(controller.successMessage.value),
                backgroundColor: Theme.of(context).colorScheme.primary,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
            controller.clearSuccess();
          });
        }

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
            await controller.loadStationShifts();
            await controller.loadStationData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShiftStatusCard(context, controller),
                const SizedBox(height: 24),
                if (controller.currentShift.value?.isActive == true) ...[
                  _buildReadingSections(context, controller),
                  const SizedBox(height: 24),
                  _buildReconciliationSection(context, controller),
                ] else ...[
                  _buildNoActiveShiftCard(context, controller),
                ],
                const SizedBox(height: 24),
                _buildDebugSection(context, controller),
                const SizedBox(height: 24),
                _buildShiftHistorySection(context, controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildShiftStatusCard(BuildContext context, ShiftReadingsController controller) {
    final currentShift = controller.currentShift.value;
    final todayShifts = controller.getTodayShifts();
    final canCreate = controller.canCreateShiftToday;
    final todayCount = todayShifts.length;
    final authController = Get.find<AuthController>();
    final isAdmin = authController.currentUser.value?.user.isStaff ?? false;
    final maxShifts = isAdmin ? '∞' : '3';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: currentShift?.isActive == true 
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: currentShift?.isActive == true 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                currentShift?.isActive == true ? Icons.play_circle_filled : Icons.schedule,
                color: currentShift?.isActive == true 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentShift?.isActive == true ? 'Active Shift' : 'Today\'s Shifts',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: currentShift?.isActive == true 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (currentShift?.isActive == true)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          
          // Today's shift count
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: canCreate ? Colors.green[50] : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: canCreate ? Colors.green[200]! : Colors.orange[200]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  canCreate ? Icons.check_circle : Icons.warning,
                  color: canCreate ? Colors.green[600] : Colors.orange[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  isAdmin 
                    ? 'Today: $todayCount shifts created (Unlimited allowed)'
                    : 'Today: $todayCount/$maxShifts shifts created',
                  style: TextStyle(
                    fontSize: 12,
                    color: canCreate ? Colors.green[700] : Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          if (currentShift != null) ...[
            const SizedBox(height: 16),
            _buildShiftInfoRow(context, 'Date', currentShift.shiftDate),
            _buildShiftInfoRow(context, 'Start Time', currentShift.startTime),
            if (currentShift.endTime != null)
              _buildShiftInfoRow(context, 'End Time', currentShift.endTime!),
            if (currentShift.durationMinutes != null)
              _buildShiftInfoRow(context, 'Duration', '${currentShift.durationMinutes} min'),
            if (currentShift.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                'Notes: ${currentShift.notes}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ] else ...[
            const SizedBox(height: 16),
            if (todayShifts.isNotEmpty) ...[
              Text(
                'Today\'s Shifts:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              ...todayShifts.map((shift) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      shift.isActive ? Icons.play_circle_filled : Icons.stop_circle,
                      color: shift.isActive 
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${shift.startTime}${shift.endTime != null ? ' - ${shift.endTime}' : ''} (${shift.status})',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 12),
            ],
            Text(
              canCreate 
                ? 'Create a new shift to start recording readings.'
                : 'Maximum shifts reached for today.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            if (canCreate) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateShiftDialog(context, controller),
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Shift'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildShiftInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingSections(BuildContext context, ShiftReadingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Record Readings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildReadingCard(
                context,
                'Tank Readings',
                Icons.storage,
                Colors.blue,
                () => _showTankReadingsDialog(context, controller),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildReadingCard(
                context,
                'Nozzle Readings',
                Icons.local_gas_station,
                Colors.orange,
                () => _showNozzleReadingsDialog(context, controller),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReadingCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to record',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReconciliationSection(BuildContext context, ShiftReadingsController controller) {
    final hasOpeningReadings = controller.hasOpeningReadings();
    final hasClosingReadings = controller.hasClosingReadings();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reconciliation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatusIndicator(
                context,
                'Opening Readings',
                hasOpeningReadings,
                Icons.play_arrow,
              ),
              const SizedBox(width: 16),
              _buildStatusIndicator(
                context,
                'Closing Readings',
                hasClosingReadings,
                Icons.stop,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (hasOpeningReadings && hasClosingReadings) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isReconciling.value 
                  ? null 
                  : () => controller.reconcileShiftReadings(),
                icon: controller.isReconciling.value 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.compare_arrows),
                label: Text(
                  controller.isReconciling.value ? 'Reconciling...' : 'Reconcile Readings',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ] else ...[
            Text(
              'Complete opening and closing readings to enable reconciliation',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(
    BuildContext context,
    String label,
    bool isComplete,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isComplete 
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isComplete 
              ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isComplete 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isComplete 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Icon(
              isComplete ? Icons.check_circle : Icons.pending,
              color: isComplete 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoActiveShiftCard(BuildContext context, ShiftReadingsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.schedule,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No Active Shift',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a new shift to start recording tank and nozzle readings.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDebugSection(BuildContext context, ShiftReadingsController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Debug',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Current Shift ID: ${controller.currentShift.value?.id ?? 'N/A'}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Has Opening Readings: ${controller.hasOpeningReadings()}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Has Closing Readings: ${controller.hasClosingReadings()}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Is Reconciling: ${controller.isReconciling.value}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftHistorySection(BuildContext context, ShiftReadingsController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shift History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        if (controller.stationShifts.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Text(
              'No shifts found',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.stationShifts.length,
            itemBuilder: (context, index) {
              final shift = controller.stationShifts[index];
              return _buildShiftHistoryCard(context, shift, controller);
            },
          ),
      ],
    );
  }

  Widget _buildShiftHistoryCard(
    BuildContext context,
    StationShiftModel shift,
    ShiftReadingsController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: shift.isActive 
            ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
            : Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
              Icon(
                shift.isActive ? Icons.play_circle_filled : Icons.stop_circle,
                color: shift.isActive 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Shift ${shift.shiftDate}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: shift.isActive 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  shift.status,
                  style: TextStyle(
                    color: shift.isActive 
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${shift.startTime}${shift.endTime != null ? ' - ${shift.endTime}' : ''}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
          if (shift.durationMinutes != null) ...[
            const SizedBox(height: 4),
            Text(
              'Duration: ${shift.durationMinutes} minutes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Dialog methods
  void _showCreateShiftDialog(BuildContext context, ShiftReadingsController controller) {
    final shiftDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final startTimeController = TextEditingController(
      text: DateFormat('HH:mm').format(DateTime.now()),
    );
    final notesController = TextEditingController();

    // Check for existing shift on the selected date
    final selectedDate = shiftDateController.text;
    final existingShift = controller.stationShifts.where((shift) => 
      shift.shiftDate == selectedDate
    ).firstOrNull;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Shift'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (existingShift != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Existing Shift Found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You already have a ${existingShift.status.toLowerCase()} shift for ${DateFormat('MMM dd, yyyy').format(DateTime.parse(existingShift.shiftDate))}.',
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Time: ${existingShift.startTime}${existingShift.endTime != null ? ' - ${existingShift.endTime}' : ''}',
                      style: TextStyle(color: Colors.orange.shade700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: shiftDateController,
              decoration: const InputDecoration(
                labelText: 'Shift Date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  shiftDateController.text = DateFormat('yyyy-MM-dd').format(date);
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: startTimeController,
              decoration: const InputDecoration(
                labelText: 'Start Time',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  startTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                }
              },
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: (controller.isCreatingShift.value || existingShift != null) ? null : () async {
              await controller.createStationShift(
                shiftDate: shiftDateController.text,
                startTime: startTimeController.text,
                notes: notesController.text.isNotEmpty ? notesController.text : null,
              );
              Navigator.of(context).pop();
            },
            child: controller.isCreatingShift.value 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEndShiftDialog(BuildContext context, ShiftReadingsController controller) {
    final endTimeController = TextEditingController(
      text: DateFormat('HH:mm').format(DateTime.now()),
    );
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Shift'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: endTimeController,
              decoration: const InputDecoration(
                labelText: 'End Time',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  endTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                }
              },
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: controller.isEndingShift.value ? null : () async {
              await controller.endStationShift(
                shiftId: controller.currentShift.value!.id,
                endTime: endTimeController.text,
                notes: notesController.text.isNotEmpty ? notesController.text : null,
              );
              Navigator.of(context).pop();
            },
            child: controller.isEndingShift.value 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('End Shift'),
          ),
        ],
      ),
    );
  }

  void _showTankReadingsDialog(BuildContext context, ShiftReadingsController controller) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TankReadingsScreen(),
      ),
    );
  }

  void _showNozzleReadingsDialog(BuildContext context, ShiftReadingsController controller) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NozzleReadingsScreen(),
      ),
    );
  }
}
