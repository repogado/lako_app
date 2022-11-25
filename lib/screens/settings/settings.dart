import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/providers/settings_provider.dart';
import 'package:lako_app/widgets/dialogs/distance_selection_dialog.dart';
import 'package:lako_app/widgets/dialogs/map_mode_dialog.dart';
import 'package:lako_app/widgets/dialogs/radius_selection_dialog.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';
import 'package:provider/provider.dart';

import '../../utils/extensions.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsProvider _settingsProvider;
  late AuthProvider _authProvider;
  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          ListTile(
            title: Text("My Account"),
            leading: Icon(Icons.person),
            onTap: () {
              Navigator.pushNamed(context, "/myaccount");
            },
          ),
          Divider(),
          _mapMode(),
          if (_authProvider.user.type == "customer") Divider(),
          if (_authProvider.user.type == "customer") _distanceUnits(),
          Divider(),
          ListTile(
            title: Text("Notifications"),
            leading: Icon(Icons.notifications_active),
            trailing: Switch(
              onChanged: (val) {
                _settingsProvider.setNotification(val);
              },
              value: _settingsProvider.settings.notification,
            ),
          ),
          if (_authProvider.user.type == "customer") Divider(),
          if (_authProvider.user.type == "customer") _radius(),
        ],
      ),
      // drawer: MyDrawer().drawer(context, 'settings'),
    );
  }

  Widget _mapMode() {
    return ListTile(
      title: Text("Map Mode"),
      leading: Icon(Icons.map),
      trailing: Text(_settingsProvider.settings.mapType
          .toString()
          .replaceAll("MapType.", "")
          .capitalizeFirst()),
      onTap: () {
        MapModeDialog.showMapModeDialog(context, (MapType type) {
          _settingsProvider.setMapType(type);
        });
      },
    );
  }

  Widget _distanceUnits() {
    return ListTile(
      title: Text("Distance Units"),
      leading: Icon(Icons.social_distance),
      trailing: Text(_settingsProvider.settings.distanceUnits),
      onTap: () {
        DistanceSelectionDialog.showDistanceSelectionDialog(context,
            (String distance) {
          _settingsProvider.setDistance(distance);
        });
      },
    );
  }

  Widget _radius() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.circle_outlined),
          SizedBox(width: 30),
          Text("Radius"),
          SizedBox(width: 50),
          Expanded(
            child: Slider(
              value: _settingsProvider.settings.radius,
              max: 20,
              divisions: 5,
              label: _settingsProvider.settings.radius.toString(),
              onChanged: (double value) {
                print(value);
                _settingsProvider.onRadiusChanged(value);
                // setState(() {
                //   _currentSliderValue = value;
                // });
              },
            ),
          ),
        ],
      ),
    );
    // return ListTile(
    //   title: Text("Radius"),
    //   leading: Icon(Icons.circle_outlined),
    //   // trailing: Text(_settingsProvider.settings.radius.toString()),
    //   trailing: Slider(
    //     value: _settingsProvider.settings.radius,
    //     max: 20,
    //     divisions: 5,
    //     label: _settingsProvider.settings.radius.toString(),
    //     onChanged: (double value) {
    //       // setState(() {
    //       //   _currentSliderValue = value;
    //       // });
    //     },
    //   ),
    //   onTap: () {
    //     RadiusSelectionDialog.showRadiusSelectionDialog(context,
    //         (double radius) {
    //       _settingsProvider.setRadius(radius);
    //     });
    //   },
    // );
  }
}
