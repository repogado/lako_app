import 'package:flutter/material.dart';
import 'package:lako_app/models/response.dart';
import 'package:lako_app/network/api_response.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/utils/form_validations.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/loading_dialog.dart';
import 'package:lako_app/widgets/textfields/auth_textfield.dart';
import 'package:provider/provider.dart';

class SignupCustomer extends StatefulWidget {
  const SignupCustomer({Key? key}) : super(key: key);

  @override
  State<SignupCustomer> createState() => _SignupCustomerState();
}

class _SignupCustomerState extends State<SignupCustomer> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

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
                  width: 150,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                AuthTextField(
                  textEditingController: _firstName,
                  title: "First Name",
                  validator: (value) {
                    return Validations().signUpNameValidator(value);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                AuthTextField(
                  textEditingController: _lastName,
                  title: "Last Name",
                  validator: (value) {
                    return Validations().signUpNameValidator(value);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                AuthTextField(
                  textEditingController: _email,
                  title: "Email",
                  validator: (value) {
                    return Validations().emailMobileValidation(value);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                AuthTextField(
                  isNumber: true,
                  textEditingController: _mobileNumber,
                  title: "Mobile Number",
                  validator: (value) {
                    return Validations().mobileNumberValid(value);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                AuthTextField(
                  textEditingController: _password,
                  title: "Password",
                  isPassword: true,
                  validator: (value) {
                    return Validations().signUpPasswordValidation(value);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                AuthTextField(
                  textEditingController: _confirmPassword,
                  title: "Confirm Password",
                  isPassword: true,
                  validator: (value) {
                    return Validations()
                        .signUpConfirmPasswordValidation(value, _password.text);
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 4),
                DefButton(
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      showLoaderDialog(context);
                      final aPIResponse = await _authProvider.signUp({
                        "first_name": _firstName.text,
                        "last_name": _lastName.text,
                        "email": _email.text,
                        "password": _password.text,
                        "mobile_number": _mobileNumber.text,
                        "is_active": true,
                      });
                      Navigator.pop(context);
                      showNackbar(aPIResponse.msg);
                      if (aPIResponse.success) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> routes) => false);
                      }

                      // Navigator.of(context).pushNamed('/$routeName');
                    }
                  },
                  title: 'SIGN UP',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showNackbar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
