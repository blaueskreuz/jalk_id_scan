import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:jalk_app/models/scan_result.dart';
import 'package:jalk_app/services/age_scanner.dart';

class AgeScannerPassport implements AgeScanner {
  @override
  ScanResult? scan(RecognizedText recognizedText) {
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        String currentLine = "";

        if (line.text.contains('CHE')) {
          currentLine = line.text.substring(line.text.indexOf('CHE'));
        }

        if (line.text.contains('D<<')) {
          currentLine = line.text.substring(line.text.indexOf('D<<'));
        }

        if (currentLine.length > 10) {
          String dateOfBirthLine = currentLine.substring(3).substring(0, 6);

          if (RegExp(r'^[0-9]+$').hasMatch(dateOfBirthLine) && !RegExp(r'^[0-9]+$').hasMatch(currentLine[10])) {
            int year = int.parse(dateOfBirthLine[0] + dateOfBirthLine[1]);

            if (year <= 15) {
              year += 2000;
            }
            else {
              year += 1900;
            }

            return ScanResult(day: int.parse(dateOfBirthLine[4] + dateOfBirthLine[5]), month: int.parse(dateOfBirthLine[2] + dateOfBirthLine[3]), year: year, scanType: "Swiss Passport", scannedLine: currentLine);
          }
        }
      }
    }

    return null;
  }
}
