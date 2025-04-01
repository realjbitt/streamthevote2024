import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../models/state_.dart';
import '../models/storage.dart';
import '../widgets/map_animated.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<Storage>(context, listen: false);

    return Center(
      child: Column(
        children: [
          const MapAnimated(),
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                ExpansionTile(
                  key: const Key("-1"),
                  title: Text(
                    "U.S.A",
                    textScaler: const TextScaler.linear(2.5),
                    style: TextStyle(
                      color: Colors.grey[200],
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  collapsedBackgroundColor: Colors.blue[700],
                  backgroundColor: Colors.blue[700],
                  onExpansionChanged: (value) {
                    storage.mapProperties.updateLocation(const LatLng(37.0902, -95.7129), 3.9);
                  },
                  children: const [],
                ),
                ...storage.stateList.getList.map((state_) => StateListItem(state_: state_, storage: storage)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
