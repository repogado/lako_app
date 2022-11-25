import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationService {
  void sendMessage(String message, int receiverId) async {
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "key=AAAAn4idWW0:APA91bHIF2Mbias94-Nx4oSy3w1R_lm2x3zUbStSPCeNQD2JVl2ThMvOLdVZ724YHrMgJwgKiIHWxUqxIUintGU-R7bN-omCbw-VZa6APfU_HG_NvlYtUwrzIdOKKNqze4aN3NO4yz5i";

    Map data = {
      "to": "/topics/$receiverId",
      "notification": {"body": message, "title": "New Message"}
    };
    await dio.post("https://fcm.googleapis.com/fcm/send", data: data);
  }

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

  void sendNotifFavorites(String userId) async {
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers["Authorization"] =
        "key=AAAAn4idWW0:APA91bHIF2Mbias94-Nx4oSy3w1R_lm2x3zUbStSPCeNQD2JVl2ThMvOLdVZ724YHrMgJwgKiIHWxUqxIUintGU-R7bN-omCbw-VZa6APfU_HG_NvlYtUwrzIdOKKNqze4aN3NO4yz5i";
    List<String> ids = await getAllFavoriteIds(userId);
    ids.forEach((element) async {
      Map data = {
        "to": "/topics/$element",
        "notification": {
          "body": "One of your favorite vendors in online nearby",
          "title": "Favorite Vendor Found Nearby"
        }
      };
      await dio.post("https://fcm.googleapis.com/fcm/send", data: data);
    });
  }

  Future<List<String>> getAllFavoriteIds(String userId) async {
    List<String> allIds = [];

    DatabaseReference ref2 = FirebaseDatabase.instance.ref("lako/favorites/");
    final snapshot = await ref2.get();
    Map<dynamic, dynamic>? values = snapshot.value as Map?;
    values!.forEach((key, value) {
      Map<dynamic, dynamic>? ids = value as Map?;
      ids!.forEach((key2, value) {
        if (key2 == userId) {
          allIds.add(key);
        }
      });
    });
    return allIds;
  }
}
