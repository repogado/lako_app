
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Settings {
  final MapType mapType;
  final String distanceUnits;
  final bool notification;
  final double radius;
  final String vendor;

  Settings({
    required this.mapType,
    required this.distanceUnits,
    required this.notification,
    required this.radius,
    required this.vendor,
  });

  Settings copyWith({
    MapType? mapType,
    String? distanceUnits,
    bool? notification,
    double? radius,
    String? vendor,
  }) {
    return Settings(
      mapType: mapType ?? this.mapType,
      distanceUnits: distanceUnits ?? this.distanceUnits,
      notification: notification ?? this.notification,
      radius: radius ?? this.radius,
      vendor: vendor ?? this.vendor,
    );
  }
}
