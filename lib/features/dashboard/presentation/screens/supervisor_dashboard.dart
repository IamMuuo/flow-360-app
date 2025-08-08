import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/config/router/routes.dart';
import 'package:flow_360/features/shift/controllers/supervisor_shift_controller.dart';
import 'package:flow_360/features/employees/repository/employee_repository.dart';
import 'package:flow_360/features/fuel_dispenser/repository/fuel_dispenser_repository.dart';
import 'package:flow_360/features/fuel_dispenser/repository/nozzle_repository.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:get_it/get_it.dart';

class SupervisorDashboard extends StatefulWidget {
  const SupervisorDashboard({super.key});

  @override
  State<SupervisorDashboard> createState() => _SupervisorDashboardState();
}

class _SupervisorDashboardState extends State<SupervisorDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  // Controllers for data
  final SupervisorShiftController _shiftController = Get.put(SupervisorShiftController());
  final EmployeeRepository _employeeRepository = GetIt.instance<EmployeeRepository>();
  final FuelDispenserRepository _dispenserRepository = GetIt.instance<FuelDispenserRepository>();
  final NozzleRepository _nozzleRepository = GetIt.instance<NozzleRepository>();

  // Observable data
  final RxInt totalEmployees = 0.obs;
  final RxInt activeEmployees = 0.obs;
  final RxInt totalDispensers = 0.obs;
  final RxInt activeDispensers = 0.obs;
  final RxInt totalNozzles = 0.obs;
  final RxInt activeNozzles = 0.obs;
  final RxInt totalShifts = 0.obs;
  final RxInt activeShifts = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);

    // Load data
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      isLoading.value = true;

      // Get current user's station ID
      final authController = Get.find<AuthController>();
      final currentUser = authController.currentUser.value;
      final stationId = currentUser?.user.station;

      if (stationId != null) {
        // Load employees
        final employees = await _employeeRepository.getEmployees(stationId: stationId);
        totalEmployees.value = employees.length;
        activeEmployees.value = employees.where((emp) => emp.isActive == true).length;

        // Load dispensers for the station
        final dispensers = await _dispenserRepository.getFuelDispensers(stationId: stationId);
        totalDispensers.value = dispensers.length;
        activeDispensers.value = dispensers.where((disp) => disp.isActive == true).length;

        // Load nozzles from all dispensers
        int totalNozzlesCount = 0;
        int activeNozzlesCount = 0;
        
        for (final dispenser in dispensers) {
          try {
            final nozzles = await _nozzleRepository.getNozzles(dispenserId: dispenser.id);
            totalNozzlesCount += nozzles.length;
            activeNozzlesCount += nozzles.where((nozzle) => nozzle.isActive == true).length;
          } catch (e) {
            // Skip dispensers with nozzle loading errors
            debugPrint('Error loading nozzles for dispenser ${dispenser.id}: $e');
          }
        }
        
        totalNozzles.value = totalNozzlesCount;
        activeNozzles.value = activeNozzlesCount;
      }

      // Load shifts
      await _shiftController.loadEmployeeShifts();
      totalShifts.value = _shiftController.employeeShifts.length;
      activeShifts.value = _shiftController.activeEmployeeShifts.length;

    } catch (e) {
      // Handle errors silently for now
      debugPrint('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: CustomScrollView(
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
                  child: const Text(
                    'Supervisor Dashboard',
                    style: TextStyle(
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
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
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
              actions: [
                IconButton(
                  onPressed: () {
                    ProfileRoute().push(context);
                  },
                  icon: const Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
            
            // Statistics Section
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Station Overview',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatisticsGrid(context),
                        const SizedBox(height: 24),
                        _buildQuickActions(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context) {
    return Obx(() {
      if (isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Column(
        children: [
          // First row - 2 cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Fuel Pumps',
                  totalDispensers.value.toString(),
                  '${activeDispensers.value} Active',
                  Icons.local_gas_station,
                  Colors.blue,
                  Colors.blue.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Nozzles',
                  totalNozzles.value.toString(),
                  '${activeNozzles.value} Active',
                  Icons.water_drop,
                  Colors.green,
                  Colors.green.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row - 2 cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Employees',
                  totalEmployees.value.toString(),
                  '${activeEmployees.value} On Duty',
                  Icons.people,
                  Colors.orange,
                  Colors.orange.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Active Shifts',
                  totalShifts.value.toString(),
                  '${activeShifts.value} Active',
                  Icons.schedule,
                  Colors.purple,
                  Colors.purple.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String mainValue,
    String subtitle,
    IconData icon,
    Color color,
    Color backgroundColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                mainValue,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: [
            // First row - 2 cards
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Manage Employees',
                    'Create, edit, and monitor employees',
                    Icons.people_alt,
                    Colors.blue,
                    () => EmployeeManagementPageRoute().push(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Fuel Dispensers',
                    'Monitor pumps and nozzles',
                    Icons.local_gas_station,
                    Colors.green,
                    () => FuelDispensersPageRoute().push(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Second row - 2 cards
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Fuel Prices',
                    'Set and manage pricing',
                    Icons.attach_money,
                    Colors.orange,
                    () => FuelPricesRoute().push(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Employee Shifts',
                    'Manage work schedules',
                    Icons.schedule,
                    Colors.purple,
                    () => SupervisorShiftManagementRoute().push(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Third row - 1 card
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    'Sales Reports',
                    'View detailed analytics',
                    Icons.analytics,
                    Colors.red,
                    () => SalesReportRoute().push(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.1),
                  color.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        'Tap to access',
                        style: TextStyle(
                          fontSize: 8,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


