import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
      radius: 20,
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

  void goToCurrentLocation() {
    _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(_latLng, getZoomLevel(_settings.radius)));
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

    if (_mapLoading == true) {
      _mapLoading = false;
    }
    notifyListeners();
  }

  void onCompleteMapController() {}

  void animateCameraBetweenPoints(Set<Polyline> p) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });

    _googleMapController.moveCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong)),
        150));
  }

  Future<List<LatLng>> drawPolyline(
      PointLatLng pointLatLng1, PointLatLng pointLatLng2) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyAWgeJgClIi-S2kxlHUXT-RTldUYO82mN0", pointLatLng1, pointLatLng2);
    List<LatLng> polylineCoordinates = [];
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    return polylineCoordinates;
  }

  void showNotification(int id, title, body) async {
    final _notifcation = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    _notifcation.initialize(initializationSettings,
        onSelectNotification: (val) {
      print('restart');
    });
    _notifcation.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: "test",
          importance: Importance.max,
          priority: Priority.max,
          icon: "@mipmap/ic_launcher",
          enableVibration: true,
        ),
      ),
    );
  }

  void onRadiusChanged(double value) {
    _settings = _settings.copyWith(radius: value);
    notifyListeners();
  }
}
