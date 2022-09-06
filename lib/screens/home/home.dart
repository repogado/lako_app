import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/widgets/drawer/drawer.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location location = new Location();
  LatLng _latLng = LatLng(37.42796133580664, -122.085749655962);
  Completer<GoogleMapController> _controller = Completer();
  late LocationData? _locationData;
  Marker? marker;
  Circle? circle;
  bool _loading = true;
  List<Marker> _markers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location.enableBackgroundMode(enable: true);

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _locationData = await location.getLocation();
      _setMarkers(LatLng(_locationData!.latitude!, _locationData!.longitude!));
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
      radius: 50,
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
    return Scaffold(
      appBar: AppBar(title: Text("My Location")),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.hybrid,
              markers: Set.of({
                ..._markers,
                if (marker != null) marker!,
              }),
              circles: Set.of({circle!}),
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _locationData!.latitude!,
                  _locationData!.longitude!,
                ),
                zoom: getZoomLevel(50),
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _listenLocation();
              },
            ),
      drawer: MyDrawer().drawer(
        context,
        'home',
      ),
    );
  }

  void _listenLocation() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      print(_latLng.latitude.toString() + " " + _latLng.longitude.toString());
      _setMarkers(
          LatLng(currentLocation.latitude!, currentLocation.longitude!));
      // setState(() {});
      // _latLng = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      // Use current location
    });
  }
}
