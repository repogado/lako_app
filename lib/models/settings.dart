import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Settings {
  final MapType mapType;
  final String distanceUnits;
  final bool notification;
  final double radius;

  Settings({
    required this.mapType,
    required this.distanceUnits,
    required this.notification,
    required this.radius,
});
}
