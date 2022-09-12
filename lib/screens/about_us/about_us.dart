import 'package:flutter/material.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Us")),
      body: const Center(
        child: Text('My Page!'),
      ),
      // drawer: MyDrawer().drawer(context, 'about_us'),
    );
    ;
  }
}
