import 'package:flutter/material.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/utils/form_validations.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/textfields/auth_textfield.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late AuthProvider _authProvider;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _authProvider = Provider.of<AuthProvider>(context, listen: false);
      firstNameController.text = _authProvider.user.firstName!;
      lastNameController.text = _authProvider.user.lastName!;
      contactNumberController.text = _authProvider.user.mobileNumber!;
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
              SizedBox(height: 20),
              DefButton(
                onPress: () {},
                title: "Save Changes",
              )
            ],
          ),
        ),
      ),
    );
  }
}
