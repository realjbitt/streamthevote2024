// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'storage.dart';

class City {
  final int id;
  final String name;
  final int countyId;

  City({required this.id, required this.name, required this.countyId});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      countyId: json['county_id'],
    );
  }

  LatLng CityLatLonAvg(Storage storage, int cityId) {
    double latsum = 0;
    double lonsum = 0;
    double totalLocations = 0;

    for (var location in storage.locationsByCity[cityId]!) {
      latsum += location.lat;
      lonsum += location.lon;
      totalLocations += 1;
    }

    return LatLng(latsum / totalLocations, lonsum / totalLocations);
  }
}

class CityListWidget extends StatelessWidget {
  final int countyId;
  final Storage storage;

  const CityListWidget({super.key, required this.countyId, required this.storage});

  @override
  Widget build(BuildContext context) {
    if (storage.citiesByCounty.containsKey(countyId)) {
      return Column(
        children: storage.citiesByCounty[countyId]!.map((city) {
          return Container(
            color: Colors.blueGrey[100],
            child: ListTile(
              title: Text(
                city.name,
                style: const TextStyle(color: Colors.black),
              ),
              // subtitle: Text('ID: ${city.id}'),
              onTap: () {
                storage.mapProperties.updateLocation(city.CityLatLonAvg(storage, city.id), 13);
              },
            ),
          );
        }).toList(),
      );
    } else {
      return const ListTile(
        title: Text('No cities found'),
      );
    }
  }
}
