import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/models/tank_model.dart';
import 'package:flow_360/features/tank/presentation/widgets/add_fuel_dialog.dart';
import 'package:flow_360/features/tank/presentation/widgets/adjust_level_dialog.dart';

class TankDetailsPage extends StatelessWidget {
  final TankModel tank;

  const TankDetailsPage({
    super.key,
    required this.tank,
  });

  @override
  Widget build(BuildContext context) {
    print('Building TankDetailsPage for tank: ${tank.name}');
    
    final TankController controller = Get.find<TankController>();
    
    // Select the tank to load its audit trail
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectTank(tank);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tank.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          IconButton(
            onPressed: () => controller.refreshTanks(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.refreshTanks,
          child: CustomScrollView(
            slivers: [
              // Tank Overview Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTankOverview(context),
                      const SizedBox(height: 24),
                      _buildActionButtons(context, controller),
                      const SizedBox(height: 24),
                      _buildAuditTrailHeader(context),
                    ],
                  ),
                ),
              ),

              // Audit Trail List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final audit = controller.tankAuditTrail[index];
                      return _buildAuditTrailItem(context, audit);
                    },
                    childCount: controller.tankAuditTrail.length,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTankOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tank.statusColor.withOpacity(0.1),
            tank.statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tank.statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage,
                color: tank.statusColor,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tank.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      tank.fuelTypeName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tank.statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tank.fuelStatus,
                  style: TextStyle(
                    color: tank.statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Fuel level progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fuel Level',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${tank.usagePercentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: tank.statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: tank.usagePercentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(tank.statusColor),
                minHeight: 12,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${tank.currentLevelLitres}L',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${tank.capacityLitres}L',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, TankController controller) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showAddFuelDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Fuel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _showAdjustLevelDialog(context),
            icon: const Icon(Icons.tune),
            label: const Text('Adjust Level'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuditTrailHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.history,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          'Audit Trail',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAuditTrailItem(BuildContext context, audit) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getChangeTypeColor(audit.changeType).withOpacity(0.2),
          child: Icon(
            _getChangeTypeIcon(audit.changeType),
            color: _getChangeTypeColor(audit.changeType),
            size: 20,
          ),
        ),
        title: Text(
          audit.changeTypeDisplay,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(audit.reason),
            const SizedBox(height: 4),
            Text(
              '${audit.changeAmount}L • ${audit.recordedAt}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${audit.previousLevel}L → ${audit.newLevel}L',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (audit.recordedByName != null)
              Text(
                audit.recordedByName,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getChangeTypeColor(String changeType) {
    switch (changeType) {
      case 'ADDITION':
        return Colors.green;
      case 'CONSUMPTION':
        return Colors.red;
      case 'ADJUSTMENT':
        return Colors.orange;
      case 'DELIVERY':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getChangeTypeIcon(String changeType) {
    switch (changeType) {
      case 'ADDITION':
        return Icons.add_circle;
      case 'CONSUMPTION':
        return Icons.remove_circle;
      case 'ADJUSTMENT':
        return Icons.tune;
      case 'DELIVERY':
        return Icons.local_shipping;
      default:
        return Icons.info;
    }
  }

  void _showAddFuelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddFuelDialog(tank: tank),
    );
  }

  void _showAdjustLevelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AdjustLevelDialog(tank: tank),
    );
  }
}
