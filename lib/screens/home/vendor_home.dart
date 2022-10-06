import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/models/user.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/providers/settings_provider.dart';
import 'package:lako_app/screens/home/transaction_container.dart';
import 'package:lako_app/utils/calc_radius.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
import 'package:lako_app/widgets/dialogs/booking_dialog.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({Key? key}) : super(key: key);

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  Marker? marker;
  Marker? customerMarker;
  bool _loading = true;

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> _mapPolylines = {};
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

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
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context, listen: true);
    _settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
      drawer: MyDrawer().drawer(
        context,
        'home',
        _authProvider.user.firstName! + " " + _authProvider.user.lastName!,
        _authProvider.user.type!,
        _authProvider.user.imgUrl,
      ),
      appBar: AppBar(
        title: Text('${_authProvider.user.vendor}'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
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
                          title: "My Location",
                        ),
                      ),
                  }),
                  // polylines: Set<Polyline>.of(_mapPolylines.values),
                  polylines: Set<Polyline>.of(polylines.values),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _settingsProvider.latLng.latitude,
                      _settingsProvider.latLng.longitude,
                    ),
                    zoom: getZoomLevel(35.0),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    // _settingsProvider.controller.complete(controller);
                    _settingsProvider.setGoogleMapController(controller);
                    _listenLocation();
                    _listenCustomerBookings();
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: DefButton(
                      onPress: () {
                        _authProvider.setVendorOnlineOffline(
                            context, _settingsProvider.latLng);
                      },
                      title: _authProvider.isVendorOnline
                          ? "GO OFFLINE"
                          : "GO ONLINE",
                    ),
                  ),
                ),
                if (_authProvider.connectedUser.id != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TransactionContainer(
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
      _settingsProvider.onLocationChange(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      _authProvider.setUserLocation(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
    });
  }

  void _listenCustomerBookings() {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("lako/onlineVendors/${_authProvider.user.id}");
    ref.onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.exists) {
        if (_authProvider.isVendorOnline) {
          final data = event.snapshot.value as Map;
          if (data['customer_id'] != null &&
              data['customer_id'] != "" &&
              data['status'] == 'waiting') {
            print(data['customer_id']);
            final ref1 = FirebaseDatabase.instance.ref();

            final snapshot2 =
                await ref1.child('lako/users/${data['customer_id']}').get();
            print(snapshot2.value);

            Map<String, dynamic>? value =
                jsonDecode(jsonEncode(snapshot2.value))
                    as Map<String, dynamic>?;
            User user = User.fromJson(value!);
            if (_authProvider.connectedUser.id == null) {
              showBookingDIalog(context, () async {
                _authProvider.setConnectedUser(user);

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
                _addPolyLine();
                Navigator.pop(context);
              }, () {});
            } else {}
          }
        }
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

  void _listenCustomerChanges() {}
}
