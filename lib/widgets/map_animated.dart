import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/storage.dart';
import '../models/map.dart';
import 'package:url_launcher/url_launcher.dart';

class MapAnimated extends StatefulWidget {
  const MapAnimated({super.key});

  @override
  _MapAnimatedState createState() => _MapAnimatedState();
}

class _MapAnimatedState extends State<MapAnimated> with TickerProviderStateMixin {
  static const _startedId = 'AnimatedMapController#MoveStarted';
  static const _inProgressId = 'AnimatedMapController#MoveInProgress';
  static const _finishedId = 'AnimatedMapController#MoveFinished';

  MapProperties _safeMapProperties = MapProperties();

  void _animatedMapMove(LatLng destLocation, double destZoom, MapController providerMapCtrlr) {
    final camera = providerMapCtrlr.camera;
    final latTween = Tween<double>(begin: camera.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(begin: camera.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: camera.zoom, end: destZoom);
    final controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    final Animation<double> animation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);
    final startIdWithTarget = '$_startedId#${destLocation.latitude},${destLocation.longitude},$destZoom';
    bool hasTriggeredMove = false;

    controller.addListener(() {
      final String id;
      if (animation.value == 1.0) {
        id = _finishedId;
      } else if (!hasTriggeredMove) {
        id = startIdWithTarget;
      } else {
        id = _inProgressId;
      }

      hasTriggeredMove |= providerMapCtrlr.move(
        LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
        zoomTween.evaluate(animation),
        id: id,
      );
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Widget _buildPopupContent(double lat, double lon, String address, String boxType, String strmUrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Box Type:',
          textScaler: TextScaler.linear(1.5),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mail_sharp,
              color: Colors.blue,
              size: 30,
            ),
            Text(
              boxType.isEmpty ? "  Unknown Box Type" : "  $boxType",
              // boxType ??= "Unknown Box Type",
              textScaler: const TextScaler.linear(1),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const Text(
          '\nAddress:',
          textScaler: TextScaler.linear(1.5),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.red[900],
              size: 30,
            ),
            Text(
              address.isEmpty ? "  Unknown Address" : "  $address",
              textScaler: const TextScaler.linear(1),
              textAlign: TextAlign.center,
            ),
            // AddressMapLink(
            //   address: address,
            // ),
          ],
        ),
        const Text(
          '\nStreaming or Recorded Link:',
          textScaler: TextScaler.linear(1.5),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.videocam,
              color: Colors.green,
              size: 30,
            ),
            Text(
              strmUrl.isEmpty ? "  No livestreams or recordings yet." : "  $strmUrl",
              textScaler: const TextScaler.linear(1),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        Text(
          '\n\nLatitude:$lat Longitude:$lon',
          textScaler: const TextScaler.linear(1),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // initialization:
  // tell widget to start listening for changes in MapProperties (zoom/location)
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final storage = Provider.of<Storage>(context, listen: false);
    storage.mapProperties.addListener(_onLocationChange);
// Store for safe access later
    _safeMapProperties = storage.mapProperties; // Store for safe access later
  }

  // react to changes:
  // when new zoom/location, call _onLocationChange. Then use MapController to update the map view. This is the link between MapProperties and MapController
  void _onLocationChange() {
    final storage = Provider.of<Storage>(context, listen: false);
    _animatedMapMove(storage.mapProperties.mapZoomLocaiton_, storage.mapProperties.mapZoomLevel, Provider.of<Storage>(context, listen: false).mapcontroller);
  }

  // garbage collection
  @override
  void dispose() {
    _safeMapProperties.removeListener(_onLocationChange);

    // Now use the safe references
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<Storage>(context, listen: false);
    return Expanded(
      flex: 1,
      child: FlutterMap(
        mapController: storage.mapcontroller,
        options: const MapOptions(
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          initialCenter: LatLng(37.0902, -95.7129), // Center of the USA
          initialZoom: 3.9, // Adjust zoom level as needed
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            tileProvider: CancellableNetworkTileProvider(),
          ),
          MarkerLayer(
            markers: storage.locationLatLonMarkerList.locationLatLons
                .map((location) => Marker(
                      point: LatLng(location['lat'], location['lng']),
                      width: 80.0,
                      height: 80.0,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            elevation: 100,
                            builder: (context) => _buildPopupContent(location['lat'], location['lng'], location['address'], location['boxType'], location['strmUrl']),
                          );
                        },
                        child: Icon(Icons.location_on, color: Colors.red[900], size: 30.0),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class AddressMapLink extends StatelessWidget {
  final String address;

  const AddressMapLink({super.key, this.address = '1600 Amphitheatre Parkway, Mountain View, CA'});

  // Function to launch the map with an address query
  Future<void> _launchMapWithAddress() async {
    // Encode the address to make it safe for URLs
    final String encodedAddress = Uri.encodeComponent(address);
    // Construct the geo URI with a query
    final Uri url = Uri.parse('geo:0,0?q=$encodedAddress');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Address in Map'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Click to find:'),
            GestureDetector(
              onTap: _launchMapWithAddress,
              child: Text(
                address,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
