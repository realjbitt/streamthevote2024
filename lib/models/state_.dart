// ignore_for_file: camel_case_types, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'county.dart';
import 'package:latlong2/latlong.dart';
import 'storage.dart';

class State_ {
  final int id;
  final String name;

  State_({required this.id, required this.name});

  factory State_.fromJson(Map<String, dynamic> json) {
    return State_(
      id: json['id'],
      name: json['name'],
    );
  }
  LatLng StateLatLonAvg(Storage storage, int stateId) {
    double latsum = 0;
    double lonsum = 0;
    double totalLocations = 0;

    for (var county in storage.countiesByState[stateId]!) {
      for (var city in storage.citiesByCounty[county.id]!) {
        for (var location in storage.locationsByCity[city.id]!) {
          latsum += location.lat;
          lonsum += location.lon;
          totalLocations += 1;
        }
      }
    }

    return LatLng(latsum / totalLocations, lonsum / totalLocations);
  }
}

class StateList_ {
  List<State_> stateList_ = [];

  // Constructor that initializes stateList_ with the given list
  StateList_(List<State_> initialStateList) {
    // Optionally, you might want to create a copy to ensure the internal state
    // isn't modified externally after construction
    stateList_ = List.from(initialStateList);
  }

  List<State_> get getList => stateList_; // getter
  set setList(List<State_> states) {
    stateList_ = states; // setter from raw List<State_> = []
  }

  set setList_(StateList_ states) {
    stateList_ = states.stateList_; // setter from existing StateList_
  }
}

class StateListItem extends StatelessWidget {
  final State_ state_;
  final Storage storage;

  const StateListItem({super.key, required this.state_, required this.storage});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: Key(state_.id.toString()),
      title: Text(
        state_.name,
        textScaler: const TextScaler.linear(1.75),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
      collapsedBackgroundColor: Colors.blue[900],
      backgroundColor: Colors.blue[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onExpansionChanged: (value) {
        storage.mapProperties.updateLocation(state_.StateLatLonAvg(storage, state_.id), 6.25);
      },
      children: [
        CountyListWidget(stateId: state_.id, storage: storage),
      ],
    );
  }
}
