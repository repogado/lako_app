import 'package:flutter/material.dart';

showYesNoDialog(
    BuildContext context, String title, String content, Function onYes) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      Navigator.pop(context);
      onYes();
    },
  );
  Widget continueButton = TextButton(
    child: Text("No"),
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
      continueButton,
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
