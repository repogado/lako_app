import 'package:flutter/material.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';

showFindingDialog(BuildContext context, String title,Function onCancel) {
  AlertDialog alert = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
    Text(title),
    SizedBox(height: 15),
    CircularProgressIndicator(),
    SizedBox(height: 15),
    DefButton(
      onPress: () {
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
      return WillPopScope(onWillPop: () async => true, child: alert);
    },
  );
}
