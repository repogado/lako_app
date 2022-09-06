import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/dialogs/role_selection_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      Navigator.of(context).pushNamed('/login');
      // SelectionDialog.showSelectionDialog(context, (Choices choice) {
      //   log(choice.toString());
      // }, (val) {
      //   Navigator.of(context).pushNamed('/login');
      //   log(val.toString());
      // });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Center(
          child: Icon(  
        Icons.abc,
        size: 100,
      )),
    );
  }
}
