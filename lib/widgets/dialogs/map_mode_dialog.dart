import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapModeDialog {
  static Future<void> showMapModeDialog(
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
                title: Text("Normal"),
                onTap: () {
                  onTap(MapType.normal);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Terrain"),
                onTap: () {
                  onTap(MapType.terrain);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Satellite"),
                onTap: () {
                  onTap(MapType.satellite);
                  Navigator.pop(context);
                },
              ),
            ]),
          );
        });
  }
}
