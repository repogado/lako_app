import 'package:flutter/material.dart';

class DistanceSelectionDialog {
  static Future<void> showDistanceSelectionDialog(
      BuildContext context, Function onTap) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Miles"),
                onTap: () {
                  onTap("Miles");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Kilometers"),
                onTap: () {
                  onTap("Kilometers");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


// class DistanceSelectionDialog {
//   static Future<void> showDistanceSelectionDialog(
//       BuildContext context, Function onTap) async {
//     showGeneralDialog(
//         context: context,
//         barrierDismissible: true,
//         barrierLabel:
//             MaterialLocalizations.of(context).modalBarrierDismissLabel,
//         pageBuilder: (BuildContext context, Animation<double> animation,
//             Animation<double> secondaryAnimation) {
//           return AlertDialog(
//               contentPadding: EdgeInsets.symmetric(horizontal: 0),
//               content: Column(mainAxisSize: MainAxisSize.min, children: []));
//         });
//   }
// }

