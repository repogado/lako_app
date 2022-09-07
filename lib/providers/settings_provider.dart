import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/models/settings.dart';

class SettingsProvider with ChangeNotifier {
  late Settings _settings;

  Settings get settings => _settings;

  SettingsProvider() {
    _settings = Settings(
      mapType: MapType.normal,
      distanceUnits: "miles",
      notification: true,
      radius: 0.1,
    );
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

  void setRadius(double radius) {
    _settings = _settings.copyWith(radius: radius);
    notifyListeners();
  }

  void setNotification(bool notification) {
    _settings = _settings.copyWith(notification: notification);
    notifyListeners();
  }
}
