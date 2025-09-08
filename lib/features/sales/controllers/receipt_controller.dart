import 'dart:convert';

import 'package:ciontek/ciontek.dart';
import 'package:ciontek/models/ciontek_print_line.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/sales/repository/receipt_repository.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';
import 'package:flow_360/features/sales/services/receipt_service.dart';
import 'package:flow_360/features/sales/services/thermal_printer_service.dart';
import 'package:flow_360/features/sales/services/kra_qr_service.dart';

class ReceiptController extends GetxController {
  final ReceiptRepository _repository = GetIt.instance<ReceiptRepository>();

  var currentReceipt = Rxn<ReceiptModel>();
  var recentReceipts = <ReceiptModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var receiptText = ''.obs;
  var receiptHtml = ''.obs;
  var printStatus = ''.obs;
  var isGeneratingPdf = false.obs;
  var isSharing = false.obs;
  var qrCodeData = Rxn<Map<String, dynamic>>();
  var pdfUrl = Rxn<String>();
  var isGeneratingQrCode = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecentReceipts();
  }

  Future<void> fetchSaleReceipt(String saleId) async {
    print('ReceiptController: Fetching receipt for sale ID: $saleId');
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final receipt = await _repository.getSaleReceipt(saleId);
      print(
        'ReceiptController: Receipt fetched successfully: ${receipt.receiptNumber}',
      );
      currentReceipt.value = receipt;
    } catch (e) {
      print('ReceiptController: Error fetching receipt: $e');
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReceiptText(String saleId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final text = await _repository.getSaleReceiptText(saleId);
      receiptText.value = text;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchReceiptHtml(String saleId) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final html = await _repository.getSaleReceiptHtml(saleId);
      receiptHtml.value = html;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> printReceipt({required ReceiptModel receipt}) async {
    isLoading.value = true;
    errorMessage.value = '';
    printStatus.value = '';

    try {
      // First get the receipt data
      // final receipt = await _repository.getSaleReceipt(saleId);

      final asciiText = await ReceiptService.generateReceiptText(receipt);
      final lines = asciiText.split('\n');
      final printLines = lines.map((printable) {
        return CiontekPrintLine(
          text: printable,
          bold: printable.contains("**") || printable.contains("CASH"),
          textGray: TextGray.medium,
          type: CiontekPrintLineType.text,
        );
      }).toList();
      printLines.add(CiontekPrintLine.feedPaper(lines: 5));
      Ciontek().printLine(lines: printLines);
      successMessage.value = 'Receipt sent to printer successfully!';
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateAndSharePdf(ReceiptModel receipt) async {
    isGeneratingPdf.value = true;
    errorMessage.value = '';

    try {
      await ReceiptService.sharePdfReceipt(receipt);
      successMessage.value = 'PDF shared successfully!';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  Future<void> savePdfToDevice(ReceiptModel receipt) async {
    isGeneratingPdf.value = true;
    errorMessage.value = '';

    try {
      await ReceiptService.savePdfReceipt(receipt);
      successMessage.value = 'PDF saved to downloads successfully!';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isGeneratingPdf.value = false;
    }
  }

  Future<void> shareAsText(ReceiptModel receipt) async {
    isSharing.value = true;
    errorMessage.value = '';

    try {
      await ReceiptService.shareTextReceipt(receipt);
      successMessage.value = 'Receipt shared as text successfully!';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSharing.value = false;
    }
  }

  Future<void> fetchReceiptByNumber(String receiptNumber) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final receipt = await _repository.getReceiptByNumber(receiptNumber);
      currentReceipt.value = receipt;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRecentReceipts({
    int days = 7,
    String? stationId,
    int limit = 50,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _repository.getRecentReceipts(
        days: days,
        stationId: stationId,
        limit: limit,
      );
      recentReceipts.value = response.receipts;
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  void clearCurrentReceipt() {
    currentReceipt.value = null;
    receiptText.value = '';
    receiptHtml.value = '';
  }

  void clearSuccess() {
    successMessage.value = '';
    printStatus.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }

  /// Refresh receipts data - used for pull-to-refresh
  Future<void> refreshReceipts() async {
    await fetchRecentReceipts();
  }

  // Thermal Printer Management Methods
  Future<bool> connectToBluetoothPrinter(String address) async {
    try {
      return true;
      // return await ThermalPrinterService.connectToBluetoothPrinter(address);
    } catch (e) {
      errorMessage.value = 'Failed to connect to printer: $e';
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableBluetoothPrinters() async {
    try {
      return [];
      // return await ThermalPrinterService.getAvailableBluetoothPrinters();
    } catch (e) {
      errorMessage.value = 'Failed to get available printers: $e';
      return [];
    }
  }

  Future<bool> isPrinterConnected() async {
    try {
      // return await ThermalPrinterService.isPrinterConnected();
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to check printer connection: $e';
      return false;
    }
  }

  Future<bool> disconnectPrinter() async {
    try {
      // return await ThermalPrinterService.disconnectPrinter();
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to disconnect printer: $e';
      return false;
    }
  }

  // QR Code and E-Receipt Methods
  Future<void> generateQrCodeForReceipt(String saleId) async {
    isGeneratingQrCode.value = true;
    errorMessage.value = '';

    try {
      // First get the receipt data
      final receipt = await _repository.getSaleReceipt(saleId);
      currentReceipt.value = receipt;

      // Validate required parameters before generating QR code
      final validationResult = _validateReceiptForKraQr(receipt);
      if (!validationResult.isValid) {
        errorMessage.value = validationResult.errorMessage;
        return;
      }

      // Generate KRA QR data with validated parameters
      final kraPin = receipt.kraPin;
      final bhfId = receipt.sdcId;
      final receiptSignature = KraQrService.generateReceiptSignature(
        receiptNumber: receipt.receiptNumber,
        timestamp: receipt.date,
        totalAmount: receipt.totalAmount.toString(),
        kraPin: kraPin,
      );

      // Create enhanced QR data with KRA information
      final enhancedQrData = {
        'receipt_number': receipt.receiptNumber,
        'organization': receipt.organizationName,
        'station': receipt.stationName,
        'amount': receipt.totalAmount.toString(),
        'date': receipt.date,
        'sale_id': saleId,
        'kra_pin': kraPin,
        'sdc_id': bhfId,
        'receipt_signature': receiptSignature,
        'kra_qr_url': KraQrService.generateKraQrUrl(
          kraPin: kraPin,
          bhfId: bhfId,
          receiptSignature: receiptSignature,
        ),
      };

      qrCodeData.value = enhancedQrData;
      pdfUrl.value = enhancedQrData['kra_qr_url'];
      successMessage.value = 'KRA QR Code generated successfully!';
    } catch (e) {
      if (e is Failure) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isGeneratingQrCode.value = false;
    }
  }

  /// Validates receipt data for KRA QR code generation
  _ValidationResult _validateReceiptForKraQr(ReceiptModel receipt) {
    // Check if receipt number is valid
    if (receipt.receiptNumber.isEmpty) {
      return _ValidationResult(
        isValid: false,
        errorMessage: 'Receipt number is missing. Cannot generate KRA QR code.',
      );
    }

    // Check if KRA PIN is valid (should not be default/empty)
    if (receipt.kraPin.isEmpty || receipt.kraPin == 'A000000000Z') {
      return _ValidationResult(
        isValid: false,
        errorMessage:
            'Valid KRA PIN is required. Please configure KRA PIN in station settings.',
      );
    }

    // Check if BHF ID (SCU ID) is valid
    if (receipt.sdcId.isEmpty || receipt.sdcId == 'KRACU0100000001') {
      return _ValidationResult(
        isValid: false,
        errorMessage:
            'Valid BHF ID (SCU ID) is required. Please configure VSCU device.',
      );
    }

    // Check if receipt date is valid
    if (receipt.date.isEmpty) {
      return _ValidationResult(
        isValid: false,
        errorMessage: 'Receipt date is missing. Cannot generate KRA QR code.',
      );
    }

    // Check if total amount is valid
    if (receipt.totalAmount <= 0) {
      return _ValidationResult(
        isValid: false,
        errorMessage: 'Invalid total amount. Amount must be greater than zero.',
      );
    }

    // Check if organization name is valid
    if (receipt.organizationName.isEmpty) {
      return _ValidationResult(
        isValid: false,
        errorMessage:
            'Organization name is missing. Cannot generate KRA QR code.',
      );
    }

    // Check if station name is valid
    if (receipt.stationName.isEmpty) {
      return _ValidationResult(
        isValid: false,
        errorMessage: 'Station name is missing. Cannot generate KRA QR code.',
      );
    }

    return _ValidationResult(isValid: true);
  }

  void clearQrCodeData() {
    qrCodeData.value = null;
    pdfUrl.value = null;
  }
}

/// Helper class for validation results
class _ValidationResult {
  final bool isValid;
  final String errorMessage;

  _ValidationResult({required this.isValid, this.errorMessage = ''});
}
