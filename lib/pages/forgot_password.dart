import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dialog.dart';
import '../constants/app_colors.dart';
import '../l18n.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context, AppLocalizations? labels) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);

      String successMessage = labels?.translate('login.resetMessage') ?? 'Password reset email sent successfully. Check your email.';

      String button = labels?.translate('dialog.button') ?? 'OK';
      String title = labels?.translate('dialog.title') ?? 'Error';

      _showSuccessMessage(title, button, successMessage);
    } catch (e) {}
  }

  void _showSuccessMessage(String title, String button, String successMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogStyle.buildAlertDialog(
          context: context,
          title: title,
          content: successMessage,
          buttonText: button,
          onPressed: () {
            Navigator.of(context).pop();
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
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.gradientStart, AppColors.gradientEnd])),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputField(controller: _emailController, label: labels?.translate('login.email') ?? 'Email'),
              SizedBox(height: 16.0),
              SizedBox(width: 250.0, child: CustomButton(onPressed: () => _resetPassword(context, labels), text: labels?.translate('login.resetPass') ?? 'Reset Password')),
            ],
          ),
        ),
      ),
    );
  }
}
