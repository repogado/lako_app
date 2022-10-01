import 'dart:math';

double calcRadius(double radius) {
  double rs = 0;

  if (radius == 0.3) {
    rs = 20;
  } else if (radius == 0.5) {
    rs = 35;
  } else if (radius == 1) {
    rs = 45;
  } else if (radius == 2) {
    rs = 55;
  } else {
    rs = 65;
  }
  return rs;
}

getZoomLevel(radius) {
  double rs = calcRadius(radius);
  double zoomLevel = 11;
  if (radius > 0) {
    double radiusElevated = rs + rs / 2;
    double scale = radiusElevated / 500;
    zoomLevel = 16 - log(scale) / log(2);
  }
  zoomLevel = double.parse(zoomLevel.toStringAsFixed(2));
  return zoomLevel;
}
