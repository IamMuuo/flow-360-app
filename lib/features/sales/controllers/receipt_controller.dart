import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:flow_360/core/failure.dart';
import 'package:flow_360/features/sales/repository/receipt_repository.dart';
import 'package:flow_360/features/sales/models/receipt_model.dart';
import 'package:flow_360/features/sales/services/receipt_service.dart';
import 'package:flow_360/features/sales/services/thermal_printer_service.dart';

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
      print('ReceiptController: Receipt fetched successfully: ${receipt.receiptNumber}');
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

  Future<void> printReceipt({
    required String saleId,
    required String printerType,
  }) async {
    isLoading.value = true;
    errorMessage.value = '';
    printStatus.value = '';
    
    try {
      // First get the receipt data
      final receipt = await _repository.getSaleReceipt(saleId);
      
      // Use actual thermal printing for thermal printers
      if (printerType.startsWith('thermal')) {
        final success = await ThermalPrinterService.printReceipt(receipt, printerType: printerType);
        
        if (success) {
          printStatus.value = 'Receipt printed successfully on $printerType printer';
          successMessage.value = 'Receipt printed successfully!';
        } else {
          errorMessage.value = 'Failed to print receipt. Please check printer connection.';
        }
      } else {
        // For PDF and other formats, use the backend
        final response = await _repository.printSaleReceipt(
          saleId: saleId,
          printerType: printerType,
        );
        
        if (response.success) {
          printStatus.value = response.message;
          successMessage.value = 'Receipt sent to printer successfully!';
        } else {
          errorMessage.value = response.message;
        }
      }
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
      return await ThermalPrinterService.connectToBluetoothPrinter(address);
    } catch (e) {
      errorMessage.value = 'Failed to connect to printer: $e';
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableBluetoothPrinters() async {
    try {
      return await ThermalPrinterService.getAvailableBluetoothPrinters();
    } catch (e) {
      errorMessage.value = 'Failed to get available printers: $e';
      return [];
    }
  }

  Future<bool> isPrinterConnected() async {
    try {
      return await ThermalPrinterService.isPrinterConnected();
    } catch (e) {
      errorMessage.value = 'Failed to check printer connection: $e';
      return false;
    }
  }

  Future<bool> disconnectPrinter() async {
    try {
      return await ThermalPrinterService.disconnectPrinter();
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
      final response = await _repository.getSaleReceiptPdfUrl(saleId);
      qrCodeData.value = response.qrData;
      pdfUrl.value = response.qrScanUrl;
      successMessage.value = 'QR Code generated successfully!';
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

  void clearQrCodeData() {
    qrCodeData.value = null;
    pdfUrl.value = null;
  }
}
