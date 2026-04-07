import 'package:flutter/material.dart';
import '../l18n.dart';

class CustomDialogStyle {
  static Widget buildAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String buttonText,
    Color? backgroundColor,
    Color? titleColor,
    Color? contentColor,
    Color? buttonTextColor,
    VoidCallback? onPressed,
  }) {
    final labels = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        color: backgroundColor ?? Color.fromARGB(255, 88, 145, 238), // Set the background color
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Color.fromARGB(255, 28, 20, 86), // Set the title color
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                content,
                style: TextStyle(
                  color: contentColor ?? Colors.black87, // Set the content color
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onPressed ?? () => Navigator.pop(context),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: buttonTextColor ?? Color.fromARGB(255, 2, 17, 98), // Set the button text color
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
