// import 'package:flutter/services.dart';
// import 'package:ciontek_sdk_flutter/ciontek_sdk_flutter.dart';
// import 'package:logger/logger.dart';

import 'package:flutter/services.dart';

class ThermalPrinterService {}

// class Cs30PrinterService {
//   String _platformVersion = 'Unknown';
//   final _ciontekSdkFlutterPlugin = CiontekSdkFlutter();
//   final Logger _logger = Logger();
//
//   Future<void> initPlatformState() async {
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       _platformVersion =
//           await _ciontekSdkFlutterPlugin.getPlatformVersion() ??
//           'Unknown platform version';
//
//       _logger.d("Initialized _ciontekSdkFlutterPlugin");
//
//     } on PlatformException {
//       _platformVersion = 'Failed to get platform version.';
//     }
//   }
//
//   Future<void> connectPrinter() async {
//     String? result;
//     try {
//       _logger.d("Attempting to connect to printer");
//       result = await _ciontekSdkFlutterPlugin.connectPrinter();
//       _logger.d(result);
//
//
//     } on PlatformException catch (e) {
//       result = "Failed to connect printer: '${e.message}'.";
//     }
//     _platformVersion = result ?? 'Unknown connection result';
//   }
//
//   Future<void> printReceipt(String reciept) async {
//     _logger.d("Printig reciept");
//     // Initialize printer
//     await _ciontekSdkFlutterPlugin.printInit();
//
//     _logger.d("Printer initialized");
//
//     // Set font (example values: fontType=1, fontSize=0, fontStyle=0)
//     await _ciontekSdkFlutterPlugin.setPrinterFont(16, 16, 0x33);
//     await _ciontekSdkFlutterPlugin.setPrinterFont(24, 24, 0x00);
//
//     // Set mode (example value: 0)
//     await _ciontekSdkFlutterPlugin.prnSetMode(0);
//
//     // Set gray level (example value: 2)
//     await _ciontekSdkFlutterPlugin.prnSetGray(5);
//
//     // Check printer status before printing
//     int? status = await _ciontekSdkFlutterPlugin.printCheckStatus();
//
//     switch (status) {
//       case 0:
//         await _ciontekSdkFlutterPlugin.prnStr(reciept);
//         await _ciontekSdkFlutterPlugin.prnStart();
//         await _ciontekSdkFlutterPlugin.prnFeedPaper(300);
//         break;
//       case -1:
//         throw ("Printer needs paper.");
//       case -2:
//         throw ("Printer high temperature.");
//       case -3:
//         throw ("Low battery voltage.");
//       default:
//         throw ("Unknown printer error.");
//     }
//   }
// }

// The channel name must match the one defined in your Android code.
// const MethodChannel _channel = MethodChannel(
//   'io.opencrafts.flow_360/ciontek_printer',
// );
//
// /// Prints a receipt using the native Ciontek SDK.
// Future<void> printReceipt(String text) async {
//   try {
//     final bool? isSuccess = await _channel.invokeMethod('printReceipt', {
//       'text': text,
//     });
//     if (isSuccess != true) {
//       throw PlatformException(
//         code: 'PRINT_FAILED',
//         message: 'Printing failed for an unknown reason.',
//       );
//     }
//   } on PlatformException catch (e) {
//     throw Exception('Printer Error: ${e.message}');
//   }
// }
