import 'package:flutter/material.dart';
import 'package:lako_app/widgets/dialogs/info_dialog.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/form_validations.dart';
import '../../widgets/buttons/def_button.dart';
import '../../widgets/textfields/auth_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailTextController = TextEditingController();

  late AuthProvider _authProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(
                  textEditingController: _emailTextController,
                  title: "Email",
                  validator: (value) {
                    return Validations().emailValidator(value);
                  },
                ),
                SizedBox(height: 20),
                DefButton(
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      showInfoDialog(context, "Email Sent",
                          "Please check you email sent at ${_emailTextController.text} to reset password");
                      _emailTextController.text = "";
                    }
                  },
                  title: 'SUBMIT',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
