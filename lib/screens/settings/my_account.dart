import 'package:flutter/material.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/utils/form_validations.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/textfields/auth_textfield.dart';
import 'package:provider/provider.dart';

import '../../widgets/dialogs/loading_dialog.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late AuthProvider _authProvider;

  final _formKey = GlobalKey<FormState>();

  List<String> list = <String>[
    'Fish Vendor',
    'Fruit Vendor',
    'Taho Vendor',
    'Mais Vendor',
    'Balut Vendor',
    'Ice Cream Vendor',
    'Maruya/Turon/kakanin Vendor',
  ];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  String selectedValue = "Fish Vendor";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      firstNameController.text = _authProvider.user.firstName!;
      lastNameController.text = _authProvider.user.lastName!;
      contactNumberController.text = _authProvider.user.mobileNumber!;
      if (_authProvider.user.type == 'vendor')
        setState(() {
          selectedValue = _authProvider.user.vendor!;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 5,
            horizontal: SizeConfig.blockSizeHorizontal * 8,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(_authProvider
                          .user.imgUrl!.isNotEmpty
                      ? _authProvider.user.imgUrl!
                      : "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                  radius: 60,
                ),
                SizedBox(height: 15),
                AuthTextField(
                  textEditingController: firstNameController,
                  title: 'First Name',
                  validator: (value) {
                    return Validations().signUpNameValidator(value);
                  },
                ),
                SizedBox(height: 15),
                AuthTextField(
                  textEditingController: lastNameController,
                  title: 'Last Name',
                  validator: (value) {
                    return Validations().signUpNameValidator(value);
                  },
                ),
                SizedBox(height: 15),
                AuthTextField(
                  textEditingController: contactNumberController,
                  title: 'Phone',
                  validator: (value) {
                    return Validations().mobileNumberValid(value);
                  },
                ),
                if (_authProvider.user.type == 'vendor')
                  Column(
                    children: [
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: "Vendor Type",
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        value: selectedValue,
                        items: list.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                DefButton(
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      User user = _authProvider.user;
                      print(firstNameController.text);
                      user = user.copyWith(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        mobileNumber: contactNumberController.text,
                        vendor: selectedValue,
                      );
                      showLoaderDialog(context);
                      final aPIResponse = await _authProvider.updateUser(user);
                      Navigator.pop(context);
                      if (aPIResponse.success) {
                        showNackbar("Successfully Updated User");
                      } else {
                        showNackbar(aPIResponse.msg);
                      }
                    }
                  },
                  title: "Save Changes",
                )
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
