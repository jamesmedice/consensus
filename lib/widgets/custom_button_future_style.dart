import 'package:flutter/material.dart';

class CustomButtonStyle {
  static ButtonStyle elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
        shadowColor: Color.fromARGB(255, 1, 3, 121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      textStyle: TextStyle(
        color: Color.fromARGB(255, 75, 77, 84),
        fontSize: 18.0,
      ),
      minimumSize: Size(200, 40),
    );
  }
}
