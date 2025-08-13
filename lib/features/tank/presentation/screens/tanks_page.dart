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
