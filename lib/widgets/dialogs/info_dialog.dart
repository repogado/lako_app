import 'package:flutter/material.dart';

showInfoDialog(
    BuildContext context, String title, String content) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Okay"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
