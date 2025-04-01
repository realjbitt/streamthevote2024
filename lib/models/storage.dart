// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'state_.dart';
import 'county.dart';
import 'city.dart';
import 'location.dart';
import 'map.dart';

class Storage with ChangeNotifier {
  // disclaimer overlay
  bool _showCover = true;

  bool get showCover => _showCover;

  void hideCover() {
    _showCover = false;
    notifyListeners();
  }

  void resetCover() {
    _showCover = true;
    notifyListeners();
  }

  // dark mode
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // api hello
  String? api_ip = "";
  String _apiString = 'Loading...';
  String get apiString => _apiString;
  void setApiString(String value) {
    _apiString = value;
    notifyListeners();
  }

  // states
  StateList_ stateList = StateList_([]);
  void updateStates(StateList_ states) {
    stateList.setList_ = states;
    notifyListeners();
  }

  // counties
  Map<int, List<County>> _countiesByState = {};
  Map<int, List<County>> get countiesByState => _countiesByState;
  void setCountiesByState(Map<int, List<County>> counties) {
    _countiesByState = counties;
    notifyListeners();
  }

  // cities
  Map<int, List<City>> _citiesByCounty = {};
  Map<int, List<City>> get citiesByCounty => _citiesByCounty;
  void setCitiesByCounty(Map<int, List<City>> cities) {
    _citiesByCounty = cities;
    notifyListeners();
  }

  // locations
  Map<int, List<Location>> _locationsByCity = {};
  Map<int, List<Location>> get locationsByCity => _locationsByCity;
  void setLocationsByCity(Map<int, List<Location>> locations) {
    _locationsByCity = locations;
    notifyListeners();
  }

  // city marker list
  LocaitonLatLonMarkerList locationLatLonMarkerList = LocaitonLatLonMarkerList();

  // map zoom controller
  MapProperties mapProperties = MapProperties();

  // map controller
  MapController mapcontroller = MapController();
}
