import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/models/settings.dart';
import 'package:lako_app/providers/auth_provider.dart';
import 'package:lako_app/utils/calc_radius.dart';
import 'package:location/location.dart';

class SettingsProvider with ChangeNotifier {

  late Settings _settings;

  // Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _googleMapController;

  late Location _location;

  late LocationData _locationData;

  late LatLng _latLng;

  bool _mapLoading = true;

  Settings get settings => _settings;
  GoogleMapController get googleMapControler => _googleMapController;
  Location get location => _location;
  LocationData get locationData => _locationData;
  LatLng get latLng => _latLng;
  bool get mapLoading => _mapLoading;

  SettingsProvider() {
    _settings = Settings(
      mapType: MapType.normal,
      distanceUnits: "miles",
      notification: true,
      radius: 0.5,
      vendor: "Fish Vendor",
    );
    _location = Location();
    _latLng = const LatLng(7.066255, 125.616155);
    notifyListeners();
  }

  void setMapType(MapType mapType) {
    _settings = _settings.copyWith(mapType: mapType);
    notifyListeners();
  }

  void setDistance(String distance) {
    _settings = _settings.copyWith(distanceUnits: distance);
    notifyListeners();
  }

  void setNotification(bool notification) {
    _settings = _settings.copyWith(notification: notification);
    notifyListeners();
  }

  void setRadius(double radius) {
    _settings = _settings.copyWith(radius: radius);

    _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(_latLng, getZoomLevel(radius)));
    notifyListeners();
  }

  void setVendor(String vendor) {
    _settings = _settings.copyWith(vendor: vendor);
    notifyListeners();
  }

  void setGoogleMapController(GoogleMapController controller) {
    _googleMapController = controller;
    _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(_latLng, getZoomLevel(_settings.radius)));
  }

  Future<LocationData> initLocationData() async {
    _locationData = await location.getLocation();
    _latLng = LatLng(_locationData.latitude!, _locationData.longitude!);

    notifyListeners();
    return _locationData;
  }

  void onLocationChange(LatLng latLng) async {
    _latLng = latLng;
    // _authProvider!.setUserLocation(latLng);
    if (_mapLoading == true) {
      _mapLoading = false;
    }
    notifyListeners();
  }

  void onCompleteMapController() {}
}
