import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.readOnly = false, // Add a boolean parameter for readonly
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool readOnly; // Add a boolean property for readonly

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly, // Set the readOnly property based on the flag
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255))),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 3, 0, 25))),
      ),
      obscureText: obscureText,
      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16.0, fontWeight: FontWeight.w500),
    );
  }
}
