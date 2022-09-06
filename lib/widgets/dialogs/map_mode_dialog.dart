import 'package:flutter/material.dart';

class MapModeDialog {
  static Future<void> showMapModeDialog(BuildContext context) async {
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            content: Column(mainAxisSize: MainAxisSize.min, children: const [
              ListTile(
                title: Text("Normal"),
              ),
              ListTile(
                title: Text("Terrain"),
              ),
              ListTile(
                title: Text("Satellite"),
              ),
            ]),
          );
        });
  }
}
