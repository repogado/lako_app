// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  Settings copyWith({
    MapType? mapType,
    String? distanceUnits,
    bool? notification,
    double? radius,
  }) {
    return Settings(
      mapType: mapType ?? this.mapType,
      distanceUnits: distanceUnits ?? this.distanceUnits,
      notification: notification ?? this.notification,
      radius: radius ?? this.radius,
    );
  }
}
