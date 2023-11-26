import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarScreen extends StatelessWidget {
  const CarScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  Future<Map<String, dynamic>> fetchData(int id) async {
    var url = Uri.parse('https://automaat.cdevries.dev/getCar/$id');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData; // Assuming the JSON response contains the car details directly
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var carData =
                snapshot.data!['Car'][0]; // Adjust based on your API response
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                carData[10] != null
                    ? Image.network(carData[10], fit: BoxFit.cover)
                    : SizedBox(
                        height: 200,
                        child: Center(child: Text('No image available'))),
                SizedBox(height: 10),
                buildDetailRow(Icons.confirmation_number, 'License Plate:',
                    '${carData[0]}'),
                buildDetailRow(
                    Icons.branding_watermark, 'Brand:', '${carData[2]}'),
                buildDetailRow(Icons.directions_car, 'Model:', '${carData[3]}'),
                buildDetailRow(
                    Icons.local_gas_station, 'Fuel type:', '${carData[4]}'),
                buildDetailRow(Icons.calendar_today, 'Year:', '${carData[7]}'),
                buildDetailRow(Icons.category, 'Type:', '${carData[9]}'),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(value, style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
