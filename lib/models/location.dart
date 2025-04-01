// ignore_for_file: non_constant_identifier_names
import 'storage.dart';

class Location {
  final int id;
  final int cityId;
  final String address;
  final String boxType;
  final double lat;
  final double lon;
  final String strmUrl;
  final String othrUrl;
  final String description;
  final String notes;

  Location(
      {required this.id,
      required this.address,
      required this.cityId,
      required this.boxType,
      required this.lat,
      required this.lon,
      required this.strmUrl,
      required this.othrUrl,
      required this.description,
      required this.notes});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      address: json['address'],
      cityId: json['city_id'],
      boxType: json['boxType'],
      lat: json['lat'],
      lon: json['lon'],
      strmUrl: json['strmUrl'],
      othrUrl: json['othrUrl'],
      description: json['description'],
      notes: json['notes'],
    );
  }
}

class LocaitonLatLonMarkerList {
  List<Map<String, dynamic>> _locationsLatLons = [];

  List<Map<String, dynamic>> get locationLatLons => _locationsLatLons;

  // pull all the locations loaded from API,
  // then create new list of lat/lon for markers
  List<Map<String, dynamic>> loadLocaitonValues(Storage storage) {
    List<Map<String, dynamic>> listOfLocationLatLons = [];

    storage.locationsByCity.forEach(
      (city_id, locationList) {
        for (var location in locationList) {
          listOfLocationLatLons.add({
            'lat': location.lat,
            'lng': location.lon,
            'id': location.id,
            'address': location.address,
            'cityId': location.cityId,
            'boxType': location.boxType,
            'strmUrl': location.strmUrl,
            'othrUrl': location.othrUrl,
            'description': location.description
          });
        }
      },
    );

    _locationsLatLons = listOfLocationLatLons;
    return listOfLocationLatLons;
  }
}
