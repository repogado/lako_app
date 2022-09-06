import 'package:flutter/material.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({ Key? key }) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Us")),
      body: const Center(
        child: Text('My Page!'),
      ),
      drawer: MyDrawer().drawer(context, 'contact_us'),
    );
  }
}