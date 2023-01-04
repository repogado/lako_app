import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/models/notification.dart';
import 'package:lako_app/models/settings.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/providers/notification_provider.dart';
import 'package:lako_app/providers/settings_provider.dart';
import 'package:lako_app/screens/home/transaction_container.dart';
import 'package:lako_app/utils/calc_radius.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/finding_vendor.dart';
import 'package:lako_app/widgets/dialogs/info_dialog.dart';
import 'package:lako_app/widgets/dialogs/rating_dialog.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({Key? key}) : super(key: key);

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  Marker? marker;
  Marker? vendorMarker;
  Circle? circle;
  bool _loading = true;
  List<Marker> _markers = [];

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  late SettingsProvider _settingsProvider;
  late AuthProvider _authProvider;
  late NotificationProvider _notificationProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // await FirebaseMessaging.instance.subscribeToTopic('nearbyVendor');
      _listenForeground();
      _listenBackground();
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
      // _setMarkers(_tempSettingsProvider.latLng);
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

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      _notificationProvider.saveNotification(notification!.body!);
      if (message.notification != null) {
        _settingsProvider.showNotification(
          notification.hashCode,
          notification.title,
          notification.body,
        );
      }
    });
  }

  void _listenBackground() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Restart.restartApp();
      print('Got a message whilst in the Background!');
    });
  }

  @override
  Widget build(BuildContext context) {
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
    _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
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
      body: _settingsProvider.mapLoading && _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                GoogleMap(
                  mapType: _settingsProvider.settings.mapType,
                  markers: Set.of({
                    if (marker != null) marker!,
                    if (_authProvider.connectedUser.id != null)
                      Marker(
                        markerId: MarkerId('loc2'),
                        position: LatLng(
                          double.parse(_authProvider.connectedUser.latitude!),
                          double.parse(_authProvider.connectedUser.longitude!),
                        ),
                        infoWindow: InfoWindow(
                          title: _authProvider.user.type == 'customer'
                              ? 'Customer Location'
                              : 'Vendor Location',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueGreen),
                      ),
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
                      _settingsProvider.latLng.latitude,
                      _settingsProvider.latLng.longitude,
                    ),
                    zoom: getZoomLevel(35),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    // _settingsProvider.controller.complete(controller);
                    _settingsProvider.setGoogleMapController(controller);
                    _listenLocation();
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: DefButton(
                        onPress: () async {
                          int? id = await _authProvider.findVendor(
                              context, _settingsProvider.settings.vendor);
                          if (id != null) {
                            _listenToVendor(id);
                            showFindingDialog(context,
                                "Finding ${_settingsProvider.settings.vendor}",
                                () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        title: "FIND ${_settingsProvider.settings.vendor}"),
                  ),
                ),
                if (_authProvider.connectedUser.id != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TransactionContainer(
                      userType: _authProvider.user.type!,
                      customer: _authProvider.user.type == 'customer'
                          ? _authProvider.user
                          : _authProvider.connectedUser,
                      vendor: _authProvider.user.type == 'vendor'
                          ? _authProvider.user
                          : _authProvider.connectedUser,
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
      print(currentLocation.latitude!.toString() +
          " " +
          currentLocation.longitude!.toString());
      _setMarkers(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      _authProvider.setUserLocation(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      _settingsProvider.onLocationChange(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      // setState(() {});
      // _latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      // Use current location
    });
  }

  void _listenToVendor(int id) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("lako/onlineVendors/$id");
    ref.onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map;
        if (data['status'] == 'confirmed') {
          final ref1 = FirebaseDatabase.instance.ref();
          final snapshot2 = await ref1.child('lako/users/$id').get();
          Map<String, dynamic>? value =
              jsonDecode(jsonEncode(snapshot2.value)) as Map<String, dynamic>?;
          User user = User.fromJson(value!);

          _authProvider.updateConnectedUserLocation(
            user.latitude!,
            user.longitude!,
          );
          polylineCoordinates = await _settingsProvider.drawPolyline(
            PointLatLng(
              double.parse(_authProvider.user.latitude!),
              double.parse(_authProvider.user.longitude!),
            ),
            PointLatLng(
              double.parse(user.latitude!),
              double.parse(user.longitude!),
            ),
          );
          if (_authProvider.connectedUser.id == null) {
            _authProvider.setConnectedUser(user);
            Navigator.pop(context);
            _addPolyLine();
          }
        } else if (data['status'] == 'cancelled') {
          ref.remove();
        } else if (data['status'] == 'completed') {
          if (_authProvider.connectedUser.id != null) {
            _authProvider.setConnectedUser(User());
            ref.remove();
            // showRatingDialog(context, (rating) {
            //   print(rating);
            // });
          }
        }
      } else {
        ref.remove();
      }
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
    _settingsProvider
        .animateCameraBetweenPoints(Set<Polyline>.of(polylines.values));
    setState(() {});
  }
}
