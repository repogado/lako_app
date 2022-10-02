import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lako_app/models/response.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/services/auth_service.dart';
import 'package:lako_app/utils/globals.dart' as globals;
import 'package:lako_app/widgets/dialogs/snackbar_msg.dart';

class AuthProvider with ChangeNotifier {
  late AuthService _authService;

  late User _user;

  late User _connectedUser;

  bool _isVendorOnline = false;
  bool loading = false;

  User get user => _user;
  User get connectedUser => _connectedUser;
  bool get isVendorOnline => _isVendorOnline;

  AuthProvider() {
    print(globals.token + " provd");
    _authService = AuthService();
  }

  String setUser(String data) {
    User localData = User.fromJson(jsonDecode(data));
    // print(localData.access);
    _user = localData;
    // globals.token = localData.access!;
    notifyListeners();
    return localData.access!;
  }

  void setUserMobile(String mobile) {
    _user = _user.copyWith(mobileNumber: mobile);
    notifyListeners();
  }

  Future<APIResponse> signUp(Map data) async {
    try {
      APIResponse? response = await _authService.signUpUser(data);
      return response;
    } catch (e) {
      print(e.toString());
      return APIResponse(
        "Something Went Wrong!",
        false,
        null,
      );
    }
  }

  Future<APIResponse> login(Map data) async {
    try {
      APIResponse<User> response = await _authService.login(data);
      _user = response.data!;
      notifyListeners();
      return response;
    } on APIResponse catch (e) {
      return e;
    }
  }

  Future<APIResponse> loginViaGmail(GoogleSignInAccount data) async {
    try {
      APIResponse<User> response = await _authService.loginViaGmail(data);
      _user = response.data!;
      notifyListeners();
      return response;
    } on APIResponse catch (e) {
      return e;
    }
  }

  Future<APIResponse> updateUser(User data) async {
    try {
      APIResponse<User> response =
          await _authService.updateUser(data, _user.id!);
      _user = response.data!;
      notifyListeners();
      return response;
    } on APIResponse catch (e) {
      return e;
    }
  }

  void setUserLocation(LatLng latLng) async {
    user.latitude = latLng.latitude.toString();
    user.longitude = latLng.longitude.toString();
    notifyListeners();
  }

  void setVendorOnlineOffline(BuildContext context) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lako/onlineVendors/${user.id}");
      if (!_isVendorOnline) {
        await ref.set(user.toJson()).catchError((error) {
          showNackbar("Failed to go online", context);
        });
      } else {
        await ref.remove();
      }
      _isVendorOnline = !_isVendorOnline;
      notifyListeners();
    } catch (e) {
      showNackbar("Failed to go online", context);
    }
  }
}
