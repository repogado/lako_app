import 'package:flutter/material.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Screen")),
      body: const Center(
        child: Text('Chat Here'),
      ),
      // drawer: MyDrawer().drawer(context, 'chat'),
    );
  }
}
