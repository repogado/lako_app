// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class DefButton extends StatelessWidget {
  final Function onPress;
  final String title;
  final int mode;

  const DefButton({
    Key? key,
    required this.onPress,
    required this.title,
    this.mode = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    Color backgroundColor = Theme.of(context).primaryColor;
    switch (mode) {
      case 1:
        textColor = Colors.white;
        backgroundColor = Theme.of(context).primaryColor;
        break;
      case 2:
        textColor = Theme.of(context).primaryColor;
        backgroundColor = Theme.of(context).primaryColor.withOpacity(.1);
        break;
              case 3:
        textColor = Theme.of(context).primaryColor;
        backgroundColor = Colors.white;
        break;
    }
    return Container(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
            primary: textColor, backgroundColor: backgroundColor),
        onPressed: () {
          onPress();
        },
        child: Text(title),
      ),
    );
  }
}
