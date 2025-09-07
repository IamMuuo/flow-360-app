import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flow_360/features/sales/services/kra_qr_service.dart';

class KraQrCodeWidget extends StatelessWidget {
  final String kraPin;
  final String bhfId;
  final String receiptSignature;
  final double size;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const KraQrCodeWidget({
    super.key,
    required this.kraPin,
    required this.bhfId,
    required this.receiptSignature,
    this.size = 120.0,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final qrUrl = KraQrService.generateKraQrUrl(
      kraPin: kraPin,
      bhfId: bhfId,
      receiptSignature: receiptSignature,
    );

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // QR Code
          QrImageView(
            data: qrUrl,
            version: QrVersions.auto,
            size: size,
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: foregroundColor ?? Colors.black,
            ),
            backgroundColor: backgroundColor ?? Colors.white,
            errorStateBuilder: (context, error) {
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.grey[600],
                      size: 24.0,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'QR Error',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8.0),
          
          // KRA Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              'KRA eTIMS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A compact QR code widget for receipts
class CompactKraQrCodeWidget extends StatelessWidget {
  final String kraPin;
  final String bhfId;
  final String receiptSignature;
  final double size;

  const CompactKraQrCodeWidget({
    super.key,
    required this.kraPin,
    required this.bhfId,
    required this.receiptSignature,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    final qrUrl = KraQrService.generateKraQrUrl(
      kraPin: kraPin,
      bhfId: bhfId,
      receiptSignature: receiptSignature,
    );

    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 0.5,
        ),
      ),
      child: QrImageView(
        data: qrUrl,
        version: QrVersions.auto,
        size: size,
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        errorStateBuilder: (context, error) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Icon(
              Icons.qr_code,
              color: Colors.grey[600],
              size: size * 0.5,
            ),
          );
        },
      ),
    );
  }
}
