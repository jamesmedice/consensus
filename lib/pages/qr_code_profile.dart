import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text.dart';
import '../widgets/qr_code.dart';
import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../utils/date_utils.dart';
import '../utils/string_utils.dart';
import '../l18n.dart';
import '../constants/aes.dart';

class QRCodeProfile extends StatefulWidget {
  final SharedPreferences _prefs;
  final String userEmail;

  QRCodeProfile(this._prefs, this.userEmail);

  @override
  _QRCodeProfileState createState() => _QRCodeProfileState();
}

class _QRCodeProfileState extends State<QRCodeProfile> {
  final Logger _logger = Logger();

  late AuthService _authService;

  String? userEmail;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget._prefs);
    _setUpQrCodeData();
  }

  Future<void> _setUpQrCodeData() async {
    try {
      User? user = await _authService.getCurrentUser();

      if (user != null) {
        setState(() {
          _logger.i(user);
          userEmail = user.email;
        });
      }
    } catch (e) {
      _logger.e("Error fetching: $e");
    }
  }

  String format([dynamic values]) {
    return values.map((value) => value.toString()).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    final encrypted = EncryptionUtils.encryptCode(userEmail!);
    _logger.i(encrypted);

    final decrypted = EncryptionUtils.decryptCode(encrypted);
    _logger.i(decrypted);

    String rules = labels?.translate('qrcode.rules') ?? 'Without Rules We Live With The Animals.';

    Map<String, dynamic> data = {AppConstants.appkey: encrypted, AppConstants.email: userEmail, AppConstants.rules: rules, AppConstants.date: StandardDateUtils.getCurrentDate()};

    String qrData = HelperStringUtils.jsonEncode(data);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Expanded(child: Center(child: Container(child: QRCode(qrSize: 150, qrData: qrData, width: 150, height: 150))))],
        ),
      ),
    );
  }
}
