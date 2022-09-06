import 'package:flutter/material.dart';
import 'package:lako_app/utils/size_config.dart';

class SignupVendorScreen extends StatefulWidget {
  const SignupVendorScreen({Key? key}) : super(key: key);

  @override
  State<SignupVendorScreen> createState() => _SignupVendorScreenState();
}

class _SignupVendorScreenState extends State<SignupVendorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 5,
              horizontal: SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
