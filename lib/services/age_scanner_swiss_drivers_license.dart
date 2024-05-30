import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:jalk_app/models/scan_result.dart';
import 'package:jalk_app/services/age_scanner.dart';

class AgeScannerSwissDriversLicense implements AgeScanner {
  @override
  ScanResult? scan(RecognizedText recognizedText) {
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.length > 12) {
          String currentLine = line.text;

          if (currentLine.startsWith('FACHE')) {
            var parts = currentLine.split('<');

            for (var i = parts.length - 1; i >= 0; i--) {
              if (parts[i].length == 6 && RegExp(r'^[0-9]+$').hasMatch(parts[i])) {
                String dateOfBirthLine = parts[i];
                int year = int.parse(dateOfBirthLine[0] + dateOfBirthLine[1]);

                if (year <= 15) {
                  year += 2000;
                }
                else {
                  year += 1900;
                }

                return ScanResult(day: int.parse(dateOfBirthLine[4] + dateOfBirthLine[5]), month: int.parse(dateOfBirthLine[2] + dateOfBirthLine[3]), year: year, scanType: 'Swiss Drivers License', scannedLine: currentLine);
              }
            }
          }
        }
      }
    }

    return null;
  }
}
