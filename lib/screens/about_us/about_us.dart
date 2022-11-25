import 'package:flutter/material.dart';
import 'package:lako_app/utils/size_config.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("About Us")),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockSizeVertical * 5,
            horizontal: SizeConfig.blockSizeHorizontal * 10),
        child: Column(
          children: [
            Image.asset(
              "assets/about.png",
              width: 300,
            ),
            SizedBox(height: 20),
            Text(
              'LAKO- App is here to provide you a service in locating local nearby vendors. Featuring a Real-time location of vendors and a chat system for a more efficient way for transactions. ',
              style:
                  TextStyle(fontSize: 22, height: 1.5, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
      // drawer: MyDrawer().drawer(context, 'about_us'),
    );
    ;
  }
}
