import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:mrz_parser/mrz_parser.dart';

import 'package:jalk_app/models/scan_result.dart';
import 'package:jalk_app/services/age_scanner.dart';

class AgeScannerMRZ implements AgeScanner {
  @override
  ScanResult? scan(RecognizedText recognizedText) {
    for (TextBlock block in recognizedText.blocks) {
      final mrzString = block.text.replaceAll(' ', '');
      final mrzLines = mrzString.split('\n').where((s) => s.isNotEmpty).toList();
      final mrzResult = MRZParser.tryParse(mrzLines);

      if (mrzResult != null) {
        return ScanResult(day: mrzResult.birthDate.day, month: mrzResult.birthDate.month, year: mrzResult.birthDate.year, scanType: 'MRZ', scannedLine: mrzString);
      }
    }

    return null;
  }
}
