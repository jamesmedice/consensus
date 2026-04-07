import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/input_field.dart';
import 'qr_code_consent.dart';
import '../utils/date_utils.dart';
import '../utils/string_utils.dart';
import '../constants/app_constants.dart';
import '../constants/aes.dart';
import '../l18n.dart';

class QRScannedScreen extends StatefulWidget {
  final SharedPreferences _prefs;
  final String scannedData;
  final String userEmail;

  QRScannedScreen(this._prefs, this.scannedData, this.userEmail);

  @override
  _QRScannedScreenState createState() => _QRScannedScreenState();
}

class _QRScannedScreenState extends State<QRScannedScreen> {
  final TextEditingController _fromEmailController = TextEditingController();
  final TextEditingController _toEmailController = TextEditingController();

  bool hasValidData = false;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
  }

  String processScannedData(String scannedData, String terms, String presonalData, String consentDate, String errorCode) {
    try {
      Map<String, dynamic> qrCodeData = HelperStringUtils.jsonDecode(scannedData);

      String emailSender = qrCodeData[AppConstants.email];
      _toEmailController.text = emailSender;
      _fromEmailController.text = widget.userEmail;

      String encryptedBase64 = qrCodeData[AppConstants.appkey];
      EncryptionUtils.decryptCode(encryptedBase64);
      qrCodeData.remove(AppConstants.appkey);

      String qrCodeFormat = HelperStringUtils.formatMapToString(qrCodeData);

      setState(() {
        hasValidData = true;
      });

      return HelperStringUtils.format([terms, presonalData, qrCodeFormat, consentDate]);
    } catch (e) {
      return errorCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    String terms = labels?.translate('qrcode.terms') ?? '';
    String presonalData = labels?.translate('person.qrcode') ?? '';
    String consentLabel = labels?.translate('consent.date') ?? '';
    String consentDate = consentLabel + StandardDateUtils.getCurrentDate();

    String errorCode = labels?.translate('invalid.qrcode') ?? '';
    String qrData = processScannedData(widget.scannedData, terms, presonalData, consentDate, errorCode);

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
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientScannerStart, AppColors.gradientScannerEnd])),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              initialValue: qrData,
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
            SizedBox(height: 20),
            if (hasValidData)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                    value: showButton,
                    onChanged: (value) {
                      setState(() {
                        showButton = value!;
                      });
                    },
                  ),
                  CustomText(text: labels?.translate('qrcode.terms.cond') ?? 'I agree to the Terms and Conditions.', fontSize: 10.0, color: AppColors.customText),
                ],
              ),
            if (showButton)
              CustomButton(
                text: labels?.translate('qrcode.generate') ?? '',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeConsent(widget._prefs, qrData, _toEmailController.text, _fromEmailController.text)));
                },
              ),
          ],
        ),
      ),
    );
  }
}
