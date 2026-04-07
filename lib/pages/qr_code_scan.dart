import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_code_scanned.dart';
import 'dart:developer';
import 'dart:io';
import '../constants/app_colors.dart';
import '../l18n.dart';

class QRScannerScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final String userEmail;

  const QRScannerScreen(this.prefs, this.userEmail, {super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();

  bool _navigated = false;
  String? result;

  @override
  void reassemble() {
    super.reassemble();

    // equivalent to pause/resume camera
    if (Platform.isAndroid) {
      _scannerController.stop();
      _scannerController.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientScannerStart, AppColors.gradientScannerEnd])),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // TOP ICON (same as your original UI)
            const Expanded(flex: 1, child: Center(child: Icon(Icons.handshake_outlined))),

            const SizedBox(height: 20),

            // SCANNER
            Expanded(flex: 4, child: _buildScanner(context)),

            const SizedBox(height: 20),

            // BOTTOM ICON
            Expanded(flex: 1, child: Center(child: result == null ? const Icon(Icons.handshake_sharp) : const SizedBox.shrink())),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScanner(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        MobileScanner(
          controller: _scannerController,
          onDetect: (capture) {
            final barcodes = capture.barcodes;

            if (barcodes.isEmpty) return;

            final code = barcodes.first.rawValue;

            if (code == null || _navigated) return;

            _navigated = true;

            log("QR scanned: $code");

            setState(() {
              result = code;
            });

            Navigator.push(context, MaterialPageRoute(builder: (context) => QRScannedScreen(widget.prefs, code, widget.userEmail))).then((_) {
              _navigated = false;
            });
          },
        ),

        // 🔥 Overlay (replacement for QrScannerOverlayShape)
        Container(width: scanArea, height: scanArea, decoration: BoxDecoration(border: Border.all(color: AppColors.appBarBackground, width: 4), borderRadius: BorderRadius.circular(10))),

        // optional corner fade effect (closer to old UI feel)
        Positioned.fill(child: IgnorePointer(child: Container(decoration: BoxDecoration(gradient: RadialGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.2)], radius: 1.2))))),
      ],
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }
}
