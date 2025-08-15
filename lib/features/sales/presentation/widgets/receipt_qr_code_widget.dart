import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/sales/controllers/receipt_controller.dart';

class ReceiptQrCodeWidget extends StatelessWidget {
  final String saleId;
  final ReceiptController controller = Get.find<ReceiptController>();

  ReceiptQrCodeWidget({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isGeneratingQrCode.value) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Generating QR Code...'),
            ],
          ),
        );
      }

      final qrData = controller.qrCodeData.value;
      final pdfUrl = controller.pdfUrl.value;

      if (qrData == null || pdfUrl == null) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Generate QR Code for E-Receipt',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customers can scan this QR code to download their receipt as PDF',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.generateQrCodeForReceipt(saleId),
              icon: const Icon(Icons.qr_code),
              label: const Text('Generate QR Code'),
            ),
          ],
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR Code
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: QrImageView(
              data: pdfUrl,
              version: QrVersions.auto,
              size: 180.0,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // Receipt Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Receipt: ${qrData['receipt_number'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text('Organization: ${qrData['organization'] ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                Text('Station: ${qrData['station'] ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                Text('Amount: ${qrData['amount'] ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                Text('Date: ${qrData['date']?.substring(0, 10) ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Instructions
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 16),
                    const SizedBox(width: 6),
                    const Text(
                      'How to use:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '1. Customer scans this QR code with their phone\n'
                  '2. QR code opens the receipt download link\n'
                  '3. Customer can download the receipt as PDF\n'
                  '4. Receipt is valid for 30 days',
                  style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons
          Column(
            children: [
              // First row of buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => controller.clearQrCodeData(),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Generate New', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Share the QR code or PDF URL
                        final qrData = controller.qrCodeData.value;
                        if (qrData != null && qrData['download_url'] != null) {
                          // You can implement sharing functionality here
                          // For now, just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Share functionality coming soon!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Second row of buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Test QR code scanning
                        final qrData = controller.qrCodeData.value;
                        if (qrData != null && qrData['sale_id'] != null) {
                          final saleId = qrData['sale_id'].toString();
                          if (saleId.isNotEmpty) {
                            context.pop(); // Close QR dialog first
                            context.push('/receipt/$saleId');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid sale ID in QR code'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No valid QR code data available'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('Test Scan', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Close', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}
