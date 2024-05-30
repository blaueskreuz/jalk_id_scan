import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'package:jalk_app/models/scan_result.dart';
import 'package:jalk_app/services/age_scanner.dart';
import 'package:jalk_app/services/age_scanner_mrz.dart';
import 'package:jalk_app/services/age_scanner_passport.dart';
import 'package:jalk_app/services/age_scanner_swiss_drivers_license.dart';
import 'package:jalk_app/services/age_scanner_swiss_id.dart';
import 'package:jalk_app/services/jalk_qr_age_scanner.dart';
import 'package:jalk_app/shared/constants.dart';

class JalkScanner extends StatefulWidget {
  final Function setScanResult;

  const JalkScanner({super.key, required this.setScanResult});

  @override
  State<JalkScanner> createState() => _JalkScannerState();
}

class _JalkScannerState extends State<JalkScanner> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  final _textRecognizer = TextRecognizer();
  final _barcodeScanner = BarcodeScanner(formats: const [BarcodeFormat.qrCode]);
  IconData _fabIcon = Icons.flashlight_on;
  bool _torch = false;
  bool _isBusy = false;

  Future _processCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize;

    imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final camera = _cameras[0];
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (imageRotation == null) return;

    final inputImageFormat =
    InputImageFormatValue.fromRawValue(image.format.raw as int);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImageMetadata(
          bytesPerRow: plane.bytesPerRow,
          size: Size(
            plane.width?.toDouble() ?? 0,
            plane.height?.toDouble() ?? 0,
          ),
          rotation: imageRotation,
          format: inputImageFormat,
        );
      },
    ).toList();

    final inputImageData = InputImageMetadata(
      size: imageSize,
      format: inputImageFormat,
      bytesPerRow: planeData.first.bytesPerRow,
      rotation: InputImageRotation.rotation90deg,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageData,
    );

    Future<void> processImage(InputImage inputImage, Size imageSiz) async {
      if (_isBusy) {
        return;
      }

      _isBusy = true;

      // Always try to detect a QR Code first, it's the most efficient scan.
      final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);
      ScanResult? scanResult = JalkQRAgeScanner().scan(barcodes);

      if (scanResult != null) {
        _controller?.setFlashMode(FlashMode.off);
        _fabIcon = Icons.flashlight_on;
        _torch = false;
        widget.setScanResult(scanResult);
      }
      else {
        // QR detection was not successful, try OCR detection.
        final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

        List<AgeScanner> scanners = [AgeScannerSwissID(), AgeScannerSwissDriversLicense(), AgeScannerPassport(), AgeScannerMRZ()];

        for (final scanner in scanners) {
          ScanResult? scanResult = scanner.scan(recognizedText);

          if (scanResult != null) {
            _controller?.setFlashMode(FlashMode.off);
            _fabIcon = Icons.flashlight_on;
            _torch = false;
            widget.setScanResult(scanResult);
            break;
          }
        }
      }

      _isBusy = false;
      await _textRecognizer.close();

      if (mounted) {
        setState(() {});
      }
    }

    processImage(
      inputImage,
      imageSize,
    );
  }

  Future _startCamera() async {
    _cameras = await availableCameras();

    final camera = _cameras[0];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller?.initialize();
      await _controller?.lockCaptureOrientation();

      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          break;
        default:
          break;
    }
  }

  Future _stopCamera() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    await _barcodeScanner.close();
    _controller = null;
  }

  @override
  void initState() {
    super.initState();
    _startCamera();
  }

  @override
  void dispose() {
    _textRecognizer.close();
    _stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }

    final mediaSize = MediaQuery.of(context).size;
    final scale = 1 / (_controller!.value.aspectRatio * mediaSize.aspectRatio);

    if (_torch) {
      _controller?.setFlashMode(FlashMode.torch);
    }

    return Scaffold(
      backgroundColor: jalkColorBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRect(
              clipper: _MediaSizeClipper(mediaSize),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: CameraPreview(_controller!),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          if (mounted) {
            setState(() {
              if (!_torch) {
                _controller?.setFlashMode(FlashMode.torch);
                _fabIcon = Icons.flashlight_off;
                _torch = true;
              }
              else {
                _controller?.setFlashMode(FlashMode.off);
                _fabIcon = Icons.flashlight_on;
                _torch = false;
              }
            });
          }
        },
        child: Icon(_fabIcon),
      ),
    );
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }
  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
