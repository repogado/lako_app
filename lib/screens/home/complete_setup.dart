import 'package:flutter/material.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/utils/form_validations.dart';
import 'package:lako_app/utils/size_config.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/loading_dialog.dart';
import 'package:lako_app/widgets/textfields/auth_textfield.dart';
import 'package:provider/provider.dart';
import 'package:lako_app/utils/globals.dart' as globals;

class CompleteSetup extends StatefulWidget {
  const CompleteSetup({Key? key}) : super(key: key);

  @override
  State<CompleteSetup> createState() => _CompleteSetupState();
}

class _CompleteSetupState extends State<CompleteSetup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<String> list = <String>[
    'Fish Vendor',
    'Fruit Vendor',
    'Taho Vendor',
    'Mais Vendor',
    'Balut Vendor',
    'Ice Cream Vendor',
    'Maruya/Turon/kakanin Vendor',
  ];

  String dropdownValue = "Fish Vendor";

  late AuthProvider _authProvider;

  final _formKey = GlobalKey<FormState>();

  bool _loading = true;

  TextEditingController mobileController = TextEditingController();

  int _length = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AuthProvider tempAuthProvider =
          Provider.of<AuthProvider>(context, listen: false);
      print(tempAuthProvider.user.firstName.toString());
      if (tempAuthProvider.user.mobileNumber == null ||
          tempAuthProvider.user.mobileNumber!.isEmpty) {
        _length = 3;
      } else {
        if (tempAuthProvider.user.type == 'customer') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> routes) => false);
        }
        if (tempAuthProvider.user.type == 'vendor') {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home_vendor', (Route<dynamic> routes) => false);
        }
      }
      _tabController = TabController(vsync: this, length: _length);

      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index == 1) {
          _tabController.animateTo(0);
          return false;
        } else if (_tabController.index == 2) {
          _tabController.animateTo(1);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : TabBarView(controller: _tabController, children: [
                if (_length == 3)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.safeBlockVertical * 6,
                        horizontal: SizeConfig.blockSizeHorizontal * 8),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Complete Details",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 10),
                              AuthTextField(
                                textEditingController: TextEditingController(
                                    text: _authProvider.user.firstName),
                                title: "First Name",
                                disabled: true,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2),
                              AuthTextField(
                                textEditingController: TextEditingController(
                                    text: _authProvider.user.lastName),
                                title: "Last Name",
                                disabled: true,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2),
                              AuthTextField(
                                textEditingController: mobileController,
                                title: "Contact Number",
                                validator: (value) {
                                  return Validations().mobileNumberValid(value);
                                },
                              ),
                              SizedBox(
                                  height: SizeConfig.blockSizeVertical * 4),
                              DefButton(
                                onPress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _authProvider
                                        .setUserMobile(mobileController.text);
                                    _tabController.animateTo(1);
                                  }
                                },
                                title: 'NEXT',
                              ),
                            ]),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 6,
                      horizontal: SizeConfig.blockSizeHorizontal * 8),
                  child: Column(
                    children: [
                      Text(
                        "Select User TYPE",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      Expanded(
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          child: InkWell(
                            onTap: () {
                              if (_length == 2) {
                                _tabController.animateTo(1);
                              } else {
                                _tabController.animateTo(2);
                              }
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Vendor",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      Expanded(
                        child: Material(
                          color: Theme.of(context).primaryColor,
                          child: InkWell(
                            onTap: () async {
                              showLoaderDialog(context);
                              User user = _authProvider.user;
                              user.type = 'customer';
                              final aPIResponse =
                                  await _authProvider.updateUser(user);
                              Navigator.pop(context);
                              showNackbar(aPIResponse.msg);
                              if (aPIResponse.success) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/home',
                                    (Route<dynamic> routes) => false);
                              }
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                  "Customer",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 6,
                      horizontal: SizeConfig.blockSizeHorizontal * 8),
                  child: Column(
                    children: [
                      Text(
                        "Select Vendor Type",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      Expanded(
                        child: Center(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: const TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      DefButton(
                        onPress: () async {
                          showLoaderDialog(context);
                          User user = _authProvider.user;
                          user.type = 'vendor';
                          if (_length == 3) {
                            user.mobileNumber = mobileController.text;
                          }
                          user.vendor = dropdownValue;
                          print(user.toJson().toString()+" userr");
                          final aPIResponse =
                              await _authProvider.updateUser(user);
                          Navigator.pop(context);
                          showNackbar(aPIResponse.msg);
                          if (aPIResponse.success) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home_vendor', (Route<dynamic> routes) => false);
                          }
                        },
                        title: "Submit",
                      )
                    ],
                  ),
                )
              ]),
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
