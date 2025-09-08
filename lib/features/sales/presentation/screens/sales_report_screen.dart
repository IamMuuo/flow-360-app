import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/sales/controllers/sales_report_controller.dart';
import 'package:flow_360/features/sales/models/sales_report_model.dart';
import 'package:flow_360/features/sales/controllers/sales_controller.dart';
import 'package:flow_360/features/sales/models/sale_model.dart';
import 'package:flow_360/features/sales/presentation/widgets/credit_note_dialog.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final SalesReportController _controller = Get.put(SalesReportController());

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideAnimationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: const Text(
                  'Sales Reports',
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
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Center(
                    child: Icon(
                      Icons.analytics_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () => _controller.fetchSalesReport(),
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Actions
                      _buildQuickActions(),
                      const SizedBox(height: 24),

                      // Error Message
                      Obx(() {
                        if (_controller.errorMessage.value.isNotEmpty) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _controller.errorMessage.value,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _controller.clearError(),
                                  icon: const Icon(Icons.close),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // Success Message
                      Obx(() {
                        if (_controller.successMessage.value.isNotEmpty) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _controller.successMessage.value,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _controller.clearSuccess(),
                                  icon: const Icon(Icons.close),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // Summary Statistics
                      _buildSummaryStatistics(),
                      const SizedBox(height: 24),

                      // Recent Sales Section
                      _buildRecentSalesSection(),
                      const SizedBox(height: 24),

                      // Report Sections
                      _buildReportSections(),
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

  Widget _buildQuickActions() {
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
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.today,
                title: 'Today',
                subtitle: 'View today\'s sales',
                onTap: () {
                  final now = DateTime.now();
                  _controller.setDateRange(
                    DateTime(now.year, now.month, now.day),
                    DateTime(now.year, now.month, now.day, 23, 59, 59),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.view_week,
                title: 'This Week',
                subtitle: 'View this week\'s sales',
                onTap: () {
                  final now = DateTime.now();
                  final startOfWeek = now.subtract(
                    Duration(days: now.weekday - 1),
                  );
                  _controller.setDateRange(startOfWeek, now);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.calendar_month,
                title: 'This Month',
                subtitle: 'View this month\'s sales',
                onTap: () {
                  final now = DateTime.now();
                  final startOfMonth = DateTime(now.year, now.month, 1);
                  _controller.setDateRange(startOfMonth, now);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.filter_alt,
                title: 'Custom Range',
                subtitle: 'Select custom date range',
                onTap: () => _showDateRangePicker(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStatistics() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.attach_money,
                  title: 'Total Revenue',
                  value: 'KES ${_controller.totalRevenue.toStringAsFixed(2)}',
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.local_gas_station,
                  title: 'Total Litres',
                  value: '${_controller.totalLitres.toStringAsFixed(1)}L',
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.receipt,
                  title: 'Total Sales',
                  value: '${_controller.totalSales}',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  title: 'Employees',
                  value: '${_controller.totalEmployees}',
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSalesSection() {
    final salesController = Get.put(SalesController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Sales',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: () => salesController.loadSales(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (salesController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (salesController.sales.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: const Center(child: Text('No sales recorded yet')),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: salesController.sales.take(10).length,
            itemBuilder: (context, index) {
              final sale = salesController.sales[index];
              return _buildSaleCard(context, sale);
            },
          );
        }),
      ],
    );
  }

  Widget _buildSaleCard(BuildContext context, SaleModel sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${sale.litresSold.toStringAsFixed(2)}L - ${sale.paymentMode}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'KES ${sale.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Receipt: ${sale.receiptNumber ?? 'N/A'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDateTime(sale.soldAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Print Receipt Icon
                  GestureDetector(
                    onTap: () => _printReceipt(sale.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.print, color: Colors.blue, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // QR Code Icon
                  GestureDetector(
                    onTap: () => _showQrCode(sale.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.qr_code,
                        color: Colors.orange,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Credit Note Icon
                  GestureDetector(
                    onTap: () => _showCreditNoteDialog(sale),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.red,
                        size: 16,
                      ),
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

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _printReceipt(String saleId) {
    // TODO: Implement print receipt functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Print receipt for sale $saleId'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showQrCode(String saleId) {
    // TODO: Implement QR code functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Show QR code for sale $saleId'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCreditNoteDialog(SaleModel sale) {
    showDialog(
      context: context,
      builder: (context) => CreditNoteDialog(sale: sale),
    ).then((result) {
      if (result == true) {
        // Refresh sales data after successful credit note creation
        final salesController = Get.find<SalesController>();
        salesController.loadSales();
      }
    });
  }

  Widget _buildReportSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Reports',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),

        // Daily Reports
        _buildReportSection(
          title: 'Daily Sales',
          icon: Icons.calendar_today,
          onTap: () => _showDailyReports(),
        ),

        const SizedBox(height: 12),

        // Employee Reports
        _buildReportSection(
          title: 'Employee Performance',
          icon: Icons.people,
          onTap: () => _showEmployeeReports(),
        ),

        const SizedBox(height: 12),

        // Fuel Type Reports
        _buildReportSection(
          title: 'Fuel Type Analysis',
          icon: Icons.local_gas_station,
          onTap: () => _showFuelTypeReports(),
        ),
      ],
    );
  }

  Widget _buildReportSection({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
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
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker() {
    showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start:
            _controller.selectedStartDate.value ??
            DateTime.now().subtract(const Duration(days: 30)),
        end: _controller.selectedEndDate.value ?? DateTime.now(),
      ),
    ).then((dateRange) {
      if (dateRange != null) {
        _controller.setDateRange(dateRange.start, dateRange.end);
      }
    });
  }

  void _showDailyReports() {
    _showDetailedReportDialog(
      'Daily Sales Report',
      _controller.dailyReports,
      (report) => '${report.date} - ${report.totalSales} sales',
      (report) => 'KES ${report.totalAmount.toStringAsFixed(2)}',
      (report) => '${report.totalLitres.toStringAsFixed(1)}L',
    );
  }

  void _showEmployeeReports() {
    _showDetailedReportDialog(
      'Employee Performance Report',
      _controller.employeeReports,
      (report) => report.employeeName,
      (report) => 'KES ${report.totalAmount.toStringAsFixed(2)}',
      (report) => '${report.totalSales} sales',
    );
  }

  void _showFuelTypeReports() {
    _showDetailedReportDialog(
      'Fuel Type Analysis Report',
      _controller.fuelTypeReports,
      (report) => report.fuelTypeDisplay,
      (report) => 'KES ${report.totalAmount.toStringAsFixed(2)}',
      (report) => '${report.totalLitres.toStringAsFixed(1)}L',
    );
  }

  void _showDetailedReportDialog<T>(
    String title,
    List<T> reports,
    String Function(T) titleExtractor,
    String Function(T) value1Extractor,
    String Function(T) value2Extractor,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(titleExtractor(report)),
                  subtitle: Text(
                    '${value1Extractor(report)} • ${value2Extractor(report)}',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Show detailed view for this report
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
