import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../exceptions/authentication_exceptions.dart';
import '../widgets/input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_button_future_style.dart';
import '../widgets/custom_dialog.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';
import 'forgot_password.dart';
import 'Register.dart';
import 'home.dart';
import '../l18n.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences _prefs;

  LoginScreen(this._prefs);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _registrationStatus = '';

  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(widget._prefs);
  }

  Future<void> _register() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  Future<void> _forgot() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
  }

  Future<void> _signIn(BuildContext context, AppLocalizations? labels) async {
    try {
      User? user = await _authService.signInWithEmailAndPassword(_emailController.text.trim(), _passwordController.text.trim());

      if (user == null) {
        throw AuthenticationException("Authentication failed: User is null.");
      }
      _navigateToHomeScreen(context, user.email ?? '');
    } catch (e) {
      String errorMessage = labels?.translate('login.failure') ?? 'Login failed. Please check your credentials.';
      String button = labels?.translate('dialog.button') ?? 'OK';
      String title = labels?.translate('dialog.title') ?? 'Error';
      _showErrorMessage(context, title, button, errorMessage);
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      User? user = await _authService.loginWithGoogle();

      if (user == null) {
        throw AuthenticationException("Authentication failed: User is null.");
      }
      _navigateToHomeScreen(context, user.email!);
    } catch (e) {}
  }

  void _showErrorMessage(BuildContext context, String title, String button, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogStyle.buildAlertDialog(
          context: context,
          title: title,
          buttonText: button,
          content: errorMessage,
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _navigateToHomeScreen(BuildContext context, String userEmail) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(widget._prefs, userEmail)));
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      Navigator.pop(context);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        title: CustomText(text: labels?.translate('app.name') ?? 'Consent', color: AppColors.appBarText, fontSize: 16),
        leading: IconButton(icon: const Icon(Icons.handshake_sharp), onPressed: () {}),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientStart, AppColors.gradientEnd])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 250.0, child: Align(alignment: Alignment.topLeft, child: CustomText(text: labels?.translate('login.register.phrase') ?? 'Don\'t have an account?'))),
              SizedBox(
                width: 250.0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _register,
                    child: Text(labels?.translate('login.register') ?? 'Register', style: TextStyle(color: AppColors.homeLink, decoration: TextDecoration.underline)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              InputField(controller: _emailController, label: labels?.translate('login.email') ?? 'Email'),
              SizedBox(height: 10),
              InputField(controller: _passwordController, label: labels?.translate('login.psw') ?? 'Password', obscureText: true),
              SizedBox(
                width: 250.0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgot,
                    child: Text(labels?.translate('login.forgot') ?? 'Forgot Password', style: TextStyle(color: AppColors.homeLink, decoration: TextDecoration.underline)),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(width: 250.0, child: CustomButton(onPressed: () => _signIn(context, labels), text: labels?.translate('login.sign_in') ?? 'Sign In')),
              SizedBox(height: 20),
              SizedBox(
                width: 250.0,
                child: ElevatedButton.icon(
                  onPressed: () => _loginWithGoogle(context),
                  icon: SvgPicture.asset('assets/svg/googleLogo.svg', height: 24),
                  label: Text(labels?.translate('google.login') ?? 'Login with Google', style: TextStyle(color: const Color.fromARGB(255, 64, 63, 63))),
                  style: CustomButtonStyle.elevatedButtonStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
