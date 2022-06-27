library flutter_card_scanner;

import 'package:flutter/services.dart';

class ScanCardPlatform {
  static const _channel = MethodChannel('com.beepul/scan_scan');
  static bool _isOpenedScanCard = false;

  static Future<ScanCardResult?> scanCard() async {
    try {
      _isOpenedScanCard = true;
      final result = await _channel.invokeMethod('open_scan_card');
      _isOpenedScanCard = false;
      final scanResult = ScanCardResult(
          cardNumber: result['card_number'], expiryMonth: result['expiry_month'], expiryYear: result['expiry_year']);
      return scanResult;
    } on PlatformException {
      return null;
    }
  }

  static bool get isOpenedScanCard => _isOpenedScanCard;
}

class ScanCardResult {
  final String? cardNumber;
  final String? expiryMonth;
  final String? expiryYear;

  ScanCardResult({required this.cardNumber, required this.expiryMonth, required this.expiryYear});
}
