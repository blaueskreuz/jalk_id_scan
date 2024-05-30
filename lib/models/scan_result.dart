import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';

class ScanResult {
  int day;
  int month;
  int year;
  String scanType;
  String scannedLine;

  ScanResult({
    required this.day,
    required this.month,
    required this.year,
    required this.scanType,
    required this.scannedLine,
  });

  int getAge() {
    DateTime dateOfBirth = DateTime(year, month, day);
    DateDuration scannedAge = AgeCalculator.age(dateOfBirth);

    return scannedAge.years;
  }

  String getFormattedDateOfBirth() {
    DateTime dateOfBirth = DateTime(year, month, day);
    final f = DateFormat('dd.MM.yyyy');

    return f.format(dateOfBirth);
  }
}
