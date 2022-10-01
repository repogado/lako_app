import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lako_app/models/response.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/network/dio_conf.dart';
import 'package:lako_app/services/secure_storage_service.dart';
import 'package:lako_app/utils/globals.dart' as globals;
import 'package:namefully/namefully.dart';

class AuthService {
  late Dio dio;

  AuthService() {
    print(globals.token + ' omot');
    dio = Dio(DioConf().options());
    dio.interceptors.add(DioConf().dioInterCeptor(dio));
  }

  Future<APIResponse> signUpUser(Map data) async {
    try {
      String url = 'signup/';
      Response<Map> response = await dio.post(url, data: data);
      bool success = false;
      String msg = '';

      return APIResponse(
        response.data!['message'],
        response.data!['success'],
        null,
      );
    } catch (e) {
      print(e.toString());
      if (e is DioError) {
        return APIResponse(
          e.response!.data!['message'],
          e.response!.data!['success'],
          null,
        );
      } else {
        return APIResponse(
          "Something Went Wrong!",
          false,
          null,
        );
      }
    }
  }

  Future<APIResponse<User>> loginViaGmail(GoogleSignInAccount data) async {
    try {
      String url = 'login/';

      Map params = {"email": data.email, "is_via_gmail": true};

      Response<Map> response = await dio.post(url, data: params);

      Map<String, dynamic> res = response.data!['data'];
      res['access'] = response.data!['token']['access'];
      res['refresh'] = response.data!['token']['refresh'];
      res['first_name'] = getLastNameFirstName(data.displayName!)[0];
      res['last_name'] = getLastNameFirstName(data.displayName!)[1];
      res['imgUrl'] = data.photoUrl;

      DatabaseReference ref = FirebaseDatabase.instance
          .ref("lako/users/${response.data!['data']['id']}");
      await ref.set(res).catchError((error) {
        print(error);
      });

      SecureStorageService().writeData("auth", jsonEncode(res));
      SecureStorageService().writeData("token", res['access']);

      globals.token = res['access'];

      return APIResponse(
        response.data!['message'],
        response.data!['success'],
        User.fromJson(res),
      );
    } catch (e) {
      if (e is DioError) {
        throw APIResponse(
          e.response!.data!['message'],
          e.response!.data!['success'],
          null,
        );
      } else {
        throw APIResponse(
          "Something Went Wrong!",
          false,
          null,
        );
      }
    }
  }

  Future<APIResponse<User>> login(Map data) async {
    try {
      String url = 'login/';
      Response<Map> response = await dio.post(url, data: data);

      Map<String, dynamic> res = response.data!['data'];
      res['access'] = response.data!['token']['access'];
      res['refresh'] = response.data!['token']['refresh'];

      SecureStorageService().writeData("auth", jsonEncode(res));
      SecureStorageService().writeData("token", res['access']);

      globals.token = res['access'];

      return APIResponse(
        response.data!['message'],
        response.data!['success'],
        User.fromJson(res),
      );
    } catch (e) {
      print(e.toString() + 'asdsa');
      if (e is DioError) {
        throw APIResponse(
          e.response!.data!['message'],
          e.response!.data!['success'],
          null,
        );
      } else {
        throw APIResponse(
          "Something Went Wrong!",
          false,
          null,
        );
      }
    }
  }

  Future<APIResponse<User>> updateUser(User data, int id) async {
    try {
      String url = 'user/$id/';

      Map params = json.decode(jsonEncode(data));
      params.removeWhere((key, value) => key == 'password');

      Response<Map> response = await dio.put(url, data: jsonEncode(params));

      // Map<String, dynamic> res = response.data!['data'];
      // res['access'] = data.access;
      // res['refresh'] = data.refresh;

      SecureStorageService().writeData("auth", jsonEncode(data));

      return APIResponse(
        response.data!['message'],
        response.data!['success'],
        User.fromJson(
          data.toJson(),
        ),
      );
    } catch (e) {
      print(e);
      if (e is DioError) {
        throw APIResponse(
          e.response!.data!['message'],
          e.response!.data!['success'],
          null,
        );
      } else {
        throw APIResponse(
          "Something Went Wrong!",
          false,
          null,
        );
      }
    }
  }
}

List getLastNameFirstName(String fullName) {
  // String name = fullName;
  String lastName = "";
  String firstName = "";
  // if (name.split("\\w+").length > 1) {
  //   lastName = name.substring(name.lastIndexOf(" ") + 1);
  //   firstName = name.substring(0, name.lastIndexOf(' '));
  // } else {
  //   firstName = name;
  // }
  // print(name +" name");
  // print(firstName);
  // print(lastName);

  final splitted = fullName.split(' ');

  lastName = splitted.last;

  splitted.asMap().forEach((index, value) {
    if (index != splitted.length - 1) {
      firstName += value + " ";
    }
  });

  return [firstName, lastName];
}
