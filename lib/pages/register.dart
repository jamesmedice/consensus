import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_dialog.dart';
import '../constants/app_colors.dart';
import '../l18n.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _registrationStatus = '';

  Future<void> _register() async {
    final labels = AppLocalizations.of(context);

    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        if (isPasswordValid(_passwordController.text)) {
          await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          setState(() {
            _registrationStatus = labels?.translate('registration.success') ??
                'Registration successful!';
          });
          _showSuccessModal();
        } else {
          setState(() {
            _registrationStatus = labels?.translate('registration.wrongpass') ??
                'Password must contain letters, numbers, and special characters.';
          });
        }
      } else {
        setState(() {
          _registrationStatus =
              labels?.translate('registration.notmatchpass') ??
                  'Passwords do not match!';
        });
      }
    } catch (e) {
      setState(() {
        _registrationStatus = labels?.translate('registration.exception') ??
            'Error during registration: $e';
      });
    }
  }

  bool isPasswordValid(String password) {
    // Regex pattern : requires at least one uppercase letter, one lowercase letter, one digit, and one special character
    // It also enforces a minimum length of 8 characters
    RegExp regex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$',
    );

    return regex.hasMatch(password);
  }

  void _showSuccessModal() {
    final labels = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogStyle.buildAlertDialog(
          context: context,
          title: labels?.translate('register.success') ?? 'Success!!!',
          content: labels?.translate('register.text') ??
              'User has been successfully registered.',
          buttonText: labels?.translate('register.ok') ?? 'OK',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientStart,
              AppColors.gradientEnd,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputField(
                controller: _emailController,
                label: labels?.translate('login.email') ?? 'Email*',
              ),
              SizedBox(height: 10),
              InputField(
                controller: _passwordController,
                label: labels?.translate('login.psw') ?? 'Password*',
                obscureText: true,
              ),
              SizedBox(height: 10),
              InputField(
                controller: _confirmPasswordController,
                label: labels?.translate('login.rpsw') ?? 'Repeat Password*',
                obscureText: true,
              ),
              SizedBox(height: 10),
              CustomText(
                text: _registrationStatus,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 250.0,
                child: CustomButton(
                  onPressed: _register,
                  text: labels?.translate('login.signup') ?? 'Register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
