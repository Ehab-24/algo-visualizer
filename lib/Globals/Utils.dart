import 'package:flutter/material.dart';

class Utils {

  static void showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(content)));
  }
}
