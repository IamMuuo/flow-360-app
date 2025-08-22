import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';

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
        final savedFile = await file.copy('${downloadsDir.path}/receipt_${receipt.receiptNumber}.pdf');
        return;
      }
      throw Exception('Could not access downloads directory');
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  static Future<String> generateReceiptText(ReceiptModel receipt) {
    final text = '''
NORMAL INVOICE

Trade Name
Address, City
PIN: ${receipt.kraPin}
TAX INVOICE

Welcome to our shop

Buyer PIN: ${receipt.customerKraPin.isNotEmpty ? receipt.customerKraPin : 'A000000000Z'}

---
${receipt.fuelTypeDisplay}
${receipt.litresSold.toStringAsFixed(2)}x ${receipt.currencySymbol} ${receipt.unitPrice.toStringAsFixed(2)}
${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}B

---
TOTAL BEFORE DISCOUNT: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}
TOTAL DISCOUNT AWARDED: (0.00)
SUB TOTAL: ${receipt.currencySymbol} ${receipt.taxableAmount.toStringAsFixed(2)}
VAT: ${receipt.currencySymbol} ${receipt.vatAmount.toStringAsFixed(2)}
TOTAL: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}

CASH: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}
ITEMS NUMBER: 1

---
Rate    Taxable Amount    VAT
EX      ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00
16%     ${receipt.currencySymbol} ${receipt.taxableAmount.toStringAsFixed(2)}    ${receipt.currencySymbol} ${receipt.vatAmount.toStringAsFixed(2)}
0%      ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00
Non-VAT ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00
8%      ${receipt.currencySymbol} 0.00        ${receipt.currencySymbol} 0.00

---
Date: ${receipt.date}
Time: ${receipt.time}
SCU ID: ${receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001'}
CU INVOICE NO.: ${receipt.sdcId.isNotEmpty ? receipt.sdcId : 'KRACU0100000001'}/${receipt.receiptNo.isNotEmpty ? receipt.receiptNo : receipt.receiptNumber}
Internal Data: ${receipt.internalData.isNotEmpty ? receipt.internalData : 'TE68-SLA2-34J5-EAV3-N569-88LJ-Q7'}
Receipt Signature: ${receipt.receiptSignature.isNotEmpty ? receipt.receiptSignature : 'V249-J39C-FJ48-HE2W'}

---
RECEIPT NUMBER: ${receipt.receiptNo.isNotEmpty ? receipt.receiptNo : receipt.receiptNumber}
DATE: ${receipt.date}
TIME: ${receipt.time}

---
THANK YOU
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
}
