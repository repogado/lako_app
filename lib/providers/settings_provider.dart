import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lako_app/models/settings.dart';

class SettingsProvider with ChangeNotifier{
  late Settings _settings;

  Settings get settings => _settings;

  SettingsProvider(){
    _settings = Settings(
      mapType: MapType.normal,
      distanceUnits: "miles",
      notification: true,
      radius: 50,
    );
    notifyListeners();
  }
}
