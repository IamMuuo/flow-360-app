import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';
import 'package:flow_360/features/sales/services/kra_qr_service.dart';

class ReceiptService {
  static Future<File> generatePdfReceipt(ReceiptModel receipt) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'NORMAL INVOICE',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Trade Name',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Address, City',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Invoice Details
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('PIN: ${receipt.kraPin}'),
                    pw.Text('TAX INVOICE'),
                    pw.SizedBox(height: 8),
                    pw.Text('Welcome to our shop'),
                    pw.SizedBox(height: 8),
                    pw.Text('Buyer PIN: A000000000Z'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Item Details
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      receipt.fuelTypeDisplay,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('${receipt.litresSold.toStringAsFixed(2)}x ${receipt.currencySymbol} ${receipt.unitPrice.toStringAsFixed(2)}'),
                    pw.Text('${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}B'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Summary
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('TOTAL BEFORE DISCOUNT: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}'),
                    pw.Text('TOTAL DISCOUNT AWARDED: (0.00)'),
                    pw.Text('SUB TOTAL: ${receipt.currencySymbol} ${receipt.taxableAmount.toStringAsFixed(2)}'),
                    pw.Text('VAT: ${receipt.currencySymbol} ${receipt.vatAmount.toStringAsFixed(2)}'),
                    pw.Text(
                      'TOTAL: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('CASH: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}'),
                    pw.Text('ITEMS NUMBER: 1'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Tax Breakdown
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Rate    Taxable Amount    VAT'),
                    pw.Text('EX      ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00'),
                    pw.Text('16%     ${receipt.currencySymbol} ${receipt.taxableAmount.toStringAsFixed(2)}    ${receipt.currencySymbol} ${receipt.vatAmount.toStringAsFixed(2)}'),
                    pw.Text('0%      ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00'),
                    pw.Text('Non-VAT ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00'),
                    pw.Text('8%      ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // SCU Information
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Date: ${receipt.date}'),
                    pw.Text('Time: ${receipt.time}'),
                    pw.Text('SCU ID: ${receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001'}'),
                    pw.Text('CU INVOICE NO.: ${receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001'}/${receipt.receiptNo.isNotEmpty ? receipt.receiptNo : receipt.receiptNumber}'),
                    pw.Text('Internal Data: ${receipt.internalData.isNotEmpty ? receipt.internalData : 'TE68-SLA2-34J5-EAV3-N569-88LJ-Q7'}'),
                    pw.Text('Receipt Signature: ${receipt.receiptSignature.isNotEmpty ? receipt.receiptSignature : 'V249-J39C-FJ48-HE2W'}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // KRA QR Code Section
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'KRA eTIMS QR Code',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Container(
                      width: 100,
                      height: 100,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.black, width: 1),
                      ),
                      child: pw.Center(
                        child: pw.Text(
                          'QR Code\n${_generateKraQrUrl(receipt)}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Scan to verify with KRA eTIMS',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // TIS Information
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('RECEIPT NUMBER: ${receipt.receiptNo.isNotEmpty ? receipt.receiptNo : receipt.receiptNumber}'),
                    pw.Text('DATE: ${receipt.date}'),
                    pw.Text('TIME: ${receipt.time}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Divider
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Footer
              pw.Center(
                child: pw.Text(
                  'THANK YOU',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/receipt_${receipt.receiptNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> sharePdfReceipt(ReceiptModel receipt) async {
    try {
      final file = await generatePdfReceipt(receipt);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Receipt for sale ${receipt.receiptNumber}',
      );
    } catch (e) {
      throw Exception('Failed to share PDF: $e');
    }
  }

  static Future<void> savePdfReceipt(ReceiptModel receipt) async {
    try {
      final file = await generatePdfReceipt(receipt);
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir != null) {
        await file.copy('${downloadsDir.path}/receipt_${receipt.receiptNumber}.pdf');
        return;
      }
      throw Exception('Could not access downloads directory');
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  static Future<String> generateReceiptText(ReceiptModel receipt) {
    // Create full-width underlines for 58mm printer (32 characters)
    const fullWidthLine = '================================';
    const width = 32;
    
    // Helper function to center text perfectly for 58mm width
    String centerText(String text, int lineWidth) {
      if (text.length >= lineWidth) return text.substring(0, lineWidth);
      final padding = (lineWidth - text.length) ~/ 2;
      return ' ' * padding + text;
    }
    
    // Helper function to format currency amounts
    String formatAmount(double amount) {
      return '${receipt.currencySymbol}${amount.toStringAsFixed(2)}';
    }
    
    final text = '''
${centerText(receipt.organizationName, width)}
${centerText(receipt.organizationAddress, width)}
${centerText('PIN: ${receipt.kraPin}', width)}

${centerText('*** TAX INVOICE ***', width)}

${centerText('Welcome to our shop', width)}

${centerText('Buyer PIN: ${receipt.customerKraPin.isNotEmpty ? receipt.customerKraPin : 'A000000000Z'}', width)}

$fullWidthLine
${centerText(receipt.fuelTypeDisplay, width)}
${centerText('${receipt.litresSold.toStringAsFixed(2)}x ${formatAmount(receipt.unitPrice)}', width)}
${centerText('${formatAmount(receipt.totalAmount)}B', width)}

$fullWidthLine
${centerText('TOTAL BEFORE DISCOUNT: ${formatAmount(receipt.totalAmount)}', width)}
${centerText('TOTAL DISCOUNT: (0.00)', width)}
${centerText('SUB TOTAL: ${formatAmount(receipt.taxableAmount)}', width)}
${centerText('VAT: ${formatAmount(receipt.vatAmount)}', width)}
${centerText('TOTAL: ${formatAmount(receipt.totalAmount)}', width)}

${centerText('CASH: ${formatAmount(receipt.totalAmount)}', width)}
${centerText('ITEMS: 1', width)}

$fullWidthLine
${centerText('Rate    Taxable    VAT', width)}
${centerText('EX      ${formatAmount(0.00)}    ${formatAmount(0.00)}', width)}
${centerText('16%     ${formatAmount(receipt.taxableAmount)}    ${formatAmount(receipt.vatAmount)}', width)}
${centerText('0%      ${formatAmount(0.00)}    ${formatAmount(0.00)}', width)}
${centerText('Non-VAT ${formatAmount(0.00)}    ${formatAmount(0.00)}', width)}
${centerText('8%      ${formatAmount(0.00)}    ${formatAmount(0.00)}', width)}

$fullWidthLine
${centerText('Date: ${receipt.date}', width)}
${centerText('Time: ${receipt.time}', width)}
${centerText('SCU ID: ${receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001'}', width)}
${centerText('CU INVOICE: ${receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001'}/${receipt.receiptNo.isNotEmpty ? receipt.receiptNo : receipt.receiptNumber}', width)}
${centerText('Internal: ${receipt.internalData.isNotEmpty ? receipt.internalData : 'TE68-SLA2-34J5-EAV3-N569-88LJ-Q7'}', width)}
${centerText('Signature: ${receipt.receiptSignature.isNotEmpty ? receipt.receiptSignature : 'V249-J39C-FJ48-HE2W'}', width)}

$fullWidthLine
${centerText('RECEIPT: ${receipt.receiptNo.isNotEmpty ? receipt.receiptNo : receipt.receiptNumber}', width)}
${centerText('DATE: ${receipt.date}', width)}
${centerText('TIME: ${receipt.time}', width)}

$fullWidthLine
${centerText('KRA eTIMS QR Code:', width)}
${centerText(_generateKraQrUrl(receipt), width)}
${centerText('Scan to verify with KRA eTIMS', width)}

$fullWidthLine
${centerText('THANK YOU', width)}
''';
    return Future.value(text);
  }

  static Future<void> shareTextReceipt(ReceiptModel receipt) async {
    try {
      final text = await generateReceiptText(receipt);
      await Share.share(
        text,
        subject: 'Receipt for sale ${receipt.receiptNumber}',
      );
    } catch (e) {
      throw Exception('Failed to share text: $e');
    }
  }

  /// Generates KRA-compliant QR URL for the receipt
  static String _generateKraQrUrl(ReceiptModel receipt) {
    try {
      // Extract KRA PIN from receipt
      final kraPin = receipt.kraPin.isNotEmpty ? receipt.kraPin : 'A000000000Z';
      
      // Extract BHF ID from SCU ID or use default
      final bhfId = receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001';
      
      // Check if we have valid KRA data (not default values)
      if (kraPin == 'A000000000Z' || bhfId == 'KRACU0100000001') {
        // Return a placeholder message for invalid KRA data
        return 'KRA QR Code not available - Invalid KRA PIN or BHF ID';
      }
      
      // Generate receipt signature
      final receiptSignature = KraQrService.generateReceiptSignature(
        receiptNumber: receipt.receiptNumber,
        timestamp: receipt.date,
        totalAmount: receipt.totalAmount.toString(),
        kraPin: kraPin,
      );
      
      // Generate the KRA QR URL
      return KraQrService.generateKraQrUrl(
        kraPin: kraPin,
        bhfId: bhfId,
        receiptSignature: receiptSignature,
      );
    } catch (e) {
      // Return a placeholder message if QR generation fails
      return 'KRA QR Code not available - ${e.toString()}';
    }
  }
}
