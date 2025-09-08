import 'package:ciontek/ciontek.dart';
import 'package:ciontek/models/ciontek_print_line.dart';
import 'package:flow_360/features/sales/sales.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key, required this.saleId});

  final String saleId;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final ReceiptController controller = Get.put(ReceiptController());

  String saleId = '';
  @override
  void initState() {
    super.initState();
    saleId = widget.saleId;
  }

  @override
  Widget build(BuildContext context) {
    // Fetch receipt data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchSaleReceipt(saleId);
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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
          return const Center(child: Text('No receipt data available'));
        }

        return Column(
          children: [
            // Success/Error Messages
            Obx(() {
              if (controller.successMessage.value.isNotEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(16),
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
                  margin: const EdgeInsets.all(16),
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

            // ASCII Preview Only
            Expanded(child: _buildAsciiPreview(receipt)),
          ],
        );
      }),
    );
  }

  Widget _buildActionButtons(BuildContext context, String asciiText) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  final lines = asciiText.split('\n');
                  final printLines = lines.map((printable) {
                    return CiontekPrintLine(
                      text: printable,
                      bold:
                          printable.contains("**") ||
                          printable.contains("CASH"),
                      textGray: TextGray.medium,
                      type: CiontekPrintLineType.text,
                    );
                  }).toList();
                  printLines.add(CiontekPrintLine.feedPaper(lines: 5));
                  Ciontek().printLine(lines: printLines);
                },
                // _showPrintOptions(context),
                icon: const Icon(Icons.print),
                label: Text('Print'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Thermal Printer (80mm)'),
              subtitle: const Text('Standard thermal printer'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('PDF Receipt'),
              subtitle: const Text('Generate PDF for printing'),
              onTap: () {
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
                  controller.generateAndSharePdf(
                    controller.currentReceipt.value!,
                  );
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

  Widget _buildAsciiPreview(ReceiptModel receipt) {
    return FutureBuilder<String>(
      future: ReceiptService.generateReceiptText(receipt),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error generating ASCII preview: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        final asciiText = snapshot.data ?? 'No ASCII preview available';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ASCII Preview Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ASCII Receipt Preview - This is how the receipt will appear when printed or shared as text',
                        style: TextStyle(color: Colors.blue[800], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // ASCII Text Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  asciiText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.3,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons for ASCII Preview
              _buildActionButtons(context, asciiText),
            ],
          ),
        );
      },
    );
  }
}
