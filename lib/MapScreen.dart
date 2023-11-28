import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'CarScreen.dart';
import 'helpers/ApiService.dart'; // Import ApiService

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  late Future<List<dynamic>> rentalsFuture;
  final ApiService _apiService =
      ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    rentalsFuture =
        _apiService.fetchRentals(); // Use fetchRentals from ApiService
  }

  void refreshRentals() {
    setState(() {
      rentalsFuture =
          _apiService.fetchRentals(); // Reset the future to reload data
    });
  }

  List<Marker> createMarkers(List rentals, BuildContext context) {
    return List.generate(rentals.length, (index) {
      var rental = rentals[index];
      print(rentals);
      return Marker(
        point: LatLng(
            rental['longitude'],
            rental[
                'latitude']), // Assuming indexes 1 and 2 are latitude and longitude
        width: 80,
        height: 80,
        child: IconButton(
          // give random color to each marker
          icon: Icon(Icons.directions_car, color: Colors.amber[800]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarScreen(
                    id: rental[
                        'carID']), // Assuming index 6 is the ID or unique identifier
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
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(53.2176164346326, 6.565919420735281),
                initialZoom: 13.0,
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
