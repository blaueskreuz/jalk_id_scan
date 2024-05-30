import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'package:jalk_app/models/scan_result.dart';

class JalkQRAgeScanner {
  ScanResult? scan(List<Barcode> barcodes) {
    for (Barcode barcode in barcodes) {
      final String scannedText = barcode.rawValue ?? '';
      final List<String> scannedTextList = scannedText.split(';');

      if (scannedTextList.length > 2) {
        String scannedQrText = scannedTextList[2];
        List<String> dateOfBirthList = scannedQrText.split('.');

        if (scannedTextList.length > 2) {
          return ScanResult(day: int.parse(dateOfBirthList[0]), month: int.parse(dateOfBirthList[1]), year: int.parse(dateOfBirthList[2]), scanType: 'QR', scannedLine: scannedQrText);
        }
      }
    }

    return null;
  }
}
