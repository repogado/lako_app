import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lako_app/models/messages.dart';
import 'package:lako_app/services/notification_service.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

TextEditingController _messageController = new TextEditingController(text: "");

class _ChatScreenState extends State<ChatScreen> {
  late AuthProvider _authProvider;

  late DatabaseReference ref;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

      if (_authProvider.user.type == "vendor") {
        ref = FirebaseDatabase.instance
            .ref("lako/onlineVendors/${auth.user.id}/messages");
      } else {
        ref = FirebaseDatabase.instance
            .ref("lako/onlineVendors/${auth.connectedUser.id}/messages");
      }
      final snapshot = await ref.get();
      if (snapshot.exists) {
        final data = jsonDecode(snapshot.value.toString()) as List;

        List<Messages> msgs = [];
        for (var value in data) {
          msgs.add(Messages(value['message'], value['senderId']));
        }
        _authProvider.setMessages(msgs);
      }
      listenToChats();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.remove();
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text("Chat Screen")),
      body: Container(
        child: Column(children: [
          Expanded(
              child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: List.generate(_authProvider.messages.length,
                    (index) => _chatBubble(_authProvider.messages[index])),
              ),
            ),
          )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 1, color: Colors.grey))),
            child: Row(
              children: [
                Flexible(
                    child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message here',
                  ),
                )),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    // _authProvider.addMessage(Messages(_messageController.text, _authProvider.))
                    List<Messages> msgs = _authProvider.messages;
                    msgs.add(Messages(_messageController.text,
                        _authProvider.user.id.toString()));
                    await ref.set(msgs.map((e) => e.toJson()).toList());
                    NotificationService().sendMessage(_messageController.text,
                        _authProvider.connectedUser.id!);
                    setState(() {
                      _messageController.text = "";
                    });
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          )
        ]),
      ),
      // drawer: MyDrawer().drawer(context, 'chat'),
    );
  }

  void listenToChats() {
    ref.onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        print(event.snapshot.value);

        final data = jsonDecode(event.snapshot.value.toString()) as List;
        print(data);
        List<Messages> msgs = [];
        for (var value in data) {
          msgs.add(Messages(value['message'], value['senderId']));
        }
        _authProvider.setMessages(msgs);
        // print(messages.map((e) => e.toJson()).toList());
      } // Messages mg = Messages.fromJson('');
    });
  }

  Widget _chatBubble(Messages messages) {
    return _authProvider.user.id.toString() == messages.senderId
        ? Container(
            margin: EdgeInsets.only(right: 15, top: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    messages.message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(left: 15, top: 10),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(minWidth: 100, maxWidth: 300),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(messages.message),
                ),
              ],
            ),
          );
  }
}
