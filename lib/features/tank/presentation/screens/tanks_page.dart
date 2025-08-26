import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';
import 'package:flow_360/features/tank/presentation/widgets/tank_card.dart';
import 'package:flow_360/features/tank/presentation/widgets/create_tank_dialog.dart';
import 'package:flow_360/features/tank/presentation/screens/tank_details_page.dart';

class TanksPage extends StatelessWidget {
  const TanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TankController controller = Get.find<TankController>();

    // Load tanks when page is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadTanksIfUserAvailable();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tank Management',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => controller.refreshTanks(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Tanks',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleQuickAction(context, controller, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'add_fuel_bulk',
                child: Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Add Fuel to All'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export_data',
                child: Row(
                  children: [
                    Icon(Icons.download, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Export Tank Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'low_fuel_report',
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Low Fuel Report'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.more_vert),
            tooltip: 'Quick Actions',
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
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Error', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadTanks(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.tanks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.storage, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No Tanks Found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your first tank to get started',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _showCreateTankDialog(context, controller),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Tank'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshTanks,
          child: CustomScrollView(
            slivers: [
              // Summary Cards
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tank Overview',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryCards(context, controller),
                    ],
                  ),
                ),
              ),

              // Tanks List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tank = controller.tanks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TankCard(
                        tank: tank,
                        onTap: () => _navigateToTankDetails(context, tank),
                      ),
                    );
                  }, childCount: controller.tanks.length),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTankDialog(context, controller),
        icon: const Icon(Icons.add),
        label: const Text('Add Tank'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSummaryCards(BuildContext context, TankController controller) {
    return Column(
      children: [
        // First row
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Total Tanks',
                controller.tanks.length.toString(),
                Icons.storage,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Active Tanks',
                controller.activeTanks.length.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Second row
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Low Fuel',
                controller.lowFuelTanks.length.toString(),
                Icons.warning,
                Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Good Level',
                controller.goodFuelTanks.length.toString(),
                Icons.trending_up,
                Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showCreateTankDialog(BuildContext context, TankController controller) {
    showDialog(
      context: context,
      builder: (context) => const CreateTankDialog(),
    );
  }

  void _handleQuickAction(BuildContext context, TankController controller, String action) {
    switch (action) {
      case 'add_fuel_bulk':
        _showBulkAddFuelDialog(context, controller);
        break;
      case 'export_data':
        _showExportDataDialog(context, controller);
        break;
      case 'low_fuel_report':
        _showLowFuelReport(context, controller);
        break;
    }
  }

  void _showBulkAddFuelDialog(BuildContext context, TankController controller) {
    final activeTanks = controller.activeTanks;
    if (activeTanks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No active tanks available for bulk operations'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Add Fuel'),
        content: Text(
          'This will add fuel to all ${activeTanks.length} active tanks. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bulk add fuel feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showExportDataDialog(BuildContext context, TankController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Tank Data'),
        content: const Text(
          'Export tank data including fuel levels, audit trail, and status information.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export feature coming soon!'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showLowFuelReport(BuildContext context, TankController controller) {
    final lowFuelTanks = controller.lowFuelTanks;
    if (lowFuelTanks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tanks with low fuel levels'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Low Fuel Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${lowFuelTanks.length} tank(s) have low fuel levels:'),
            const SizedBox(height: 12),
            ...lowFuelTanks.map((tank) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: tank.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${tank.name} - ${tank.currentLevelLitres}L (${tank.usagePercentage.toStringAsFixed(1)}%)',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToTankDetails(BuildContext context, tank) {
    print('Navigating to tank details for tank: ${tank.name}');
    try {
      GoRouter.of(context).push(
        '/tanks/${tank.id}',
        extra: tank,
      );
    } catch (e) {
      print('Navigation error: $e');
      // Fallback navigation
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TankDetailsPage(tank: tank),
        ),
      );
    }
  }
}
