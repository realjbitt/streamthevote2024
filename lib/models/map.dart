import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class MapProperties with ChangeNotifier {
  LatLng mapZoomLocaiton_ = const LatLng(0, 0);
  double mapZoomLevel_ = 5;

  LatLng get mapZoomLocation => mapZoomLocaiton_;
  double get mapZoomLevel => mapZoomLevel_;

  void updateLocation(LatLng newLocation, double newZoom) {
    mapZoomLocaiton_ = newLocation;
    mapZoomLevel_ = newZoom;
    notifyListeners();
  }
}
