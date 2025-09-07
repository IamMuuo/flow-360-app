import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_360/features/sales/controllers/receipt_controller.dart';
import 'package:flow_360/features/sales/presentation/widgets/kra_qr_code_widget.dart';
import 'package:flow_360/features/sales/services/kra_qr_service.dart';

class ReceiptQrCodeWidget extends StatelessWidget {
  final String saleId;
  final ReceiptController controller = Get.find<ReceiptController>();

  ReceiptQrCodeWidget({super.key, required this.saleId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final qrData = controller.qrCodeData.value;

      if (qrData == null) {
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
              'Generate KRA QR Code',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Generate KRA-compliant QR code for receipt verification',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => controller.generateQrCodeForReceipt(saleId),
              icon: const Icon(Icons.qr_code),
              label: const Text('Generate KRA QR Code'),
            ),
            // Show error message if validation failed
            if (controller.errorMessage.value.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
          const SizedBox(height: 16),

          // KRA QR Code Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'KRA eTIMS Verification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // KRA QR Code
                KraQrCodeWidget(
                  kraPin: qrData['kra_pin'] ?? 'A000000000Z',
                  bhfId: qrData['sdc_id'] ?? 'KRACU0100000001',
                  receiptSignature: qrData['receipt_signature'] ?? 'V249-J39C-FJ48-HE2W',
                  size: 150.0,
                ),
                const SizedBox(height: 12),
                Text(
                  'Scan to verify with KRA eTIMS',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'This QR code links directly to KRA\'s eTIMS system for receipt verification',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Instructions
          Container(
            padding: const EdgeInsets.all(12),
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
                  '2. QR code opens KRA eTIMS verification page\n'
                  '3. Customer can verify receipt authenticity\n'
                  '4. Receipt is KRA-compliant and tax-verified',
                  style: TextStyle(fontSize: 11, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

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
                        // Share the KRA QR code
                        final qrData = controller.qrCodeData.value;
                        if (qrData != null) {
                          // Generate the KRA QR URL for sharing
                          final kraUrl = KraQrService.generateKraQrUrl(
                            kraPin: qrData['kra_pin'] ?? 'A000000000Z',
                            bhfId: qrData['sdc_id'] ?? 'KRACU0100000001',
                            receiptSignature: qrData['receipt_signature'] ?? 'V249-J39C-FJ48-HE2W',
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('KRA QR URL: $kraUrl'),
                              duration: const Duration(seconds: 5),
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
