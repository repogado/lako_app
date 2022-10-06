import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lako_app/models/notification.dart';
import 'package:lako_app/services/secure_storage_service.dart';
import 'package:intl/intl.dart';

class NotificationProvider with ChangeNotifier {
  late List<NotificationData> _notifications;

  List<NotificationData> get notifications => _notifications;

  NotificationProvider() {
    _notifications = [];
  }

  void saveNotification(String title) {
    DateTime now = DateTime.now();
    String dateFormat = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    NotificationData notif = NotificationData(title, dateFormat.toString());
    _notifications.add(notif);
    String data = jsonEncode(_notifications);
    SecureStorageService().writeData('notifications', data);
    notifyListeners();
  }

  void readNotifications() async {
    String? data = await SecureStorageService().readData('notifications');
    if (data != null) {
      List res = jsonDecode(data);
      List<NotificationData> notifs =
          res.map((e) => NotificationData.fromJson(e)).toList();
      _notifications = notifs;
    }
    notifyListeners();
  }
}
