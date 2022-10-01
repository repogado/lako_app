import 'package:flutter/material.dart';

showNackbar(String msg, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(msg),
    action: SnackBarAction(
      label: '',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
