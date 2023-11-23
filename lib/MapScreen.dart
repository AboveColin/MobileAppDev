import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'CarScreen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  late Future<List<dynamic>> rentalsFuture;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    rentalsFuture = fetchRentals();
    // Possibly initialize a listener for map movements here
  }

  Future<List<dynamic>> fetchRentals() async {
    var url = Uri.parse('http://192.168.178.2:8000/getRentals'); // Update this URL as needed
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['Rentals']; // Assuming 'Rentals' is the key in the JSON response
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  void refreshRentals() {
    setState(() {
      rentalsFuture = fetchRentals();
    });
  }

  List<Marker> createMarkers(List rentals, BuildContext context) {
    return List.generate(rentals.length, (index) {
      
      var rental = rentals[index];
      print(rentals);
      return Marker(
        point: LatLng(rental[1], rental[2]), // Assuming indexes 1 and 2 are latitude and longitude
        width: 80,
        height: 80,
        child: IconButton(
          // give random color to each marker
          icon: Icon(Icons.directions_car, color: Colors.amber[800]),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarScreen(id: rental[7]), // Assuming index 6 is the ID or unique identifier
                
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
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
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
                  userAgentPackageName: 'com.yourcompany.yourapp',
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
