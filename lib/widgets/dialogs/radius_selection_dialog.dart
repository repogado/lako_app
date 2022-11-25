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
                  title: Text("2"),
                  onTap: () {
                    onTap(2.toDouble());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("5"),
                  onTap: () {
                    onTap(5.toDouble());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("10"),
                  onTap: () {
                    onTap(10.toDouble());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("15"),
                  onTap: () {
                    onTap(15.toDouble());
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("20"),
                  onTap: () {
                    onTap(20.toDouble());
                    Navigator.pop(context);
                  },
                ),
              ]));
        });
  }
}
