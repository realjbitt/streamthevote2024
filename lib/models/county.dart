// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'storage.dart';
import 'city.dart';

class County {
  final int id;
  final String name;
  final int stateId;

  County({required this.id, required this.name, required this.stateId});

  factory County.fromJson(Map<String, dynamic> json) {
    return County(
      id: json['id'],
      name: json['name'],
      stateId: json['state_id'],
    );
  }

  LatLng CountyLatLonAvg(Storage storage, int countyId) {
    double latsum = 0;
    double lonsum = 0;
    double totalLocations = 0;

    for (var city in storage.citiesByCounty[countyId]!) {
      for (var location in storage.locationsByCity[city.id]!) {
        latsum += location.lat;
        lonsum += location.lon;
        totalLocations += 1;
      }
    }

    return LatLng(latsum / totalLocations, lonsum / totalLocations);
  }
}

class CountyListWidget extends StatelessWidget {
  final int stateId;
  final Storage storage;

  const CountyListWidget({super.key, required this.stateId, required this.storage});

  @override
  Widget build(BuildContext context) {
    if (storage.countiesByState.containsKey(stateId)) {
      return Column(
        children: storage.countiesByState[stateId]!.map((county) {
          return ExpansionTile(
            key: Key(county.id.toString()),
            title: Text(
              county.name,
              style: const TextStyle(color: Colors.black),
              textScaler: const TextScaler.linear(1.25),
            ),
            // leading: Text(county.id.toString()),
            backgroundColor: Colors.blue[100],
            collapsedBackgroundColor: Colors.blue[100],
            onExpansionChanged: (value) {
              storage.mapProperties.updateLocation(county.CountyLatLonAvg(storage, county.id), 9.5);
            },
            children: [
              CityListWidget(countyId: county.id, storage: storage),
            ],
          );
        }).toList(),
      );
    } else {
      return const ListTile(
        title: Text('No counties found'),
      );
    }
  }
}
