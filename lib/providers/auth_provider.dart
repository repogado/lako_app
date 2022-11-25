import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
import 'package:restart_app/restart_app.dart';

import '../models/messages.dart';

class AuthProvider with ChangeNotifier {
  late AuthService _authService;
  late NotificationService _notificationService;

  late User _user;

  late User _connectedUser;

  late List<Messages> _messages;

  bool _isVendorOnline = false;
  bool loading = false;

  late String _status;

  User get user => _user;
  User get connectedUser => _connectedUser;
  bool get isVendorOnline => _isVendorOnline;
  List<Messages> get messages => _messages;
  String get status => _status;

  AuthProvider() {
    print(globals.token + " provd");
    _authService = AuthService();
    _notificationService = NotificationService();
    _connectedUser = User(id: null);
    _status = 'waiting';
    _messages = [];
  }

  String setUser(String data) {
    User localData = User.fromJson(jsonDecode(data));
    // print(localData.access);
    _user = localData;
    // globals.token = localData.access!;
    notifyListeners();
    return localData.access!;
  }

  void setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  Future<void> setConnectedUser(User connectedUser) async {
    try {
      _connectedUser = connectedUser;
      _status = 'confirmed';
      notifyListeners();
    } catch (e) {}
  }

  Future<void> cancelBooking() async {
    DatabaseReference ref2 = FirebaseDatabase.instance
        .ref("lako/onlineVendors/${_user.id}/data/status");
    await ref2.set('cancelled');
  }

  void updateConnectedUserLocation(String lat, String lang) async {
    _connectedUser = _connectedUser.copyWith(
      latitude: lat,
      longitude: lang,
    );
    notifyListeners();
  }

  void setStatusToConfirmed(DatabaseEvent event) async {
    final ref1 = FirebaseDatabase.instance.ref();
    Map<String, dynamic>? value = jsonDecode(jsonEncode(event.snapshot.value));
    value!['status'] = 'confirmed';
    final snapshot3 =
        await ref1.child('lako/onlineVendors/${_user.id}/data/').set(value);
  }

  void setStatusToCancelled() async {
    final ref1 = FirebaseDatabase.instance.ref();
    final snapshot3 = await ref1
        .child(
            'lako/onlineVendors/${_user.vendor == 'vendor' ? _user.id : _connectedUser.id}/data/status')
        .set('cancelled');
    setConnectedUser(User());
    notifyListeners();
    if (_user.vendor == 'vendor') {
      Restart.restartApp();
    }
  }

  void setStatusToCompleted() async {
    final ref1 = FirebaseDatabase.instance.ref();
    final snapshot3 = await ref1
        .child('lako/onlineVendors/${_user.id}/data/status')
        .set('completed');
    _status = 'completed';
    setConnectedUser(User());
    notifyListeners();
    Restart.restartApp();
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
          FirebaseDatabase.instance.ref("lako/onlineVendors/${_user.id}/data");
      Map data = {
        "customer_id": connectedUser.id != null ? connectedUser.id! : "",
        "vendorType": _user.vendor,
        "status": status,
        "latitude": latLng.latitude,
        "longitude": latLng.longitude,
        "store_name": _user.storeName,
      };
      await ref2.set(data);
    }
    notifyListeners();
  }

  void setVendorOnlineOffline(BuildContext context, LatLng latLng) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("lako/onlineVendors/${user.id}/data");
      if (!_isVendorOnline) {
        Map data = {
          "customer_id": "",
          "vendorType": _user.vendor,
          "status": status,
          "latitude": latLng.latitude,
          "longitude": latLng.longitude,
          "store_name": _user.storeName,
        };
        await ref.set(data).catchError((error) {
          showNackbar("Failed to go online", context);
        });
        _notificationService.sendNearbyNotif(_user.vendor!);
        _notificationService.sendNotifFavorites(_user.id.toString());
      } else {
        await ref.remove();
      }
      _isVendorOnline = !_isVendorOnline;
      notifyListeners();
    } catch (e) {
      showNackbar("Failed to go online", context);
    }
  }

  Future<int?> bookVendor(BuildContext context, String vendorId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lako/onlineVendors/");
    final snapshot = await ref.get();

    int id = 0;
    double lowestDistance = -1;

    if (snapshot.exists) {
      Map<dynamic, dynamic>? values = snapshot.value as Map?;
      values!.forEach((key, values) {
        // double distance = calculateDistance(
        //     double.parse(_user.latitude.toString()),
        //     double.parse(_user.longitude.toString()),
        //     values['latitude'],
        //     values['longitude']);
        if (key == vendorId) {
          // lowestDistance = distance;
          id = int.parse(key);
        }
      });

      values['$id']['data']['customer_id'] = _user.id;
      ref.child('$id/').set(values['$id']);
      print(id.toString() + " " + lowestDistance.toString() + ' diss');
      return id;
    } else {
      showInfoDialog(context, "No Vendors Found",
          "Oops! There are currently no vendors nearby. Please try again later.");
      return null;
    }
  }

  Future<int?> findVendor(BuildContext context, String vendorTpe) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lako/onlineVendors/");
    final snapshot = await ref.get();

    int id = 0;
    double lowestDistance = -1;

    if (snapshot.exists) {
      Map<dynamic, dynamic>? values = snapshot.value as Map?;
      values!.forEach((key, values) {
        double distance = calculateDistance(
            double.parse(_user.latitude.toString()),
            double.parse(_user.longitude.toString()),
            values['data']['latitude'],
            values['data']['longitude']);
        if (lowestDistance == -1 || distance < lowestDistance) {
          lowestDistance = distance;
          id = int.parse(key);
        }
      });
      if (values['$id']['data']['vendorType'] != vendorTpe) {
        showInfoDialog(context, "No Vendors Found",
            "Oops! There are currently no vendors nearby. Please try again later.");
        return null;
      }

      values['$id']['data']['customer_id'] = _user.id;
      ref.child('$id/').set(values['$id']);
      print(id.toString() + " " + lowestDistance.toString() + ' diss');
      return id;
    } else {
      showInfoDialog(context, "No Vendors Found",
          "Oops! There are currently no vendors nearby. Please try again later.");
      return null;
    }
  }

  void setMessages(List<Messages> msgs) {
    _messages = msgs;
    notifyListeners();
  }

  void addMessage(Messages msg) {
    _messages.add(msg);
    notifyListeners();
  }

  Future<bool> addToFavorites(String id) async {
    DatabaseReference ref2 =
        FirebaseDatabase.instance.ref("lako/favorites/${_user.id}");
    final snapshot = await ref2.get();

    Map<dynamic, dynamic>? values = {};

    if(snapshot.exists){
      print('test');
      values = snapshot.value as Map?;
    }

    bool isExists = false;

    values!.forEach((key, values) {
      if (key == id) {
        isExists = true;
      }
    });
    if (isExists) {
      ref2.child(id).remove();
      return false;
    } else {
      ref2.child(id).set(id);
      return true;
    }
  }

  Future<bool> checkOnFavorites(String id) async {
    DatabaseReference ref2 =
        FirebaseDatabase.instance.ref("lako/favorites/${_user.id}");
    final snapshot = await ref2.get();

    bool isExists = false;

    if (snapshot.exists) {
      Map<dynamic, dynamic>? values = snapshot.value as Map?;
      values!.forEach((key, values) {
        if (key == id) {
          isExists = true;
        }
      });
    }

    return isExists;
  }
}
