import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/sales/controllers/receipt_controller.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';
import 'package:flow_360/features/sales/services/receipt_service.dart';

class ReceiptScreen extends StatelessWidget {
  final String saleId;
  final ReceiptController controller = Get.put(ReceiptController());

  ReceiptScreen({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    // Fetch receipt data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSaleReceipt(saleId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _showPrintOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _showShareOptions(context),
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchSaleReceipt(saleId),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final receipt = controller.currentReceipt.value;
        if (receipt == null) {
          return const Center(
            child: Text('No receipt data available'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Success/Error Messages
              Obx(() {
                if (controller.successMessage.value.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.successMessage.value,
                            style: const TextStyle(color: Colors.green),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.green),
                          onPressed: () => controller.clearSuccess(),
                        ),
                      ],
                    ),
                  );
                }
                if (controller.errorMessage.value.isNotEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => controller.clearError(),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              
              _buildReceiptCard(receipt),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReceiptCard(ReceiptModel receipt) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(receipt),
            const Divider(),
            
            // Organization Details
            _buildOrganizationDetails(receipt),
            const Divider(),
            
            // Sale Details
            _buildSaleDetails(receipt),
            const Divider(),
            
            // VAT Breakdown
            _buildVatBreakdown(receipt),
            const Divider(),
            
            // Customer Details
            _buildCustomerDetails(receipt),
            const Divider(),
            
            // Payment Details
            _buildPaymentDetails(receipt),
            const Divider(),
            
            // KRA Details
            _buildKraDetails(receipt),
            const Divider(),
            
            // Footer
            _buildFooter(receipt),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ReceiptModel receipt) {
    return Column(
      children: [
        const Text(
          'OFFICIAL E-TAX INVOICE',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          receipt.organizationName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          receipt.organizationAddress,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('PIN: ${receipt.kraPin}'),
            Text('VRN: ${receipt.registrationNumber}'),
          ],
        ),
        Text('Invoice: ${receipt.receiptNumber}'),
        Text('Date: ${receipt.date}'),
        if (receipt.kraTrn.isNotEmpty)
          Text('T.R.N: ${receipt.kraTrn}'),
      ],
    );
  }

  Widget _buildOrganizationDetails(ReceiptModel receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Station Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('Station: ${receipt.stationName}'),
        Text('Location: ${receipt.stationLocation}'),
        Text('City: ${receipt.stationCity}'),
        Text('County: ${receipt.stationCounty}'),
      ],
    );
  }

  Widget _buildSaleDetails(ReceiptModel receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Item Description',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receipt.fuelTypeDisplay,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Nozzle: ${receipt.nozzleNumber}'),
              Text('Unit Price: ${receipt.currencySymbol} ${receipt.unitPrice.toStringAsFixed(2)}'),
              Text('Litres: ${receipt.litresSold.toStringAsFixed(2)}'),
              Text('Total: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVatBreakdown(ReceiptModel receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Text(
                'TOTAL (${receipt.currency}): ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'VAT Breakdown',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Taxable Amount (${receipt.vatRate.toInt()}%): ${receipt.currencySymbol} ${receipt.taxableAmount.toStringAsFixed(2)}'),
              Text('VAT Amount: ${receipt.currencySymbol} ${receipt.vatAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerDetails(ReceiptModel receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (receipt.customerName.isNotEmpty) Text('Name: ${receipt.customerName}'),
        if (receipt.customerKraPin.isNotEmpty) Text('PIN: ${receipt.customerKraPin}'),
        if (receipt.carRegistration.isNotEmpty) Text('Car Registration: ${receipt.carRegistration}'),
        if (receipt.odometerReading != null && receipt.odometerReading! > 0) Text('Odometer: ${receipt.odometerReading}'),
      ],
    );
  }

  Widget _buildPaymentDetails(ReceiptModel receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text('Mode: ${receipt.paymentModeDisplay}'),
        if (receipt.externalTransactionId.isNotEmpty)
          Text('Reference: ${receipt.externalTransactionId}'),
      ],
    );
  }

  Widget _buildKraDetails(ReceiptModel receipt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KRA Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (receipt.kraInvoiceNumber.isNotEmpty)
          Text('E-Invoice No.: ${receipt.kraInvoiceNumber}'),
        Text('TIN: ${receipt.kraPin}'),
        if (receipt.kraDeviceSerial.isNotEmpty)
          Text('S/N: ${receipt.kraDeviceSerial}'),
        Text('Date: ${receipt.date}'),
        Text('C.Name: ${receipt.organizationName}'),
        Text('V.R.N: ${receipt.registrationNumber}'),
        if (receipt.kraBranchId.isNotEmpty)
          Text('B.I.D: ${receipt.kraBranchId}'),
        if (receipt.kraTrn.isNotEmpty)
          Text('C.I.D: ${receipt.kraTrn}'),
      ],
    );
  }

  Widget _buildFooter(ReceiptModel receipt) {
    return Column(
      children: [
        Text('Served by: ${receipt.employeeName}'),
        Text('Shift: ${receipt.shiftStartedAt}'),
        const SizedBox(height: 16),
        const Text(
          'Thank you for your business.',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showPrintOptions(context),
                icon: const Icon(Icons.print),
                label: const Text('Print'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showShareOptions(context),
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _savePdfToDevice(context),
                icon: const Icon(Icons.download),
                label: const Text('Save PDF'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareAsText(context),
                icon: const Icon(Icons.text_fields),
                label: const Text('Share Text'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showPrintOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Printer Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Thermal Printer (58mm)'),
              subtitle: const Text('Portable PDQ machine'),
              onTap: () {
                Navigator.pop(context);
                controller.printReceipt(
                  saleId: saleId,
                  printerType: 'thermal_58mm',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Thermal Printer (80mm)'),
              subtitle: const Text('Standard thermal printer'),
              onTap: () {
                Navigator.pop(context);
                controller.printReceipt(
                  saleId: saleId,
                  printerType: 'thermal_80mm',
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF Receipt'),
              subtitle: const Text('Generate PDF for printing'),
              onTap: () {
                Navigator.pop(context);
                controller.printReceipt(
                  saleId: saleId,
                  printerType: 'pdf',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Share Receipt',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Share as PDF'),
              subtitle: const Text('Send via email, WhatsApp, etc.'),
              onTap: () {
                Navigator.pop(context);
                if (controller.currentReceipt.value != null) {
                  controller.generateAndSharePdf(controller.currentReceipt.value!);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Share as Text'),
              subtitle: const Text('Plain text format'),
              onTap: () {
                Navigator.pop(context);
                if (controller.currentReceipt.value != null) {
                  controller.shareAsText(controller.currentReceipt.value!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _savePdfToDevice(BuildContext context) {
    if (controller.currentReceipt.value != null) {
      controller.savePdfToDevice(controller.currentReceipt.value!);
    }
  }

  void _shareAsText(BuildContext context) {
    if (controller.currentReceipt.value != null) {
      controller.shareAsText(controller.currentReceipt.value!);
    }
  }
}
