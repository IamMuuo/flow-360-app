import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';

class ThermalPrinterService {
  static const MethodChannel _channel = MethodChannel('thermal_printer');
  
  /// Print receipt on thermal printer (58mm for PDQ machines)
  static Future<bool> printReceipt(ReceiptModel receipt, {String printerType = '58mm'}) async {
    try {
      // Generate formatted text for thermal printer
      final String formattedText = _generateFormattedText(receipt, printerType);
      
      // For now, we'll use the platform channel approach
      // In a real implementation, you'd connect to the actual printer
      final bool result = await _channel.invokeMethod('printReceipt', {
        'text': formattedText,
        'printerType': printerType,
      });
      
      return result;
    } catch (e) {
      print('ThermalPrinterService: Error printing receipt: $e');
      return false;
    }
  }

  /// Generate formatted text for thermal printer
  static String _generateFormattedText(ReceiptModel receipt, String printerType) {
    final StringBuffer buffer = StringBuffer();
    
    // Paper width based on printer type
    int maxWidth = printerType == '80mm' ? 48 : 32; // Characters per line
    
    // Helper function to center text
    String centerText(String text) {
      if (text.length >= maxWidth) return text.substring(0, maxWidth);
      int padding = (maxWidth - text.length) ~/ 2;
      return ' ' * padding + text + ' ' * (maxWidth - text.length - padding);
    }
    
    // Helper function to create separator line
    String separator() => '-' * maxWidth;
    
    // Header
    buffer.writeln(centerText('OFFICIAL E-TAX INVOICE'));
    buffer.writeln();
    
    // Organization details
    buffer.writeln(centerText(receipt.organizationName));
    buffer.writeln(centerText(receipt.organizationAddress));
    buffer.writeln();
    
    // Invoice details
    buffer.writeln('PIN: ${receipt.kraPin}');
    buffer.writeln('VRN: ${receipt.registrationNumber}');
    buffer.writeln('Invoice: ${receipt.receiptNumber}');
    buffer.writeln('Date: ${receipt.date}');
    if (receipt.kraTrn.isNotEmpty) {
      buffer.writeln('T.R.N: ${receipt.kraTrn}');
    }
    buffer.writeln();
    
    // Station details
    buffer.writeln('Station: ${receipt.stationName}');
    buffer.writeln('Location: ${receipt.stationLocation}');
    buffer.writeln();
    
    // Item description
    buffer.writeln('Item Description');
    buffer.writeln(separator());
    buffer.writeln();
    
    // Fuel details
    buffer.writeln(receipt.fuelTypeDisplay);
    buffer.writeln('Nozzle: ${receipt.nozzleNumber}');
    buffer.writeln('Unit Price: ${receipt.currencySymbol} ${receipt.unitPrice.toStringAsFixed(2)}');
    buffer.writeln('Litres: ${receipt.litresSold.toStringAsFixed(2)}');
    buffer.writeln('Total: ${receipt.currencySymbol} ${receipt.totalAmount.toStringAsFixed(2)}');
    buffer.writeln();
    
    // Summary
    buffer.writeln('Summary');
    buffer.writeln(separator());
    buffer.writeln('TOTAL (${receipt.currency}): ${receipt.totalAmount.toStringAsFixed(2)}');
    buffer.writeln();
    
    // VAT Breakdown
    buffer.writeln('VAT Breakdown');
    buffer.writeln('Taxable Amount (${receipt.vatRate.toInt()}%): ${receipt.taxableAmount.toStringAsFixed(2)}');
    buffer.writeln('VAT Amount: ${receipt.vatAmount.toStringAsFixed(2)}');
    buffer.writeln();
    
    // Customer details (if available)
    if (receipt.customerName.isNotEmpty || receipt.customerKraPin.isNotEmpty || 
        receipt.carRegistration.isNotEmpty || (receipt.odometerReading != null && receipt.odometerReading! > 0)) {
      buffer.writeln('Customer Details');
      buffer.writeln(separator());
      if (receipt.customerName.isNotEmpty) {
        buffer.writeln('Name: ${receipt.customerName}');
      }
      if (receipt.customerKraPin.isNotEmpty) {
        buffer.writeln('PIN: ${receipt.customerKraPin}');
      }
      if (receipt.carRegistration.isNotEmpty) {
        buffer.writeln('Car Registration: ${receipt.carRegistration}');
      }
      if (receipt.odometerReading != null && receipt.odometerReading! > 0) {
        buffer.writeln('Odometer: ${receipt.odometerReading}');
      }
      buffer.writeln();
    }
    
    // Payment details
    buffer.writeln('Payment Details');
    buffer.writeln(separator());
    buffer.writeln('Mode: ${receipt.paymentModeDisplay}');
    if (receipt.externalTransactionId.isNotEmpty) {
      buffer.writeln('Reference: ${receipt.externalTransactionId}');
    }
    buffer.writeln();
    
    // KRA Details
    buffer.writeln('KRA Details');
    buffer.writeln(separator());
    if (receipt.kraInvoiceNumber.isNotEmpty) {
      buffer.writeln('E-Invoice No.: ${receipt.kraInvoiceNumber}');
    }
    buffer.writeln('TIN: ${receipt.kraPin}');
    if (receipt.kraDeviceSerial.isNotEmpty) {
      buffer.writeln('S/N: ${receipt.kraDeviceSerial}');
    }
    buffer.writeln('Date: ${receipt.date}');
    buffer.writeln('C.Name: ${receipt.organizationName}');
    buffer.writeln('V.R.N: ${receipt.registrationNumber}');
    if (receipt.kraBranchId.isNotEmpty) {
      buffer.writeln('B.I.D: ${receipt.kraBranchId}');
    }
    if (receipt.kraTrn.isNotEmpty) {
      buffer.writeln('C.I.D: ${receipt.kraTrn}');
    }
    buffer.writeln();
    
    // Footer
    buffer.writeln('Served by: ${receipt.employeeName}');
    buffer.writeln('Shift: ${receipt.shiftStartedAt}');
    buffer.writeln();
    buffer.writeln(centerText('Thank you for your business.'));
    buffer.writeln();
    buffer.writeln(separator());
    
    return buffer.toString();
  }

