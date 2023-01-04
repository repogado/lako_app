import 'package:flutter/material.dart';
import 'package:lako_app/providers/notification_provider.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<NotificationProvider>(context, listen: false)
          .readNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(_notificationProvider.notifications.length,
              (index) {
            return ListTile(
              leading: Icon(
                Icons.storefront_sharp,
                size: 50,
              ),
              title: Text(_notificationProvider.notifications[index].title),
              subtitle:
                  Text(_notificationProvider.notifications[index].subTitle),
            );
          }),
        ),
      ),
      // drawer: MyDrawer().drawer(context, 'notification'),
    );
  }
}
