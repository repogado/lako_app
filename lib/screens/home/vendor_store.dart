import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/dialogs/finding_vendor.dart';

class VendorStore extends StatefulWidget {
  final String? id;
  final Function onBookTap;

  const VendorStore({
    required this.id,
    required this.onBookTap,
    Key? key,
  }) : super(key: key);

  @override
  State<VendorStore> createState() => _VendorStoreState();
}

class _VendorStoreState extends State<VendorStore> {
  User? _user = null;

  bool isFavorite = false;

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () async {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
        final authp = Provider.of<AuthProvider>(context, listen: false);

        bool res = await authp.checkOnFavorites(widget.id!);
        setState(() {
          isFavorite = res;
        });

        DatabaseReference ref =
            FirebaseDatabase.instance.ref("lako/users/${widget.id}/");
        final snapshot = await ref.get();
        // Map? values = snapshot.value as Map?;
        print(widget.id);
        print(snapshot.value);
        if(snapshot.value == null){
          Navigator.of(context).popUntil((route) => route.isFirst);
          return;
        }
        Map<String, dynamic> values =
            Map<String, dynamic>.from(json.decode(jsonEncode(snapshot.value)));
        // Map<String, dynamic>? values =
        //     jsonDecode(jsonEncode(snapshot.value)) as Map<String, dynamic>?;
        User user = User.fromJson(values);
        setState(() {
          _user = user;
        });
        print(values);
      });
    });

    super.initState();
  }

  late AuthProvider _authProvider;

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
    // final args =
    //       ModalRoute.of(context)!.settings.arguments as VendorStoreArugements;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          IconButton(
            onPressed: () async{
              bool res = await _authProvider.addToFavorites(widget.id!);
              setState(() {
                isFavorite = res;
              });
            },
            icon: Icon(
              Icons.favorite,
              color: isFavorite ? Colors.yellow : Colors.white,
            ),
          ),
        ],
      ),
      body: _user != null
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Store Name: " + _user!.storeName!,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Vendor Type: " + _user!.vendor!,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Vendor Name: " +
                              _user!.firstName! +
                              " " +
                              _user!.lastName!,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "About the store: " + _user!.preferenceList!,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        RatingBar.builder(
                          initialRating: _user!.rating == ""
                              ? 0
                              : double.parse(_user?.rating ?? "0"),
                          minRating: 1,
                          maxRating: 5,
                          direction: Axis.horizontal,
                          ignoreGestures: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        )
                      ],
                    ),
                  ),
                  DefButton(
                      onPress: () async {
                        await _authProvider.bookVendor(context, widget.id!);
                        widget.onBookTap(widget.id);
                      },
                      title: 'BOOK')
                ],
              ),
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

}
