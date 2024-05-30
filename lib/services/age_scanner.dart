import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:jalk_app/models/scan_result.dart';

abstract class AgeScanner {
  ScanResult? scan(RecognizedText recognizedText);
}