  /// Connect to Bluetooth thermal printer
  static Future<bool> connectToBluetoothPrinter(String address) async {
    try {
      final bool result = await _channel.invokeMethod('connectToBluetoothPrinter', {
        'address': address,
      });
      return result;
    } catch (e) {
      print('ThermalPrinterService: Error connecting to Bluetooth printer: $e');
      return false;
    }
  }

  /// Get available Bluetooth printers
  static Future<List<Map<String, dynamic>>> getAvailableBluetoothPrinters() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getAvailableBluetoothPrinters');
      return result.cast<Map<String, dynamic>>();
    } catch (e) {
      print('ThermalPrinterService: Error getting Bluetooth printers: $e');
      return [];
    }
  }

  /// Check if printer is connected
  static Future<bool> isPrinterConnected() async {
    try {
      final bool result = await _channel.invokeMethod('isPrinterConnected');
      return result;
    } catch (e) {
      print('ThermalPrinterService: Error checking printer connection: $e');
      return false;
    }
  }

  /// Disconnect from printer
  static Future<bool> disconnectPrinter() async {
    try {
      final bool result = await _channel.invokeMethod('disconnectPrinter');
      return result;
    } catch (e) {
      print('ThermalPrinterService: Error disconnecting printer: $e');
      return false;
    }
  }

  /// Print test receipt
  static Future<bool> printTestReceipt({String printerType = '58mm'}) async {
    try {
      final String testText = '''
${centerText('TEST RECEIPT', printerType)}
${separator(printerType)}

This is a test receipt for
thermal printer functionality.

Date: ${DateTime.now().toString()}
Time: ${DateTime.now().hour}:${DateTime.now().minute}

${separator(printerType)}
Test completed successfully!
''';
      
      final bool result = await _channel.invokeMethod('printReceipt', {
        'text': testText,
        'printerType': printerType,
      });
      
      return result;
    } catch (e) {
      print('ThermalPrinterService: Error printing test receipt: $e');
      return false;
    }
  }

  /// Helper function to center text
  static String centerText(String text, String printerType) {
    int maxWidth = printerType == '80mm' ? 48 : 32;
    if (text.length >= maxWidth) return text.substring(0, maxWidth);
    int padding = (maxWidth - text.length) ~/ 2;
    return ' ' * padding + text + ' ' * (maxWidth - text.length - padding);
  }

  /// Helper function to create separator line
  static String separator(String printerType) {
    int maxWidth = printerType == '80mm' ? 48 : 32;
    return '-' * maxWidth;
  }
}
