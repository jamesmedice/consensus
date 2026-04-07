import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_button.dart';
import '../widgets/qr_code.dart';
import '../widgets/input_field.dart';
import '../constants/app_colors.dart';
import '../services/email_sender.dart';
import 'home.dart';
import '../l18n.dart';

class QRCodeConsent extends StatefulWidget {
  final SharedPreferences _prefs;
  final String scannedData;
  final String email;
  final String userEmail;

  QRCodeConsent(this._prefs, this.scannedData, this.email, this.userEmail);

  @override
  _QRCodeConsentState createState() => _QRCodeConsentState();
}

class _QRCodeConsentState extends State<QRCodeConsent> {
  final TextEditingController _fromEmailController = TextEditingController();
  final TextEditingController _toEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    _fromEmailController.text = widget.userEmail;
    _toEmailController.text = widget.email;

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
            DrawerHeader(decoration: BoxDecoration(color: AppColors.drawerHeaderBackground), child: CustomText(text: labels?.translate('app.name') ?? 'Consensus', color: Colors.white, fontSize: 24)),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientScannerStart, AppColors.gradientScannerEnd])),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InputField(controller: _fromEmailController, label: labels?.translate('from.email') ?? 'From Email', readOnly: true),
            SizedBox(height: 10.0),

            InputField(controller: _toEmailController, label: labels?.translate('to.email') ?? 'To Email', readOnly: true),
            SizedBox(height: 10.0),

            TextFormField(
              minLines: 8,
              maxLines: 14,
              keyboardType: TextInputType.multiline,
              initialValue: widget.scannedData,
              readOnly: true,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.outlineInputBorder)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.outlineInputBorderFocus)),
                labelText: labels?.translate('content.rule') ?? 'Consent Data',
                labelStyle: TextStyle(color: AppColors.appBodyText),
              ),
              style: TextStyle(color: AppColors.appBodyText),
            ),
            SizedBox(height: 10),

            //Expanded(child: Center(child: Container(child: QRCode(qrSize: 150, qrData: widget.scannedData, width: 150, height: 150)))),
            //SizedBox(height: 20.0),
            CustomButton(
              text: labels?.translate('send.email') ?? 'Send Email',
              onPressed: () async {
                await sendConsensusEmail(_toEmailController.text, _fromEmailController.text, widget.scannedData, labels?.translate('email.subject') ?? 'Consensus');

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(labels?.translate('email.success') ?? "Email sent successfully"), duration: Duration(seconds: 1)));

                await Future.delayed(Duration(seconds: 1));

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomePage(widget._prefs, widget.userEmail)), (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
