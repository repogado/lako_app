import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/providers/settings_provider.dart';
import 'package:lako_app/utils/calc_radius.dart';
import 'package:lako_app/widgets/buttons/def_button.dart';
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
                    if (customerMarker != null) customerMarker!,
                  }),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _settingsProvider.locationData.latitude!,
                      _settingsProvider.locationData.longitude!,
                    ),
                    zoom: getZoomLevel(35.0),
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
                      onPress: () {
                        _authProvider.setVendorOnlineOffline(context);
                      },
                      title: _authProvider.isVendorOnline
                          ? "GO OFFLINE"
                          : "GO ONLINE",
                    ),
                  ),
                ),
              ],
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
