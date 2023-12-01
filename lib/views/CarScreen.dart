import 'package:flutter/material.dart';
import '../helpers/ApiService.dart'; // Import ApiService

class CarScreen extends StatelessWidget {
  CarScreen({super.key, required this.id});

  final int id;
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Details'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _apiService.fetchCar(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var carData = snapshot.data!['Car'][0];
            print(carData['image']);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                carData[10] != null
                    ? Hero(
                        tag: carData['image'],
                        child: Image.network(carData['image']))
                    : const SizedBox(
                        height: 200,
                        child: Center(child: Text('No image available'))),
                const SizedBox(height: 10),
                buildDetailRow(Icons.confirmation_number, 'License Plate:',
                    '${carData["licensePlate"]}'),
                buildDetailRow(
                    Icons.branding_watermark, 'Brand:', '${carData["brand"]}'),
                buildDetailRow(
                    Icons.directions_car, 'Model:', '${carData["model"]}'),
                buildDetailRow(Icons.local_gas_station, 'Fuel type:',
                    '${carData["fuel"]}'),
                buildDetailRow(
                    Icons.calendar_today, 'Year:', '${carData["modelYear"]}'),
                buildDetailRow(Icons.category, 'Type:', '${carData["body"]}'),
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
