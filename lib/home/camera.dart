import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qlert/alert/alertPage.dart';

class CameraApp extends StatefulWidget {

  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {

  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      // fit: BoxFit.contain,
      controller: cameraController,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        for (final barcode in barcodes) {
          RegExp regExp = RegExp(r'https:\/\/www\.qlert\.in\/[a-zA-Z0-9]{10}');

          if (regExp.hasMatch(barcode.rawValue!)) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AlertPage(id: barcode.rawValue!.substring(barcode.rawValue!.length - 10))),
            );
            cameraController.dispose();
            print('URL matches the pattern');
          } else {
            print('URL does not match the pattern');
          }
        }
      },
    );
  }
}