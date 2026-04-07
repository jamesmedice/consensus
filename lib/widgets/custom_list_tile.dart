import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: Color.fromARGB(255, 1, 36, 90),
            fontSize: 18.0,
            fontWeight: FontWeight.w900),
      ),
      onTap: onTap,
    );
  }
}
