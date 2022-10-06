import 'package:dio/dio.dart';

class NotificationService {
  void sendNearbyNotif(String vendorType) async {
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "key=AAAAn4idWW0:APA91bHIF2Mbias94-Nx4oSy3w1R_lm2x3zUbStSPCeNQD2JVl2ThMvOLdVZ724YHrMgJwgKiIHWxUqxIUintGU-R7bN-omCbw-VZa6APfU_HG_NvlYtUwrzIdOKKNqze4aN3NO4yz5i";

    Map data = {
      "to": "/topics/nearbyVendor",
      "notification": {
        "body": "A ${vendorType.toUpperCase()} is Nearby",
        "title": "Vendor Found Nearby"
      }
    };
    await dio.post("https://fcm.googleapis.com/fcm/send", data: data);
  }
}
