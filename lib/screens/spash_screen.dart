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
      await Future.delayed(const Duration(milliseconds: 1000));
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/logo.jpg"),
      ),
    );
  }
}
