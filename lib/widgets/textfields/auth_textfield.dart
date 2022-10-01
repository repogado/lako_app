// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String title;
  final Function validator;
  final bool isPassword;
  final bool isNumber;
  final bool disabled;

  const AuthTextField({
    Key? key,
    required this.textEditingController,
    required this.title,
    required this.validator,
    this.isPassword = false,
    this.isNumber = false,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = !widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return widget.validator(value);
      },
      enabled: !widget.disabled,
      controller: widget.textEditingController,
      obscureText: !_passwordVisible,
      keyboardType: widget.isNumber ? TextInputType.number : null,
      decoration: InputDecoration(
        labelText: widget.title,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        suffixIcon: !widget.isPassword
            ? null
            : IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
      ),
    );
  }
}
