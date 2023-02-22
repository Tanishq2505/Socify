import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String text, Color? color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: color,
    ),
  );
}
