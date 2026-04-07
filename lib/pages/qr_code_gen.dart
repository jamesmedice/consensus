import 'package:flutter/material.dart';
import '../widgets/qr_code.dart';
import '../widgets/custom_text.dart';
import '../constants/app_colors.dart';
import '../l18n.dart';

class QRCodeDataScreen extends StatelessWidget {
  final String qrData;

  QRCodeDataScreen(this.qrData);

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(decoration: BoxDecoration(color: AppColors.drawerHeaderBackground), child: CustomText(text: labels?.translate('app.name') ?? 'Consent', color: Colors.white, fontSize: 24)),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientQRCodeStart, AppColors.gradientQRCodeEnd])),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text('QR Code Data', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(width: 200, height: 200, child: QRCode(qrSize: 200, qrData: qrData)),
              SizedBox(height: 20),
              Text('Data: $qrData', style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
