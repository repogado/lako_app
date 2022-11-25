import 'dart:math';

double calcRadius(double radius) {
  double rs = 0;

  rs = radius * 150;

  // if (radius == 2) {
  //   rs = 80;
  // } else if (radius == 5) {
  //   rs = 350;
  // } else if (radius == 10) {
  //   rs = 700;
  // } else if (radius == 15) {
  //   rs = 1050;
  // } else {
  //   rs = 2100;
  // }
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
