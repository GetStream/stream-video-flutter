import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({
    super.key,
    this.title = 'Scan Call QR code',
  });

  final String title;

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();

  static Future<String> scan(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<String>(builder: (_) => const QrCodeScanner()),
    );
    return result!;
  }
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  late MobileScannerController controller;
  bool _foundBarcode = false;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    final barcode = barcodes.barcodes.firstOrNull?.displayValue;
    if (barcode != null && mounted && !_foundBarcode) {
      _foundBarcode = true;
      Navigator.pop(context, barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final streamVideoTheme = StreamVideoTheme.of(context);
    final textTheme = streamVideoTheme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: textTheme.title3.apply(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: _handleBarcode,
      ),
    );
  }
}
