import 'package:flutter/material.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notification")),
      body: Column(children: [
        ListTile(
          leading: Icon(
            Icons.storefront_sharp,
            size: 50,
          ),
          title: Text("Balot vendor is detected on your device"),
          subtitle: Text("6:00 PM, 1h 23min ago"),
        ),
        ListTile(
          leading: Icon(
            Icons.storefront_sharp,
            size: 50,
          ),
          title: Text("Balot vendor is detected on your device"),
          subtitle: Text("6:00 PM, 1h 23min ago"),
        ),
        ListTile(
          leading: Icon(
            Icons.storefront_sharp,
            size: 50,
          ),
          title: Text("Balot vendor is detected on your device"),
          subtitle: Text("6:00 PM, 1h 23min ago"),
        ),
      ]),
      // drawer: MyDrawer().drawer(context, 'notification'),
    );
  }
}
