import 'package:crypto/crypto.dart';
import 'dart:convert';

class KraQrService {
  /// Generates a KRA-compliant QR code URL for receipts
  /// 
  /// The URL structure follows KRA eTIMS requirements:
  /// https://etims.kra.go.ke/common/link/etims/receipt/indexEtimsReceptData?{KRA-PIN+BHF-ID+RcpSignature}
  static String generateKraQrUrl({
    required String kraPin,
    required String bhfId,
    required String receiptSignature,
  }) {
    // Validate required parameters
    if (kraPin.isEmpty) {
      throw ArgumentError('KRA PIN cannot be empty');
    }
    if (bhfId.isEmpty) {
      throw ArgumentError('BHF ID cannot be empty');
    }
    if (receiptSignature.isEmpty) {
      throw ArgumentError('Receipt signature cannot be empty');
    }
    
    // Validate KRA PIN format (should be alphanumeric and not default)
    if (kraPin == 'A000000000Z' || kraPin.length < 10) {
      throw ArgumentError('Invalid KRA PIN format');
    }
    
    // Validate BHF ID format (should not be default)
    if (bhfId == 'KRACU0100000001' || bhfId.length < 10) {
      throw ArgumentError('Invalid BHF ID format');
    }
    
    // Combine the three components as specified by KRA
    final combinedData = '$kraPin$bhfId$receiptSignature';
    
    // Create the KRA eTIMS URL
    final kraUrl = 'https://etims.kra.go.ke/common/link/etims/receipt/indexEtimsReceptData?$combinedData';
    
    return kraUrl;
  }

  /// Generates a receipt signature for KRA compliance
  /// 
  /// This creates a unique signature based on receipt data
  static String generateReceiptSignature({
    required String receiptNumber,
    required String timestamp,
    required String totalAmount,
    required String kraPin,
  }) {
    // Validate required parameters
    if (receiptNumber.isEmpty) {
      throw ArgumentError('Receipt number cannot be empty');
    }
    if (timestamp.isEmpty) {
      throw ArgumentError('Timestamp cannot be empty');
    }
    if (totalAmount.isEmpty) {
      throw ArgumentError('Total amount cannot be empty');
    }
    if (kraPin.isEmpty) {
      throw ArgumentError('KRA PIN cannot be empty');
    }
    
    // Validate total amount is numeric and positive
    final amount = double.tryParse(totalAmount);
    if (amount == null || amount <= 0) {
      throw ArgumentError('Total amount must be a positive number');
    }
    
    // Create a unique signature based on receipt data
    final signatureData = '$receiptNumber$timestamp$totalAmount$kraPin';
    
    // Generate SHA-256 hash
    final bytes = utf8.encode(signatureData);
    final digest = sha256.convert(bytes);
    
    // Return first 16 characters of the hash as signature
    return digest.toString().substring(0, 16).toUpperCase();
  }

  /// Validates if a QR URL is properly formatted for KRA
  static bool isValidKraQrUrl(String url) {
    try {
      final uri = Uri.parse(url);
      
      // Check if it's a KRA eTIMS URL
      if (uri.host != 'etims.kra.go.ke') {
        return false;
      }
      
      // Check if the path is correct
      if (uri.path != '/common/link/etims/receipt/indexEtimsReceptData') {
        return false;
      }
      
      // Check if query parameters exist
      if (uri.query.isEmpty) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Extracts components from a KRA QR URL
  static Map<String, String>? extractKraQrComponents(String url) {
    try {
      if (!isValidKraQrUrl(url)) {
        return null;
      }
      
      final uri = Uri.parse(url);
      final query = uri.query;
      
      // The query should contain the combined data: KRA-PIN+BHF-ID+RcpSignature
      // We need to know the lengths to split properly
      // For now, return the raw query data
      return {
        'combined_data': query,
        'url': url,
      };
    } catch (e) {
      return null;
    }
  }
}
