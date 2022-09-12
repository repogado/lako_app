import 'package:flutter/material.dart';

class MyDrawer {
  Drawer drawer(BuildContext context, String route) {
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
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                radius: 50,
              ),
            ),
          ),
          _menuItem(
              "My Location", context, route, "home", Icons.location_on_rounded),
          _menuItem("Chat", context, route, "chat", Icons.message),
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
              Navigator.pop(context);
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/$routeName', (Route<dynamic> routes) => false);
              // Navigator.of(context).pushNamed('/$routeName');
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
