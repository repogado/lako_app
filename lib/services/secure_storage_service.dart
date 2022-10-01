import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService{
  Future<bool> writeData(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
    return true;
  }

  Future<String?> readData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? str = prefs.getString(key);
    return str;
  }

  Future<void> deleteData(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}