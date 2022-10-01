import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lako_app/services/secure_storage_service.dart';
import 'package:lako_app/utils/globals.dart' as globals;

class DioConf {
  late String baseUrl;
  late String token;
  // late Dio dio;

  DioConf() {
    baseUrl = globals.base_url;
    token = globals.token;
    print(globals.base_url + 'serv');
  }

  // Dio dioCon() {
  //   Dio dio;
  //   // String token = globals.token;
  //   dio = Dio(options());
  //   return dio;
  // }

  BaseOptions options() => BaseOptions(
        baseUrl: baseUrl,
        // headers: {"Authorization": "Bearer $token}"},
        // headers: {
        //   "Authorization":
        //       "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjY0MTYyNzA5LCJpYXQiOjE2NjQwNzYzMDksImp0aSI6IjFkNTI4NDBjNWJlOTQ2MGViZWFiM2UwOTdjNmUwYzU4IiwidXNlcl9pZCI6OH0.HRZv_ogBGfzVzudIDBmvvUisoyimxhtfFeiv2J0TCDU"
        // },
        contentType: 'application/json',
        receiveDataWhenStatusError: true,
        connectTimeout: 60 * 1000, // 60 seconds
        receiveTimeout: 60 * 1000, // 60 seconds
      );

  Interceptor dioInterCeptor(Dio dio) => InterceptorsWrapper(
        onRequest: (request, handler) async {
          // if (token != '') {
          String? access = await SecureStorageService().readData('token');
          if (access != null) {
            print(access + 'access toem');
            request.headers['Authorization'] = 'Bearer $access';
          }
          // }
          return handler.next(request);
        },
      );
}
