import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:jalk_app/models/scan_result.dart';
import 'package:jalk_app/services/age_scanner.dart';

class AgeScannerSwissID implements AgeScanner {
  @override
  ScanResult? scan(RecognizedText recognizedText) {
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.length > 7) {
          String currentLine = line.text.substring(0, 7);

          if (RegExp(r'^[0-9]+$').hasMatch(currentLine) && !RegExp(r'^[0-9]+$').hasMatch(line.text[7])) {
            int dateOfBirthSum =
                int.parse(currentLine[0]) * 7
                    + int.parse(currentLine[1]) * 3
                    + int.parse(currentLine[2]) * 1
                    + int.parse(currentLine[3]) * 7
                    + int.parse(currentLine[4]) * 3
                    + int.parse(currentLine[5]) * 1;
            int calculatedTestDigit = dateOfBirthSum % 10;

            if (calculatedTestDigit == int.parse(currentLine[6])) {
              // Valid test digit and date of birth.
              int year = int.parse(currentLine[0] + currentLine[1]);

              if (year <= 15) {
                year += 2000;
              }
              else {
                year += 1900;
              }

              return ScanResult(day: int.parse(currentLine[4] + currentLine[5]), month: int.parse(currentLine[2] + currentLine[3]), year: year, scanType: 'Swiss ID', scannedLine: currentLine);
            }
          }
        }
      }
    }

    return null;
  }
}
