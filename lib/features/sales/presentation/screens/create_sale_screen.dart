import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/sales/controllers/sales_controller.dart';
import 'package:flow_360/features/sales/models/sale_model.dart';
import 'package:flow_360/features/fuel_dispenser/controller/fuel_dispenser_controller.dart';
import 'package:flow_360/features/fuel_dispenser/controller/nozzle_controller.dart';
import 'package:flow_360/features/fuel_dispenser/models/fuel_dispenser_model.dart';
import 'package:flow_360/features/fuel_dispenser/models/nozzle_model.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';
import 'package:flow_360/features/auth/models/user_model.dart';
import 'package:flow_360/features/shift/controllers/shift_controller.dart';

class CreateSaleScreen extends StatefulWidget {
  const CreateSaleScreen({super.key});

  @override
  State<CreateSaleScreen> createState() => _CreateSaleScreenState();
}

class _CreateSaleScreenState extends State<CreateSaleScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _progressAnimation;

  final SalesController _salesController = Get.find<SalesController>();
  final FuelDispenserController _dispenserController = Get.find<FuelDispenserController>();
  final AuthController _authController = Get.find<AuthController>();
  
  int _currentStep = 0;
  final int _totalSteps = 5;
  
  // Form data
  String? selectedDispenserId;
  String? selectedNozzleId;
  final totalAmountController = TextEditingController();
  String selectedPaymentMode = 'CASH';
  final odometerController = TextEditingController();
  final registrationController = TextEditingController();
  final kraPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

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

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (_currentStep + 1) / _totalSteps,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _progressController.forward();
    
    // Load dispensers for the current user's station
    _loadDispensers();
    
    // Load available nozzles for the employee
    _loadAvailableNozzles();
  }
  
  void _loadDispensers() {
    final user = _authController.currentUser.value;
    if (user?.user.station != null) {
      _dispenserController.fetchFuelDispensers(user!.user.station!);
    }
  }
  
  void _loadAvailableNozzles() {
    _salesController.fetchAvailableNozzles();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _progressController.dispose();
    totalAmountController.dispose();
    odometerController.dispose();
    registrationController.dispose();
    kraPinController.dispose();
    super.dispose();
  }



  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _updateProgress();
      _slideController.reset();
      _slideController.forward();
    }
  }

  void _updateProgress() {
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: (_currentStep + 1) / _totalSteps,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.reset();
    _progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Create Sale'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Step ${_currentStep + 1} of $_totalSteps',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      minHeight: 8,
                    );
                  },
                ),
              ],
            ),
          ),
          // Step Content
          Expanded(
            child: SingleChildScrollView(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canProceed() ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_currentStep == _totalSteps - 1 ? 'Create Sale' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildDispenserSelectionStep();
      case 1:
        return _buildNozzleSelectionStep();
      case 2:
        return _buildAmountStep();
      case 3:
        return _buildPaymentStep();
      case 4:
        return _buildOptionalDetailsStep();
      default:
        return const Center(child: Text('Unknown step'));
    }
  }

  Widget _buildDispenserSelectionStep() {
    final user = _authController.currentUser.value;
    final stationId = user?.user.station ?? '';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Dispenser',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the fuel dispenser you want to use',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        Obx(() {
          if (_dispenserController.dispensers.isEmpty) {
            return const Center(
              child: Text('No available dispensers'),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: _dispenserController.dispensers.length,
            itemBuilder: (context, index) {
              final dispenser = _dispenserController.dispensers[index];
              final isSelected = selectedDispenserId == dispenser.id;
              return _buildDispenserCard(dispenser, isSelected);
            },
          );
        }),
      ],
    );
  }

  Widget _buildNozzleSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Nozzle',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          selectedDispenserId != null 
              ? 'Choose the nozzle from the selected dispenser'
              : 'Choose the nozzle you want to use for this sale',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        Obx(() {
          if (_salesController.isLoading.value) {
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading available nozzles...'),
                ],
              ),
            );
          }
          
          if (_salesController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error Loading Nozzles',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _salesController.errorMessage.value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _salesController.clearError();
                      _salesController.fetchAvailableNozzles();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          
          if (_salesController.availableNozzles.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Available Nozzles',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You need to have an active shift to view available nozzles.\nPlease contact your supervisor to start your shift.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // Filter nozzles by selected dispenser
          final filteredNozzles = selectedDispenserId != null
              ? _salesController.availableNozzles.where((nozzle) => 
                  nozzle['dispenser_id'] == selectedDispenserId).toList()
              : _salesController.availableNozzles;
          
          if (filteredNozzles.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selectedDispenserId != null 
                        ? 'No nozzles available for selected dispenser'
                        : 'Please select a dispenser first',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: filteredNozzles.length,
            itemBuilder: (context, index) {
              final nozzle = filteredNozzles[index];
              final isSelected = selectedNozzleId == nozzle['id'];
              return _buildNozzleCard(nozzle, isSelected);
            },
          );
        }),
      ],
    );
  }

  Widget _buildNozzleCard(Map<String, dynamic> nozzle, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedNozzleId = nozzle['id'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 140),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Color(int.parse('0xFF${nozzle['color_hex'].substring(1)}')).withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${nozzle['color_hex'].substring(1)}')).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_gas_station,
                  color: Color(int.parse('0xFF${nozzle['color_hex'].substring(1)}')),
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                nozzle['fuel_type_display'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Nozzle ${nozzle['nozzle_number']}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'KES ${nozzle['price_per_litre'].toStringAsFixed(2)}/L',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDispenserCard(dynamic dispenser, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDispenserId = dispenser.id;
          // Reset nozzle selection when dispenser changes
          selectedNozzleId = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: const BoxConstraints(minHeight: 140),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_gas_station,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                dispenser.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Serial: ${dispenser.serialNumber}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: dispenser.isActive 
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  dispenser.isActive ? 'Active' : 'Inactive',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: dispenser.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Amount',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter the total amount for this sale',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: totalAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Amount (KES)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              if (totalAmountController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estimated Litres:'),
                      Text(
                        _getEstimatedLitres(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select the payment method for this sale',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              _buildPaymentOption('CASH', 'Cash', Icons.money),
              const SizedBox(height: 12),
              _buildPaymentOption('MPESA', 'MPesa', Icons.phone_android),
              const SizedBox(height: 12),
              _buildPaymentOption('CARD', 'Card', Icons.credit_card),
              const SizedBox(height: 12),
              _buildPaymentOption('CREDIT', 'Credit', Icons.account_balance),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final isSelected = selectedPaymentMode == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMode = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Optional Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add additional information (optional)',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: odometerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Odometer Reading (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: registrationController,
                decoration: const InputDecoration(
                  labelText: 'Car Registration (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: kraPinController,
                decoration: const InputDecoration(
                  labelText: 'KRA PIN (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getEstimatedLitres() {
    if (totalAmountController.text.isEmpty || selectedNozzleId == null) {
      return '0.00L';
    }
    
    final amount = double.tryParse(totalAmountController.text);
    if (amount == null) return '0.00L';
    
    final nozzle = _salesController.availableNozzles.firstWhere(
      (n) => n['id'] == selectedNozzleId,
      orElse: () => <String, dynamic>{},
    );
    
    if (nozzle.isEmpty) return '0.00L';
    
    final pricePerLitre = nozzle['price_per_litre'] as double;
    if (pricePerLitre <= 0) return '0.00L';
    
    final litres = amount / pricePerLitre;
    return '${litres.toStringAsFixed(2)}L';
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return selectedDispenserId != null;
      case 1:
        return selectedNozzleId != null;
      case 2:
        final amount = double.tryParse(totalAmountController.text);
        return amount != null && amount > 0;
      case 3:
        return selectedPaymentMode.isNotEmpty;
      case 4:
        return true; // Optional step
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep == _totalSteps - 1) {
      _createSale();
    } else {
      if (_currentStep < _totalSteps - 1) {
        setState(() {
          _currentStep++;
        });
        _updateProgress();
        _slideController.reset();
        _slideController.forward();
      }
    }
  }

  void _createSale() async {
    if (!_canProceed()) return;

    final amount = double.tryParse(totalAmountController.text);
    if (amount == null || amount <= 0) return;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Creating sale...'),
          ],
        ),
      ),
    );

    try {
      print('Creating sale with nozzleId: $selectedNozzleId, amount: $amount');
      await _salesController.createSale(
        nozzleId: selectedNozzleId!,
        totalAmount: amount,
        paymentMode: selectedPaymentMode,
        odometerReading: int.tryParse(odometerController.text),
        carRegistrationNumber: registrationController.text.isNotEmpty ? registrationController.text : null,
        kraPin: kraPinController.text.isNotEmpty ? kraPinController.text : null,
      );

      // Close loading dialog
      context.pop();
      
      // Check if there was an error
      if (_salesController.errorMessage.value.isNotEmpty) {
        print('Error in controller: ${_salesController.errorMessage.value}');
        throw Exception(_salesController.errorMessage.value);
      }
      
      print('Sale created successfully!');
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Sale Created Successfully!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.pop(); // Close success dialog
                context.pop(); // Go back to dashboard
                // Refresh sales on dashboard
                final salesController = Get.find<SalesController>();
                salesController.loadSales();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Close loading dialog
      context.pop();
      
      print('Error creating sale: $e');
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to create sale: $e.message'),
          actions: [
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

