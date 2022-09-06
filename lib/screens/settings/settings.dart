import 'package:flutter/material.dart';
import 'package:lako_app/widgets/dialogs/map_mode_dialog.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          ListTile(
            title: Text("My Account"),
            leading: Icon(Icons.person),
          ),
          Divider(),
          _mapMode(),
          Divider(),
          ListTile(
            title: Text("Distance Units"),
            leading: Icon(Icons.social_distance),
          ),
          Divider(),
          ListTile(
            title: Text("Notifications"),
            leading: Icon(Icons.notifications_active),
            // trailing: Switch(
            //   onChanged: toggleSwitch,
            //   value: isSwitched,
            //   activeColor: Colors.blue,
            //   activeTrackColor: Colors.yellow,
            //   inactiveThumbColor: Colors.redAccent,
            //   inactiveTrackColor: Colors.orange,
            // ),
          ),
          Divider(),
        ],
      ),
      drawer: MyDrawer().drawer(context, 'settings'),
    );
  }

  Widget _mapMode() {
    return ListTile(
      title: Text("Map Mode"),
      leading: Icon(Icons.map),
      onTap: (){
        MapModeDialog.showMapModeDialog(context);
      },
    );
  }
}
