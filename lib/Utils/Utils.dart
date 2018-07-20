import 'package:flutter/material.dart';

class Utils {

  static void displaySnackbarText(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}