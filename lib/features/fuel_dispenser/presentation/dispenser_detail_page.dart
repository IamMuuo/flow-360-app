import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/features/fuel_dispenser/controller/nozzle_controller.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';
import 'package:flow_360/features/tank/controllers/tank_controller.dart';

// This function is no longer needed as we now have proper fuel type objects
// The fuel type name is now available directly from the fuel type object

class DispenserDetailPage extends StatefulWidget {
  final String dispenserId;

  const DispenserDetailPage({super.key, required this.dispenserId});

  @override
  State<DispenserDetailPage> createState() => _DispenserDetailPageState();
}

class _DispenserDetailPageState extends State<DispenserDetailPage>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;

  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Controller for fetching dispenser data from the main list
    final dispenserController = Get.find<FuelDispenserController>();
    final dispenser = dispenserController.dispensers.firstWhereOrNull(
      (d) => d.id == widget.dispenserId,
    );

    if (dispenser == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Dispenser Not Found',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'The requested dispenser could not be found.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final nozzleController = Get.find<NozzleController>();
    // Fetch the nozzles for this specific dispenser
    nozzleController.fetchNozzles(widget.dispenserId);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Animated App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  dispenser.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated background elements
                    Positioned(
                      top: 20,
                      right: 20,
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 20,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.push('/fuel-dispenser/${dispenser.id}/edit');
                },
                icon: const Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildDispenserInfo(dispenser),
                      const SizedBox(height: 24),
                      _buildNozzleSection(
                        context,
                        widget.dispenserId,
                        nozzleController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDispenserInfo(FuelDispenserModel dispenser) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_gas_station,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dispenser Information',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dispenser.name,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: dispenser.isActive == true
                          ? Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1)
                          : Theme.of(
                              context,
                            ).colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      dispenser.isActive == true ? 'Active' : 'Inactive',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: dispenser.isActive == true
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dispenser details
              _buildInfoTile(
                context,
                "Serial Number",
                dispenser.serialNumber ?? "Unknown",
                Icons.code,
              ),
              const SizedBox(height: 16),
              _buildInfoTile(
                context,
                "Manufacturer",
                dispenser.manufacturer ?? "(Not specified)",
                Icons.business,
              ),
              const SizedBox(height: 16),
              _buildInfoTile(
                context,
                "Installed At",
                dispenser.installedAt,
                Icons.calendar_today,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNozzleSection(
    BuildContext context,
    String dispenserId,
    NozzleController nozzleController,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.water_drop,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Nozzles',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    onPressed: () => _showCreateNozzleDialog(
                      context,
                      dispenserId,
                      nozzleController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Use Obx to directly listen to the nozzles list
              Obx(() {
                if (nozzleController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (nozzleController.errorMessage.isNotEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.errorContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Error: ${nozzleController.errorMessage.value}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (nozzleController.nozzles.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.water_drop_outlined,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No nozzles available',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: nozzleController.nozzles.map((nozzle) {
                    return _buildNozzleCard(context, nozzle, nozzleController);
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNozzleCard(
    BuildContext context,
    NozzleModel nozzle,
    NozzleController nozzleController,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showEditNozzleDialog(context, nozzle);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: const BoxConstraints(minHeight: 160),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: nozzle.isActive == true
                    ? Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2)
                    : Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row with nozzle number and status
                Row(
              children: [
                Container(
                      padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: nozzle.isActive == true
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1)
                        : Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Icons.water_drop_outlined,
                        size: 20,
                    color: nozzle.isActive == true
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                  ),
                ),
                    const SizedBox(width: 12),
                Expanded(
                      child: Text(
                        'Nozzle ${nozzle.nozzleNumber}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: nozzle.isActive == true
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1)
                        : Theme.of(
                            context,
                          ).colorScheme.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    nozzle.isActive == true ? 'Active' : 'Inactive',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: nozzle.isActive == true
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
                const SizedBox(height: 12),
                
                // Fuel type and tank info
                Row(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nozzle.fuelTypeNameValue,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                
                // Tank assignment
                Row(
                  children: [
                    Icon(
                      Icons.storage,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        nozzle.tank != null ? 'Tank Assigned' : 'No Tank Assigned',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: nozzle.tank != null
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Meter readings
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.speed,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current: ${nozzle.currentReadingValue.toStringAsFixed(2)}L',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Total Dispensed: ${nozzle.totalDispensed.toStringAsFixed(2)}L',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quick action button for setting initial reading
                      if (nozzle.initialReadingValue == 0 && nozzle.currentReadingValue == 0)
                        IconButton(
                          onPressed: () => _showSetInitialReadingDialog(context, nozzle),
                          icon: Icon(
                            Icons.edit,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          tooltip: 'Set Initial Reading',
                          constraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 24,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateNozzleDialog(
    BuildContext context,
    String dispenserId,
    NozzleController nozzleController,
  ) {
    final nozzleNumberController = TextEditingController();
    final initialReadingController = TextEditingController();
    bool isActive = true;
    String? selectedTankId;

    // Get tank controller for tank selection
    final tankController = Get.find<TankController>();
    
    // Ensure tanks are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tankController.loadTanksIfUserAvailable();
    });

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                Icons.add_circle_outline,
                color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Add New Nozzle'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Info card about nozzle setup
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'A nozzle dispenses fuel from a specific tank. The fuel type is automatically set based on the selected tank.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Tank Selection - Most important field
                Text(
                  'Tank Selection *',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
              Obx(() {
                  // Debug: Print all tanks to understand the issue
                  print('DEBUG: Total tanks: ${tankController.tanks.length}');
                  for (final tank in tankController.tanks) {
                    print('DEBUG: Tank ${tank.name} - Active: ${tank.isActive}, FuelType: ${tank.fuelType}, FuelTypeName: ${tank.fuelTypeName}');
                  }
                  
                  // More robust filtering - check for active tanks with any fuel type info
                  final tanks = tankController.tanks.where((tank) => 
                    tank.isActive && 
                    (tank.fuelType != null || tank.fuelTypeName != 'Unknown' || tank.fuelName != null)
                  ).toList();
                  
                  print('DEBUG: Filtered tanks: ${tanks.length}');
                
                if (tanks.isEmpty) {
                                         // Check if there are any tanks at all
                     final allTanks = tankController.tanks;
                     final activeTanks = tankController.tanks.where((tank) => tank.isActive).toList();
                     final tanksWithFuelType = tankController.tanks.where((tank) => tank.fuelType != null).toList();
                     final tanksWithFuelName = tankController.tanks.where((tank) => tank.fuelName != null).toList();
                    
                    String errorMessage = 'You need to create an active tank with a fuel type before adding nozzles.';
                    
                                         if (allTanks.isEmpty) {
                       errorMessage = 'No tanks found. Please create a tank first.';
                     } else if (activeTanks.isEmpty) {
                       errorMessage = 'No active tanks found. Please activate a tank or create a new one.';
                     } else if (tanksWithFuelType.isEmpty && tanksWithFuelName.isEmpty) {
                       errorMessage = 'No tanks with fuel types found. Please assign fuel types to your tanks.';
                     }
                    
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Theme.of(context).colorScheme.error,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No Active Tanks Available',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            errorMessage,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                                                     if (allTanks.isNotEmpty) ...[
                             const SizedBox(height: 8),
                             Text(
                               'Debug Info: ${allTanks.length} total tanks, ${activeTanks.length} active, ${tanksWithFuelType.length} with fuel type object, ${tanksWithFuelName.length} with fuel name',
                               style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                 color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                 fontStyle: FontStyle.italic,
                               ),
                               textAlign: TextAlign.center,
                             ),
                           ],
                           const SizedBox(height: 12),
                                                      ElevatedButton.icon(
                             onPressed: () {
                               tankController.refreshTanks();
                               // Inline debug info
                               print('DEBUG: Total tanks: ${tankController.tanks.length}');
                               print('DEBUG: Active tanks: ${tankController.activeTanks.length}');
                               print('DEBUG: Error: ${tankController.errorMessage.value}');
                               for (final tank in tankController.tanks) {
                                 print('DEBUG: Tank ${tank.name} - Active: ${tank.isActive} - FuelType: ${tank.fuelTypeName} - FuelName: ${tank.fuelName} - FuelKraCode: ${tank.fuelKraCode}');
                               }
                             },
                             icon: const Icon(Icons.refresh, size: 16),
                             label: const Text('Refresh & Debug'),
                             style: ElevatedButton.styleFrom(
                               backgroundColor: Theme.of(context).colorScheme.primary,
                               foregroundColor: Colors.white,
                             ),
                           ),
                        ],
                      ),
                    );
                  }
                  
                  return SizedBox(
                    width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    value: selectedTankId,
                      decoration: InputDecoration(
                      labelText: 'Select Tank',
                        hintText: 'Choose a tank to supply fuel to this nozzle',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.storage),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                      isExpanded: true,
                      items: tanks.map((tank) {
                        return DropdownMenuItem<String>(
                          value: tank.id,
                          child: Text(
                            '${tank.name} (${tank.fuelTypeName})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTankId = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a tank';
                      }
                      return null;
                    },
                  ),
                );
              }),
              
                const SizedBox(height: 20),
                
                // Nozzle Number
                Text(
                  'Nozzle Number *',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
              TextField(
                controller: nozzleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Nozzle Number',
                  hintText: 'e.g., 1, 2, 3',
                  border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                    filled: true,
                ),
                keyboardType: TextInputType.number,
              ),
                
                const SizedBox(height: 20),
                
                // Initial Reading
                Text(
                  'Initial Reading (Optional)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
              TextField(
                controller: initialReadingController,
                decoration: const InputDecoration(
                    labelText: 'Initial Reading (Litres)',
                  hintText: 'e.g., 0.00 (defaults to 0 if empty)',
                  border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.speed),
                    filled: true,
                    helperText: 'Set the initial meter reading for this nozzle',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
                
                const SizedBox(height: 20),
                
                // Active Status
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                children: [
                  Checkbox(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value ?? true;
                      });
                    },
                  ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Enable this nozzle for fuel dispensing',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                // Validation
                if (selectedTankId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please select a tank'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                if (nozzleNumberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Please enter a nozzle number'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                // Validate nozzle number is a positive integer
                int? nozzleNumber;
                try {
                  nozzleNumber = int.parse(nozzleNumberController.text);
                  if (nozzleNumber <= 0) {
                    throw FormatException();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Nozzle number must be a positive integer'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }

                // Validate initial reading if provided
                double? initialReading;
                if (initialReadingController.text.isNotEmpty) {
                  try {
                    initialReading = double.parse(initialReadingController.text);
                    if (initialReading < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Initial reading must be a positive number'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter a valid initial reading'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                }

                try {
                  // Get fuel type from selected tank
                  final selectedTank = tankController.tanks.firstWhere(
                    (tank) => tank.id == selectedTankId,
                    orElse: () => throw Exception('Selected tank not found'),
                  );
                  
                  final fuelType = selectedTank.fuelTypeKraCode ?? 'PMS';
                  
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  
                  await nozzleController.createNozzle(
                    dispenserId: dispenserId,
                    fuelType: fuelType,
                    nozzleNumber: nozzleNumber,
                    isActive: isActive,
                    initialReading: initialReading,
                    tankId: selectedTankId,
                  );
                  
                  if (context.mounted) {
                    context.pop(); // Close loading dialog
                    context.pop(); // Close create dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Nozzle created successfully'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.pop(); // Close loading dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error creating nozzle: $e'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Nozzle'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSetInitialReadingDialog(BuildContext context, NozzleModel nozzle) {
    final initialReadingController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.speed,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Set Initial Reading'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Set the initial meter reading for Nozzle ${nozzle.nozzleNumber}. This can only be done before any sales are made.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: initialReadingController,
              decoration: const InputDecoration(
                labelText: 'Initial Reading (Litres)',
                hintText: 'e.g., 1234.56',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.speed),
                filled: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (initialReadingController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please enter an initial reading'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              double? initialReading;
              try {
                initialReading = double.parse(initialReadingController.text);
                if (initialReading < 0) {
                  throw FormatException();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please enter a valid positive number'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              try {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Call the API to set initial reading
                final nozzleController = Get.find<NozzleController>();
                await nozzleController.setInitialReading(
                  nozzleId: nozzle.id,
                  initialReading: initialReading,
                );

                if (context.mounted) {
                  context.pop(); // Close loading dialog
                  context.pop(); // Close set reading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Initial reading set successfully'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  context.pop(); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error setting initial reading: $e'),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Set Reading'),
          ),
        ],
      ),
    );
  }

  void _showEditNozzleDialog(BuildContext context, NozzleModel nozzle) {
    final nozzleNumberController = TextEditingController(text: nozzle.nozzleNumber.toString());
    bool isActive = nozzle.isActive ?? true;
    String? selectedTankId = nozzle.tank; // Current tank

    // Get tank controller for tank selection
    final tankController = Get.find<TankController>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(width: 12),
              const Text('Edit Nozzle'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tank Selection Dropdown
              Obx(() {
                  // Show all active tanks since fuel type will be inferred from the tank
                  final tanks = tankController.tanks.where((tank) => tank.isActive).toList();
                
                if (tanks.isEmpty) {
                  return const Card(
                    color: Colors.orange,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'No tanks available for this fuel type',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                
                return SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                  value: selectedTankId,
                  decoration: const InputDecoration(
                    labelText: 'Select Tank (Optional)',
                    hintText: 'Choose a tank to supply fuel',
                    border: OutlineInputBorder(),
                  ),
                    isExpanded: true,
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                        child: Text(
                          'No tank assigned',
                          overflow: TextOverflow.ellipsis,
                        ),
                    ),
                    ...tanks.map((tank) {
                      return DropdownMenuItem<String>(
                        value: tank.id,
                          child: Text(
                            '${tank.name} (${tank.fuelTypeName})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                      );
                    }).toList(),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTankId = newValue;
                    });
                  },
                  ),
                );
              }),
              
              const SizedBox(height: 16),
              TextField(
                controller: nozzleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Nozzle Number',
                  hintText: 'e.g., 1, 2, 3',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value ?? true;
                      });
                    },
                  ),
                  const Text('Active'),
                ],
              ),
            ],
          ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nozzleNumberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  final nozzleController = Get.find<NozzleController>();
                  
                  // Get the fuel type UUID from the selected tank (if any)
                  String? fuelTypeUuid;
                  if (selectedTankId != null) {
                    final selectedTank = tankController.tanks.firstWhere(
                      (tank) => tank.id == selectedTankId,
                      orElse: () => throw Exception('Selected tank not found'),
                    );
                    fuelTypeUuid = selectedTank.fuelTypeId;
                  }
                  
                  await nozzleController.updateNozzle(
                    dispenserId: nozzle.dispenser,
                    nozzleId: nozzle.id,
                    fuelType: fuelTypeUuid ?? nozzle.fuelTypeId ?? '', // Use tank's fuel type UUID or keep current
                    nozzleNumber: int.parse(nozzleNumberController.text),
                    isActive: isActive,
                    tankId: selectedTankId,
                  );
                  
                  if (context.mounted) {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nozzle updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating nozzle: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
