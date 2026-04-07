import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../l18n.dart';
import 'authentication_wrapper.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final SharedPreferences _prefs;

  const TermsAndConditionsScreen(this._prefs);

  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late bool _termsAccepted;
  bool showButton = false;

  @override
  void initState() {
    super.initState();
    _termsAccepted = widget._prefs.getBool('termsAccepted') ?? false;
  }

  Future<void> _acceptTerms() async {
    setState(() {
      _termsAccepted = true;
    });
    await widget._prefs.setBool('termsAccepted', true);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AuthenticationWrapper(widget._prefs)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: CustomText(
          text: labels?.translate('app.name') ?? 'Consent',
          color: AppColors.appBarText,
          fontSize: 16,
        ),
        leading: IconButton(
          icon: const Icon(Icons.handshake_sharp),
          onPressed: () {},
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Scrollbar(
              child: TextFormField(
                minLines: 8,
                maxLines: 18,
                keyboardType: TextInputType.multiline,
                initialValue: labels?.translate('app.terms.text') ?? '',
                readOnly: true,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 2, 14, 128),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 2, 9, 115),
                    ),
                  ),
                  labelText: labels?.translate('app.terms.title') ??
                      'Privacy and Consent Terms',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 1, 10, 64)),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 2, 10, 58)),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                  value: showButton,
                  onChanged: (value) {
                    setState(() {
                      showButton = value!;
                    });
                  },
                ),
                CustomText(
                  text: labels?.translate('qrcode.terms.cond') ??
                      'I agree to the Terms and Conditions.',
                  fontSize: 10.0,
                ),
              ],
            ),
            AnimatedOpacity(
              opacity: showButton ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: SizedBox(
                width: 250.0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    onPressed: _acceptTerms,
                    text: labels?.translate('app.terms.btn') ?? 'ACCEPT',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
