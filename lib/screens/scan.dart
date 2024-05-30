import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:jalk_app/models/scan_result.dart';
import 'package:jalk_app/shared/constants.dart';
import 'package:jalk_app/widgets/jalk_scanner.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  ScanResult? scanResult;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setScanResult(ScanResult newScanResult) {
    setState(() {
      scanResult = newScanResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (scanResult != null) {
      if (scanResult!.getAge() > 0) {
        Color bgColor = jalkColorRed;

        if (scanResult!.getAge() >= 18) {
          bgColor = jalkColorGreen;
        }
        else if (scanResult!.getAge() >= 16) {
          bgColor = jalkColorYellow;
        }

        return Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      context.tr('screens.scan.years', args: [scanResult!.getAge().toString()]),
                      style: const TextStyle(
                        fontSize: jalkAgeResultFontSize,
                      )
                  ),
                  const SizedBox(height: jalkAgeResultMargin),
                  Text(
                    context.tr('screens.scan.date_of_birth', args: [scanResult!.getFormattedDateOfBirth()]),
                  ),
                  if (kDebugMode)
                    Text(scanResult!.scanType),
                  if (kDebugMode)
                    Text(scanResult!.scannedLine),
                  const SizedBox(height: jalkAgeResultMargin),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(jalkColorBlue),
                      foregroundColor: MaterialStatePropertyAll(jalkColorWhite),
                    ),
                    onPressed: () {
                      setState(() {
                        scanResult = null;
                      });
                    },
                    child: Text(context.tr('screens.scan.scan_again')),
                  )
                ]
            ),
          ),
        );
      }
    }

    return JalkScanner(setScanResult: setScanResult);
  }
}
