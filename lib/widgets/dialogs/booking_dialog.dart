import 'package:flutter/material.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';

showBookingDIalog(BuildContext context, Function onAccept, Function onCancel) {
  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "New Booking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Text("A Booking is waiting for you to accept."),
        SizedBox(height: 15),
        DefButton(
          onPress: () {
            onAccept();
          },
          title: "ACCEPT",
        ),
        SizedBox(height: 10),
        DefButton(
          mode: 2,
          onPress: () {
            Navigator.pop(context);
            onCancel();
          },
          title: "CANCEL",
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(onWillPop: () async => false, child: alert);
    },
  );
}
