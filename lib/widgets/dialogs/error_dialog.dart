import 'package:flutter/material.dart';

class ErrorDialog {
  static Future<void> showDistanceSelectionDialog(
      BuildContext context, String msg) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          title: const Text('Error'),
          content: Text(msg),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
