// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:StreamTheVote/models/location.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/storage.dart';
import '../models/state_.dart';
import '../models/county.dart';
import '../models/city.dart';

class StateApiService {
  static Future<void> fetchStates(Storage storage) async {
    String ip_port = storage.api_ip!; // ! assert not null - it is pulled from .env
    String stateApiUrl = '$ip_port/states/';
    try {
      final response = await http.get(Uri.parse(stateApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        StateList_ states = StateList_(jsonData.map((stateJson) => State_.fromJson(stateJson)).toList());
        storage.stateList.setList_ = states;
      } else {
        storage.updateStates(StateList_([]));
        if (kDebugMode) {
          print('Failed to load states.');
        }
      }
    } catch (e) {
      storage.updateStates(StateList_([]));
      if (kDebugMode) {
        print('Error fetching states: $e');
      }
    }
  }
}

class CountyApiService {
  static Future<void> fetchCounties(Storage storage) async {
    String ip_port = storage.api_ip!; // ! assert not null - it is pulled from .env
    String countyApiUrl = '$ip_port/counties/';
    try {
      final response = await http.get(Uri.parse(countyApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        Map<int, List<County>> countiesByState = {};
        for (var countyJson in jsonData) {
          County county = County.fromJson(countyJson);
          if (!countiesByState.containsKey(county.stateId)) {
            countiesByState[county.stateId] = [];
          }
          countiesByState[county.stateId]?.add(county);
        }
        storage.setCountiesByState(countiesByState);
      } else {
        if (kDebugMode) {
          print('Failed to load counties');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching counties: $e');
      }
    }
  }
}

class CityApiService {
  static Future<void> fetchCities(Storage storage) async {
    String ip_port = storage.api_ip!; // ! assert not null - it is pulled from .env
    String cityApiUrl = '$ip_port/cities/';
    try {
      final response = await http.get(Uri.parse(cityApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        Map<int, List<City>> citiesByCounty = {};
        for (var cityJson in jsonData) {
          City city = City.fromJson(cityJson);
          if (!citiesByCounty.containsKey(city.countyId)) {
            citiesByCounty[city.countyId] = [];
          }
          citiesByCounty[city.countyId]?.add(city);
        }
        storage.setCitiesByCounty(citiesByCounty);
      } else {
        if (kDebugMode) {
          print('Failed to load cities');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cities: $e');
      }
    }
  }
}

class LocationApiService {
  static Future<void> fetchLocations(Storage storage) async {
    String ip_port = storage.api_ip!;
    String locationApiUrl = '$ip_port/locations/';
    try {
      final response = await http.get(Uri.parse(locationApiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        Map<int, List<Location>> locationsByCity = {};
        for (var locationJosn in jsonData) {
          Location location = Location.fromJson(locationJosn);
          if (!locationsByCity.containsKey(location.cityId)) {
            locationsByCity[location.cityId] = [];
          }
          locationsByCity[location.cityId]?.add(location);
        }
        storage.setLocationsByCity(locationsByCity);
      } else {
        if (kDebugMode) {
          print('Failed to load locations');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching locations: $e');
      }
    }
  }
}

class ApiService {
  static Future<void> fetchApiData(Storage storage) async {
    String ip_port = storage.api_ip!; // ! assert not null - it is pulled from .env
    String apiUrl = '$ip_port/hello';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      //final response = await http.get(Uri.http('192.168.1.11:8000', 'hello'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('message')) {
          storage.setApiString(jsonData['message']);
        } else {
          storage.setApiString('Invalid JSON response');
        }
      } else {
        storage.setApiString('Failed to load data');
      }
    } catch (e) {
      storage.setApiString('Error: $e');
    }
  }
}
