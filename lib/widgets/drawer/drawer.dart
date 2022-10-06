import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lako_app/services/secure_storage_service.dart';
import 'package:lako_app/widgets/dialogs/loading_dialog.dart';
import 'package:lako_app/widgets/dialogs/yes_no_dialog.dart';
import 'package:restart_app/restart_app.dart';

class MyDrawer {
  Drawer drawer(BuildContext context, String route, String? name, String? type,
      String? photoUrl) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      photoUrl!.isEmpty
                          ? "https://cdn-icons-png.flaticon.com/512/149/149071.png"
                          : photoUrl,
                    ),
                    radius: 40,
                  ),
                  SizedBox(height: 15),
                  Text(
                    name!,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    type!,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          _menuItem(
              "My Location", context, route, "home", Icons.location_on_rounded),
          // _menuItem("Chat", context, route, "chat", Icons.message),
          _menuItem("Notification", context, route, "notification",
              Icons.notifications_rounded),
          _menuItem("Contact Us", context, route, "contact_us", Icons.phone),
          _menuItem("About Us", context, route, "about_us", Icons.info_outline),
          _menuItem("Settings", context, route, "settings", Icons.settings),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            selectedColor: Theme.of(context).primaryColor,
            title: Text("Logout"),
            onTap: () {
              showYesNoDialog(
                  context, "Logout", "Are you sure you want to Logout?",
                  () async {
                GoogleSignIn _googleSignIn = GoogleSignIn();
                await _googleSignIn.signOut();
                await SecureStorageService().deleteData("auth");
                await SecureStorageService().deleteData("token");
                Restart.restartApp();
              });
              // Navigator.pop(context);
              //               SecureStorageService().writeData("auth", jsonEncode(res));
              // SecureStorageService().writeData("token", res['access']);
            },
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, BuildContext context, String route,
      String routeName, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      selected: route == routeName,
      selectedColor: Theme.of(context).primaryColor,
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (route != routeName) {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     '/$routeName', (Route<dynamic> routes) => false);
          Navigator.of(context).pushNamed('/$routeName');
        }
      },
    );
  }
}
