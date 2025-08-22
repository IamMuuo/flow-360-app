import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/tank/controllers/station_shift_controller.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/tank/presentation/widgets/create_station_shift_dialog.dart';
import 'package:flow_360/features/tank/presentation/widgets/station_shift_card.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';

class StationShiftsPage extends StatelessWidget {
  const StationShiftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StationShiftController>();

    // Load shifts when page is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadShiftsIfUserAvailable();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Shifts'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshStationShifts(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadStationShifts(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.stationShifts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No station shifts found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first station shift to start managing tank readings',
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
          onRefresh: controller.refreshStationShifts,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Statistics Cards
              _buildStatisticsCards(controller),
              const SizedBox(height: 24),
              
              // Shifts List
              _buildShiftsList(controller, context),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        final canCreate = controller.canCreateShiftToday;
        final todayCount = controller.todayShiftCount;
        final authController = Get.find<AuthController>();
        final isAdmin = authController.currentUser.value?.user.isStaff ?? false;
        
        return FloatingActionButton(
          onPressed: canCreate ? () => _showCreateShiftDialog(context) : null,
          backgroundColor: canCreate ? Colors.blue[600] : Colors.grey[400],
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          tooltip: canCreate 
            ? 'Create New Shift' 
            : isAdmin 
              ? 'No more shifts allowed today' 
              : 'Maximum 3 shifts per day reached',
        );
      }),
    );
  }

  Widget _buildStatisticsCards(StationShiftController controller) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Active Shifts',
                controller.activeShifts.length.toString(),
                Icons.play_circle_outline,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Completed',
                controller.completedShifts.length.toString(),
                Icons.check_circle_outline,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Total',
                controller.stationShifts.length.toString(),
                Icons.schedule,
                Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Today's shift count and limit
        Obx(() {
          final todayCount = controller.todayShiftCount;
          final authController = Get.find<AuthController>();
          final isAdmin = authController.currentUser.value?.user.isStaff ?? false;
          final maxShifts = isAdmin ? '∞' : '3';
          final canCreate = controller.canCreateShiftToday;
          
          return Container(
            padding: const EdgeInsets.all(12),
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
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isAdmin 
                      ? 'Today: $todayCount shifts created (Unlimited allowed)'
                      : 'Today: $todayCount/$maxShifts shifts created',
                    style: TextStyle(
                      fontSize: 14,
                      color: canCreate ? Colors.green[700] : Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftsList(StationShiftController controller, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Station Shifts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        ...controller.stationShifts.map((shift) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: StationShiftCard(
            shift: shift,
            onTap: () => _navigateToReadings(context, shift),
            onEdit: () => _showEditShiftDialog(context, shift),
          ),
        )).toList(),
      ],
    );
  }

  void _showCreateShiftDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateStationShiftDialog(),
    );
  }

  void _showEditShiftDialog(BuildContext context, StationShiftModel shift) {
    showDialog(
      context: context,
      builder: (context) => CreateStationShiftDialog(shift: shift),
    );
  }

  void _navigateToReadings(BuildContext context, StationShiftModel shift) {
    context.push('/tank-readings/${shift.id}', extra: shift);
  }
}
