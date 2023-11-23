import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: FutureBuilder<String>(
        future: getPath(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return FlutterMap(
              mapController: MapController(),
              options: const MapOptions(
                initialCenter: LatLng(53.2176164346326, 6.565919420735281),
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'nl.colinnik.mobileappdev',
                  tileProvider: CachedTileProvider(
                    maxStale: const Duration(days: 30),
                    store: HiveCacheStore(
                      snapshot.data!,
                      hiveBoxName: 'HiveCacheStore',
                    ),
                  ),
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
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
