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
      body: const Center(
        child: Text('My Page!'),
      ),
      // drawer: MyDrawer().drawer(context, 'notification'),
    );
  }
}
