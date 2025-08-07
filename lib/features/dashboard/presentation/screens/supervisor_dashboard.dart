import 'package:flow_360/config/router/routes.dart';
import 'package:flutter/material.dart';

class SupervisorDashboard extends StatelessWidget {
  const SupervisorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DashboardCard(
        title: 'Manage Station Prices',
        icon: Image.asset("assets/icons/discount.png", height: 60),
        backgroundColor: Colors.redAccent,
        onTap: () {
          // Navigate to fuel price screen
          FuelPricesRoute().push(context);
        },
      ),
      _DashboardCard(
        title: 'Manage Fuel Dispensers',
        backgroundColor: Colors.pinkAccent,
        icon: Image.asset("assets/icons/gas-pump.png", height: 60),
        onTap: () {
          FuelDispensersPageRoute().push(context);
          // Navigate to dispensers list
        },
      ),
      _DashboardCard(
        title: 'View Sales Reports',
        backgroundColor: Colors.blue,
        icon: Image.asset("assets/icons/financial-profit.png", height: 60),
        onTap: () {
          // Navigate to nozzle management
        },
      ),
      _DashboardCard(
        backgroundColor: Colors.teal,
        title: 'Manage Attendants',
        icon: Image.asset("assets/icons/refuel.png", height: 60),
        onTap: () {
          // Navigate to reading input
        },
      ),

      _DashboardCard(
        backgroundColor: Colors.indigo,
        title: 'Manage Employee Shifts',
        icon: Image.asset("assets/icons/work-schedule.png", height: 60),
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
          actions: [
            IconButton(
              onPressed: () {
                ProfileRoute().push(context);
              },
              icon: Icon(Icons.person),
            ),
          ],
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
  final Widget icon;
  final Color? backgroundColor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
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
