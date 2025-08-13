import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/station_shift_controller.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/models/tank_reading_model.dart';
import 'package:flow_360/features/tank/presentation/widgets/create_tank_reading_dialog.dart';
import 'package:flow_360/features/tank/presentation/widgets/tank_reading_card.dart';
import 'package:flow_360/features/tank/presentation/widgets/reconcile_reading_dialog.dart';

class TankReadingsPage extends StatelessWidget {
  final StationShiftModel shift;

  const TankReadingsPage({
    super.key,
    required this.shift,
  });

  @override
  Widget build(BuildContext context) {
    final shiftController = Get.find<StationShiftController>();
    final tankController = Get.find<TankController>();

    // Select the shift and load readings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      shiftController.selectShift(shift);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Tank Readings - ${shift.formattedShiftDate}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => shiftController.loadTankReadings(shift.id),
          ),
        ],
      ),
      body: Column(
        children: [
          // Shift Info Card
          _buildShiftInfoCard(),
          
          // Readings List
          Expanded(
            child: Obx(() {
              if (shiftController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (shiftController.tankReadings.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.science,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tank readings found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add tank readings for this shift',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => shiftController.loadTankReadings(shift.id),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Statistics Cards
                    _buildReadingsStatistics(shiftController),
                    const SizedBox(height: 24),
                    
                    // Readings List
                    _buildReadingsList(shiftController, context),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateReadingDialog(context, tankController),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildShiftInfoCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: shift.statusColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Shift Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: shift.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    shift.statusText,
                    style: TextStyle(
                      color: shift.statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    'Date',
                    shift.formattedShiftDate,
                    Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    'Time',
                    '${shift.formattedStartTime} - ${shift.formattedEndTime ?? "Ongoing"}',
                    Icons.access_time,
                  ),
                ),
              ],
            ),
            if (shift.durationMinutes != null) ...[
              const SizedBox(height: 8),
              _buildInfoItem(
                'Duration',
                shift.durationText,
                Icons.timer,
              ),
            ],
            if (shift.notes?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              _buildInfoItem(
                'Notes',
                shift.notes!,
                Icons.note,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReadingsStatistics(StationShiftController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Readings',
            controller.tankReadings.length.toString(),
            Icons.science,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'With Variance',
            controller.readingsWithVariance.length.toString(),
            Icons.warning,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Need Reconciliation',
            controller.readingsNeedingReconciliation.length.toString(),
            Icons.error,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingsList(StationShiftController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tank Readings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        ...controller.tankReadings.map((reading) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TankReadingCard(
            reading: reading,
            onReconcile: () => _showReconcileDialog(context, reading),
          ),
        )).toList(),
      ],
    );
  }

  void _showCreateReadingDialog(BuildContext context, TankController tankController) {
    showDialog(
      context: context,
      builder: (context) => CreateTankReadingDialog(shift: shift),
    );
  }

  void _showReconcileDialog(BuildContext context, TankReadingModel reading) {
    showDialog(
      context: context,
      builder: (context) => ReconcileReadingDialog(reading: reading),
    );
  }
}
