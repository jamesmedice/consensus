import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_list_tile.dart';
import '../widgets/custom_text.dart';
import '../l18n.dart';
import '../locator.dart';
import '../services/camera_service.dart';
import '../constants/app_colors.dart';
import 'login.dart';
import 'terms_conditions.dart';
import 'qr_code_profile.dart';
import 'qr_code_scan.dart';

class HomePage extends StatelessWidget {
  final SharedPreferences _prefs;
  final String userEmail;

  HomePage(this._prefs, this.userEmail);

  final CameraService cameraService = locator<CameraService>();
  final FirebaseAuth _authService = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(this._prefs)));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    bool termsAccepted = _prefs.getBool('termsAccepted') ?? false;
    if (!termsAccepted) {
      return TermsAndConditionsScreen(_prefs);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: CustomText(text: labels?.translate('app.name') ?? 'Consent', color: Colors.white),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  width: double.infinity,
                  color: AppColors.drawerHeaderBackground,
                  child: Padding(padding: const EdgeInsets.all(16.0), child: IconButton(color: Color.fromARGB(255, 255, 255, 255), icon: const Icon(Icons.handshake_rounded), onPressed: () {})),
                ),
                CustomListTile(
                  title: labels?.translate('qrcode.menu') ?? 'Qr Code',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => QRCodeProfile(this._prefs, userEmail)));
                  },
                ),
                CustomListTile(
                  title: labels?.translate('qrcode.scan') ?? 'Scanner',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => QRScannerScreen(this._prefs, userEmail)));
                  },
                ),
              ],
            ),
            CustomListTile(title: labels?.translate('profile.logout') ?? 'Logout', onTap: () => _signOut(context)),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientStart, AppColors.gradientEnd])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child: Align(alignment: Alignment.center, child: CustomText(text: '${labels?.translate('welcome_screen.title')}' + userEmail!, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 200.0, child: Align(alignment: Alignment.center, child: Icon(Icons.handshake_sharp, color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
