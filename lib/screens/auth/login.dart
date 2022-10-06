import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/utils/form_validations.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/loading_dialog.dart';
import 'package:lako_app/widgets/dialogs/role_selection_dialog.dart';
import 'package:lako_app/widgets/dialogs/snackbar_msg.dart';
import 'package:lako_app/widgets/textfields/auth_textfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  late AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockSizeVertical * 5,
              horizontal: SizeConfig.blockSizeHorizontal * 5),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                  Image.asset(
                    "assets/logo.jpg",
                    width: 200,
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                  AuthTextField(
                    textEditingController: _emailTextController,
                    title: "Email / Mobile Number",
                    validator: (value) {
                      return Validations().emailMobileValidation(value);
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                  AuthTextField(
                    textEditingController: _passwordTextController,
                    title: "Password",
                    isPassword: true,
                    validator: (value) {
                      return Validations().passwordValidation(value);
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password'),
                    ),
                  ),
                  DefButton(
                    onPress: () async {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        showLoaderDialog(context);
                        final aPIResponse = await _authProvider.login({
                          "email": _emailTextController.text,
                          "password": _passwordTextController.text,
                          "is_via_gmail": false,
                        });
                        Navigator.pop(context);
                        if (aPIResponse.success) {
                          print('success');
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/complete_setup',
                              (Route<dynamic> routes) => false);
                        } else {
                          showNackbar(aPIResponse.msg, context);
                        }

                        // Navigator.of(context).pushNamed('/complete_setup');
                        // DatabaseReference ref =
                        //     FirebaseDatabase.instance.ref("lako/users/1");
                        // await ref
                        //     .set({
                        //       "username": "john11",
                        //       "password": "12345",
                        //     });

                        // final ref = FirebaseDatabase.instance.ref();
                        // final snapshot = await ref.child('lako/users/2').get();
                        // if (snapshot.exists) {
                        //   print(snapshot.value);
                        // } else {
                        //   print('No data available.');
                        // }
                        // showLoaderDialog(context);

                      }
                    },
                    title: 'LOGIN',
                  ),
                  DefButton(
                    mode: 2,
                    onPress: () {
                      Navigator.of(context).pushNamed('/signupcustomer');
                    },
                    title: "SIGN UP",
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 1), // Shadow position
                        ),
                      ],
                    ),
                    child: Material(
                      child: InkWell(
                        onTap: () async {
                          GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
                            'email',
                            // 'https://www.googleapis.com/auth/contacts.readonly'
                          ]);
                          final res = await _googleSignIn.signIn();
                          if (res!.id.isEmpty) {
                            return;
                          }
                          showLoaderDialog(context);
                          final aPIResponse =
                              await _authProvider.loginViaGmail(res);
                          Navigator.pop(context);
                          if (aPIResponse.success) {
                            print('success');
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/complete_setup',
                                (Route<dynamic> routes) => false);
                          } else {
                            showNackbar(aPIResponse.msg, context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/google.png", width: 30),
                              SizedBox(width: 15),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[500]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton.icon(
                  //   icon: const Icon(
                  //     Icons.gmail,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {},
                  //   label: Text(
                  //     "Schedule",
                  //     style: const TextStyle(fontSize: 16, color: Colors.white),
                  //   ),
                  //   style: ElevatedButton.styleFrom(),
                  // )
                ]),
          ),
        ),
      ),
    );
  }
}
