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
                      'OFFICIAL E-TAX INVOICE',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      receipt.organizationName,
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      receipt.organizationAddress,
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Invoice Details
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('PIN: ${receipt.kraPin}'),
                      pw.Text('VRN: ${receipt.registrationNumber}'),
                      pw.Text('Invoice: ${receipt.receiptNumber}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Date: ${receipt.date}'),
                      pw.Text('Time: ${receipt.time}'),
                      if (receipt.kraTrn.isNotEmpty)
                        pw.Text('T.R.N: ${receipt.kraTrn}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Station Details
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Station Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Station: ${receipt.stationName}'),
                    pw.Text('Location: ${receipt.stationLocation}'),
                    pw.Text('City: ${receipt.stationCity}'),
                    pw.Text('County: ${receipt.stationCounty}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Sale Details
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Item Description',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Fuel Type: ${receipt.fuelTypeDisplay}'),
                    pw.Text('Nozzle: ${receipt.nozzleNumber}'),
                    pw.Text('Unit Price: ${receipt.currencySymbol} ${receipt.unitPrice.toStringAsFixed(2)}'),
                    pw.Text('Litres: ${receipt.litresSold.toStringAsFixed(2)}'),
                    pw.Text('Total: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // VAT Breakdown
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  color: PdfColors.grey100,
                ),
                child: pw.Column(
                  children: [
                    pw.Text(
                      'TOTAL (${receipt.currency}): ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'VAT Breakdown',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Taxable Amount (${receipt.vatRate.toInt()}%): ${receipt.currencySymbol} ${receipt.taxableAmount.toStringAsFixed(2)}'),
                    pw.Text('VAT Amount: ${receipt.currencySymbol} ${receipt.vatAmount.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Customer Details
              if (receipt.customerName.isNotEmpty || receipt.customerKraPin.isNotEmpty || 
                  receipt.carRegistration.isNotEmpty || (receipt.odometerReading != null && receipt.odometerReading! > 0))
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Customer Details',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      if (receipt.customerName.isNotEmpty)
                        pw.Text('Name: ${receipt.customerName}'),
                      if (receipt.customerKraPin.isNotEmpty)
                        pw.Text('PIN: ${receipt.customerKraPin}'),
                      if (receipt.carRegistration.isNotEmpty)
                        pw.Text('Car Registration: ${receipt.carRegistration}'),
                      if (receipt.odometerReading != null && receipt.odometerReading! > 0)
                        pw.Text('Odometer: ${receipt.odometerReading}'),
                    ],
                  ),
                ),
              pw.SizedBox(height: 20),

              // Payment Details
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Payment Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text('Mode: ${receipt.paymentModeDisplay}'),
                    if (receipt.externalTransactionId.isNotEmpty)
                      pw.Text('Reference: ${receipt.externalTransactionId}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // KRA Details
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'KRA Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    if (receipt.kraInvoiceNumber.isNotEmpty)
                      pw.Text('E-Invoice No.: ${receipt.kraInvoiceNumber}'),
                    pw.Text('TIN: ${receipt.kraPin}'),
                    if (receipt.kraDeviceSerial.isNotEmpty)
                      pw.Text('S/N: ${receipt.kraDeviceSerial}'),
                    pw.Text('Date: ${receipt.date}'),
                    pw.Text('C.Name: ${receipt.organizationName}'),
                    pw.Text('V.R.N: ${receipt.registrationNumber}'),
                    if (receipt.kraBranchId.isNotEmpty)
                      pw.Text('B.I.D: ${receipt.kraBranchId}'),
                    if (receipt.kraTrn.isNotEmpty)
                      pw.Text('C.I.D: ${receipt.kraTrn}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Footer
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text('Served by: ${receipt.employeeName}'),
                    pw.Text('Shift: ${receipt.shiftStartedAt}'),
                    pw.SizedBox(height: 16),
                    pw.Text(
                      'Thank you for your business.',
                      style: pw.TextStyle(
                        fontStyle: pw.FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
# OFFICIAL E-TAX INVOICE

**${receipt.organizationName}**
${receipt.organizationAddress}

*PIN:* ${receipt.kraPin}
*VRN:* ${receipt.registrationNumber}
*Invoice No:* ${receipt.receiptNumber}
*Date:* ${receipt.date}
*T.R.N:* ${receipt.kraTrn}

---
**Item Description**
---
*${receipt.fuelTypeDisplay}*
*Nozzle:* ${receipt.nozzleNumber}
*Unit Price:* ${receipt.unitPrice.toStringAsFixed(2)}
*Litres:* ${receipt.litresSold.toStringAsFixed(2)}
*Total:* ${receipt.totalAmount.toStringAsFixed(2)}

---
**Summary**
---
**TOTAL (${receipt.currency}):** ${receipt.totalAmount.toStringAsFixed(2)}

**VAT Breakdown**
*Taxable Amount (${receipt.vatRate.toInt()}%):* ${receipt.taxableAmount.toStringAsFixed(2)}
*VAT Amount:* ${receipt.vatAmount.toStringAsFixed(2)}

---
*Customer Details*
---
*Name:* ${receipt.customerName}
*PIN:* ${receipt.customerKraPin}
*Car Registration:* ${receipt.carRegistration}
*Odometer:* ${receipt.odometerReading}

---
*Payment Details*
---
*Mode:* ${receipt.paymentModeDisplay}
*Reference:* ${receipt.externalTransactionId}

---
**KRA Details**
---
*E-Invoice No.:* ${receipt.kraInvoiceNumber}
*TIN:* ${receipt.kraPin}
*S/N:* ${receipt.kraDeviceSerial}
*Date:* ${receipt.date}
*C.Name:* ${receipt.organizationName}
*V.R.N:* ${receipt.registrationNumber}
*B.I.D:* ${receipt.kraBranchId}
*C.I.D:* ${receipt.kraTrn}

---
*Served by:* ${receipt.employeeName}
*Shift:* ${receipt.shiftStartedAt}

---
Thank you for your business.
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
