import 'package:flutter/material.dart';

enum Choices { vendor, customer }

class SelectionDialog {
  static Future<void> showSelectionDialog(
      BuildContext context, Function onSelect, Function onSubmit) async {
    Choices _data = Choices.customer;
    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (BuildContext context) {
    //     return WillPopScope(
    //       onWillPop: () async => false,
    //       child: Container(
    //         color: Colors.white,
    //       )
    //     );
    //   },
    // );
     showGeneralDialog(
        context: context,
        pageBuilder: (_animation, _secondaryAnimation, _child) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                contentPadding: EdgeInsets.symmetric(horizontal: 0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 15),
                    ListTile(
                      title: const Text('Customer'),
                      leading: Radio(
                        value: Choices.customer,
                        groupValue: _data,
                        onChanged: (Choices? value) {
                          setState(() {
                            _data = value!;
                            onSelect(_data);
                          });
                        },
                      ),
                    ),
                    Divider(color: Colors.black54),
                    ListTile(
                      title: const Text('Vendor'),
                      leading: Radio(
                        value: Choices.vendor,
                        groupValue: _data,
                        onChanged: (Choices? value) {
                          setState(() {
                            _data = value!;
                            onSelect(_data);
                          });
                        },
                      ),
                    ),
                    Divider(color: Colors.black54),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: TextButton(
                          //     style: TextButton.styleFrom(
                          //         primary: Colors.white,
                          //         backgroundColor:
                          //             Theme.of(context).primaryColor),
                          //     onPressed: () {
                          //       onSubmit(0);
                          //     },
                          //     child: Text('Login'),
                          //   ),
                          // ),
                          // SizedBox(width: 15),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).primaryColor),
                              onPressed: () {
                                onSubmit(1);
                              },
                              child: Text('Sign Up'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ));
          });
        });
  }
}
