import 'package:flutter/material.dart';

class RadiusSelectionDialog {
  static Future<void> showRadiusSelectionDialog(
      BuildContext context, Function onTap) async {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AlertDialog(
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                  title: Text("0.3"),
                  onTap: () {
                    onTap(0.3);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("0.5"),
                  onTap: () {
                    onTap(0.5);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("1"),
                  onTap: () {
                    onTap(1.toDouble());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("2"),
                  onTap: () {
                    onTap(2.toDouble());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("3"),
                  onTap: () {
                    onTap(3.toDouble());
                    Navigator.pop(context);
                  },
                ),
              ]));
        });
  }
}
