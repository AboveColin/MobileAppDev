import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: const MapOptions(
          initialCenter: LatLng(53.2176164346326, 6.565919420735281),
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'nl.colinnik.mobileappdev',
          ),
          const MarkerLayer(
            markers: [
              Marker(
                point: LatLng(53.2176164346326, 6.565919420735281),
                width: 80,
                height: 80,
                child: Icon(
                  Icons.directions_car,
                  color: Colors.blue,
                ),
              ),
              Marker(
                point: LatLng(53.2274164346326, 6.565919420735281),
                width: 80,
                height: 80,
                child: Icon(
                  Icons.directions_car,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
