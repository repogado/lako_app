import 'package:flutter/material.dart';
import 'package:lako_app/utils/form_validations.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/role_selection_dialog.dart';
import 'package:lako_app/widgets/textfields/auth_textfield.dart';

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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Icon(Icons.abc, size: 100),
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
                    onPress: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        Navigator.of(context).pushNamed('/home');
                      }
                    },
                    title: 'LOGIN',
                  ),
                  DefButton(
                    mode: 2,
                    onPress: () {
                      Choices choiced = Choices.customer;
                      SelectionDialog.showSelectionDialog(context,
                          (Choices choice) {
                        choiced = choice;
                      }, (val) {
                        Navigator.pop(context);
                        if (choiced == Choices.customer) {
                          Navigator.of(context).pushNamed('/signupcustomer');
                        } else {
                          Navigator.of(context).pushNamed('/signupvendor');
                        }
                      });
                    },
                    title: "SIGN UP",
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
