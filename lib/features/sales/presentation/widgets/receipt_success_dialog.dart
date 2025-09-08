import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/sales/controllers/receipt_controller.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';
import 'package:flow_360/features/sales/presentation/widgets/receipt_qr_code_widget.dart';

class ReceiptSuccessDialog extends StatelessWidget {
  final String saleId;
  final VoidCallback? onClose;

  const ReceiptSuccessDialog({super.key, required this.saleId, this.onClose});

  @override
  Widget build(BuildContext context) {
    final receiptController = Get.put(ReceiptController());

    // Fetch receipt data when dialog is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching receipt for sale ID: $saleId');
      receiptController.fetchSaleReceipt(saleId);
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          if (receiptController.isLoading.value) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading receipt...'),
              ],
            );
          }

          if (receiptController.errorMessage.value.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading receipt: ${receiptController.errorMessage.value}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => receiptController.fetchSaleReceipt(saleId),
                  child: const Text('Retry'),
                ),
              ],
            );
          }

          final receipt = receiptController.currentReceipt.value;
          if (receipt == null) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt, color: Colors.grey, size: 48),
                SizedBox(height: 16),
                Text('No receipt data available'),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              const Text(
                'Sale Completed Successfully!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Receipt Number
              Text(
                'Receipt: ${receipt.receiptNumber}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Amount
              Text(
                'Amount: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (onClose != null) onClose!();
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push('/receipt/${receipt.saleId}');
                      },
                      icon: const Icon(Icons.receipt),
                      label: const Text('View'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Print, Share, and QR Code Options
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showPrintOptions(
                        context,
                        receiptController,
                        receipt,
                      ),
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showQrCodeDialog(context),
                      icon: const Icon(Icons.qr_code),
                      label: const Text('QR Code'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showShareOptions(
                        context,
                        receiptController,
                        receipt,
                      ),
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showPrintOptions(
    BuildContext context,
    ReceiptController controller,
    ReceiptModel receipt,
  ) {}

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'E-Receipt QR Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Generate a QR code that customers can scan to download their receipt as PDF',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ReceiptQrCodeWidget(saleId: saleId),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareOptions(
    BuildContext context,
    ReceiptController controller,
    ReceiptModel receipt,
  ) {
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
                controller.generateAndSharePdf(receipt);
              },
            ),
            ListTile(
              leading: const Icon(Icons.text_fields),
              title: const Text('Share as Text'),
              subtitle: const Text('Plain text format'),
              onTap: () {
                Navigator.pop(context);
                controller.shareAsText(receipt);
              },
            ),
          ],
        ),
      ),
    );
  }
}
