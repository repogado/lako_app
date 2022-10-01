import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/models/settings.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/providers/settings_provider.dart';
import 'package:lako_app/screens/home/transaction_container.dart';
import 'package:lako_app/utils/calc_radius.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/finding_vendor.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Marker? marker;
  Circle? circle;
  bool _loading = true;
  List<Marker> _markers = [];

  late SettingsProvider _settingsProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      SettingsProvider _tempSettingsProvider =
          Provider.of<SettingsProvider>(context, listen: false);

      _serviceEnabled = await _tempSettingsProvider.location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _tempSettingsProvider.location.serviceEnabled();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await _tempSettingsProvider.location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted =
            await _tempSettingsProvider.location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _tempSettingsProvider.location.enableBackgroundMode(enable: true);

      LocationData locaData = await _tempSettingsProvider.initLocationData();
      _setMarkers(LatLng(locaData.latitude!, locaData.longitude!));
      setState(() {
        _loading = false;
      });
    });
  }

  void _setMarkers(LatLng locdata) {
    marker = Marker(
      markerId: MarkerId('loc'),
      position: LatLng(
        locdata.latitude,
        locdata.longitude,
      ),
      infoWindow: InfoWindow(
        title: "My Location",
      ),
    );
    circle = Circle(
      circleId: CircleId('locc'),
      center: LatLng(
        locdata.latitude,
        locdata.longitude,
      ),
      fillColor: Colors.blue.shade100.withOpacity(0.5),
      strokeColor: Colors.blue.shade100.withOpacity(1),
      strokeWidth: 2,
      radius: getZoomLevel(_settingsProvider.settings.radius),
    );
  }

  double getZoomLevel(double radius) {
    double zoomLevel = 11;
    if (radius > 0) {
      double radiusElevated = radius + radius / 2;
      double scale = radiusElevated / 500;
      zoomLevel = 16 - log(scale) / log(2);
    }
    zoomLevel = double.parse(zoomLevel.toStringAsFixed(2));
    return zoomLevel;
  }

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Location"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/vendor_selection');
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: _settingsProvider.settings.mapType,
                  markers: Set.of({
                    ..._markers,
                    if (marker != null) marker!,
                  }),
                  circles: Set.of({
                    Circle(
                      circleId: CircleId('locc'),
                      center: LatLng(_settingsProvider.latLng.latitude,
                          _settingsProvider.latLng.longitude),
                      fillColor: Colors.blue.shade100.withOpacity(0.5),
                      strokeColor: Colors.blue.shade100.withOpacity(1),
                      strokeWidth: 2,
                      radius: calcRadius(_settingsProvider.settings.radius),
                    )
                  }),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _settingsProvider.locationData.latitude!,
                      _settingsProvider.locationData.longitude!,
                    ),
                    zoom: getZoomLevel(35),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    // _settingsProvider.controller.complete(controller);
                    _settingsProvider.setGoogleMapController(controller);
                    _listenLocation();
                  },
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.all(20),
                //     child: DefButton(
                //         onPress: () {
                //           showFindingDialog(context,
                //               "Finding ${_settingsProvider.settings.vendor}",
                //               () {
                //             Navigator.pop(context);
                //           });
                //         },
                //         title: "FIND ${_settingsProvider.settings.vendor}"),
                //   ),
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: TransactionContainer(),
                  ),
                )
              ],
            ),
      drawer: MyDrawer().drawer(
        context,
        'home',
        _authProvider.user.firstName! + " " + _authProvider.user.lastName!,
        _authProvider.user.type!,
        _authProvider.user.imgUrl,
      ),
    );
  }

  void _listenLocation() {
    _settingsProvider.location.onLocationChanged
        .listen((LocationData currentLocation) {
      _setMarkers(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      _settingsProvider.onLocationChange(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      // setState(() {});
      // _latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      // Use current location
    });
  }
}
