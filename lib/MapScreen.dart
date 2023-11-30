import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'CarScreen.dart';
import 'helpers/ApiService.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  late Future<List<dynamic>> rentalsFuture;
  final ApiService _apiService = ApiService();
  late Position currentPosition;
  bool _locationInitialized = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    rentalsFuture = _apiService.fetchRentals();
  }

  void refreshRentals() {
    setState(() {
      rentalsFuture = _apiService.fetchRentals();
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled. Notify the user or handle accordingly.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied. Notify the user or handle accordingly.
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied. Notify the user or handle accordingly.
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
      _locationInitialized = true;
    });
  }

  List<Marker> createMarkers(List rentals, BuildContext context) {
    return List.generate(rentals.length, (index) {
      var rental = rentals[index];
      print(rentals);
      return Marker(
        point: LatLng(rental['longitude'], rental['latitude']),
        width: 80,
        height: 80,
        child: IconButton(
          // give random color to each marker
          icon: Icon(Icons.directions_car, color: Colors.amber[800]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarScreen(id: rental['carID']),
              ),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: rentalsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var markers = createMarkers(snapshot.data!, context);

            // Add current location marker if location is initialized
            if (_locationInitialized) {
              print(currentPosition.latitude);
              markers.add(
                Marker(
                  point: LatLng(
                      currentPosition.latitude, currentPosition.longitude),
                  width: 30,
                  height: 30,
                  child: IconButton(
                    // give random color to each marker
                    icon: Icon(Icons.my_location, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
              );
            } else {
              print("Location not initialized");
            }

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: _locationInitialized
                    ? LatLng(
                        currentPosition.latitude, currentPosition.longitude)
                    : LatLng(53.2176164346326, 6.565919420735281),
                zoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'nl.nikColin.MobileAppDev',
                ),
                MarkerLayer(markers: markers),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshRentals,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
