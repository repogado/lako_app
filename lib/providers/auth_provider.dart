import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lako_app/models/response.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/services/auth_service.dart';
import 'package:lako_app/services/notification_service.dart';
import 'package:lako_app/utils/globals.dart' as globals;
import 'package:lako_app/utils/location_distance.dart';
import 'package:lako_app/widgets/dialogs/error_dialog.dart';
import 'package:lako_app/widgets/dialogs/info_dialog.dart';
import 'package:lako_app/widgets/dialogs/snackbar_msg.dart';

class AuthProvider with ChangeNotifier {
  late AuthService _authService;
  late NotificationService _notificationService;

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
    _notificationService = NotificationService();
    _connectedUser = User(id: null);
  }

  String setUser(String data) {
    User localData = User.fromJson(jsonDecode(data));
    // print(localData.access);
    _user = localData;
    // globals.token = localData.access!;
    notifyListeners();
    return localData.access!;
  }

  Future<void> setConnectedUser(User connectedUser) async {
    try {
      _connectedUser = connectedUser;

      notifyListeners();
    } catch (e) {}
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
    // _user.latitude = latLng.latitude.toString();
    // _user.longitude = latLng.longitude.toString();
    _user = _user.copyWith(latitude: latLng.latitude.toString());
    _user = _user.copyWith(longitude: latLng.longitude.toString());
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lako/users/${_user.id}");
    await ref.set(_user.toJson());

    if (_user.type == 'vendor' && _isVendorOnline) {
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("lako/onlineVendors/${_user.id}");
      Map data = {
        "customer_id": "",
        "status": "waiting",
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
      };
      await ref2.set(data);
    }
    notifyListeners();
  }

  void setVendorOnlineOffline(BuildContext context, LatLng latLng) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lako/onlineVendors/${user.id}");
      if (!_isVendorOnline) {
        Map data = {
          "customer_id": null,
          "status": "waiting",
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
        };
        await ref.set(data).catchError((error) {
          showNackbar("Failed to go online", context);
        });
        _notificationService.sendNearbyNotif(_user.vendor!);
      } else {
        await ref.remove();
      }
      _isVendorOnline = !_isVendorOnline;
      notifyListeners();
    } catch (e) {
      showNackbar("Failed to go online", context);
    }
  }

  Future<int?> findVendor(BuildContext context) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lako/onlineVendors/");
    final snapshot = await ref.get();

    int id = 0;
    double lowestDistance = -1;

    if (snapshot.exists) {
      Map<dynamic, dynamic>? values = snapshot.value as Map?;
      values!.forEach((key, values) {
        print(values['latitude']);
        print(values['longitude']);
        print(_user.toJson());
        double distance = calculateDistance(
            double.parse(_user.latitude.toString()),
            double.parse(_user.longitude.toString()),
            values['latitude'],
            values['longitude']);
        if (lowestDistance == -1 || distance < lowestDistance) {
          lowestDistance = distance;
          id = int.parse(key);
        }
      });
      print(id.toString() + " " + lowestDistance.toString() + ' diss');
      return id;
    } else {
      Navigator.pop(context);
      showInfoDialog(context, "No Vendors Found",
          "Oops! There are currently no vendors nearby. Please try again later.");
      return null;
    }
  }
}
