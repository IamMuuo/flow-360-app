import 'package:flow_360/config/router/routes.dart';
import 'package:flutter/material.dart';

class SupervisorDashboard extends StatelessWidget {
  const SupervisorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DashboardCard(
        title: 'Manage Station Prices',
        icon: Icons.price_change_outlined,
        onTap: () {
          // Navigate to fuel price screen
          FuelPricesRoute().push(context);
        },
      ),
      _DashboardCard(
        title: 'Manage Fuel Dispensers',
        icon: Icons.local_gas_station_outlined,
        onTap: () {
          FuelDispensersPageRoute().push(context);
          // Navigate to dispensers list
        },
      ),
      _DashboardCard(
        title: 'View Sales Reports',
        icon: Icons.insights,
        onTap: () {
          // Navigate to nozzle management
        },
      ),
      _DashboardCard(
        title: 'Manage Employee Shifts',
        icon: Icons.access_time_outlined,
        onTap: () {
          // Navigate to reading input
        },
      ),
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 180,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('Supervisor Dashboard'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 1.1,
            children: cards,
          ),
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 42, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
