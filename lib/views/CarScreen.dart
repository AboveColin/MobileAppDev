import 'package:flutter/material.dart';
import 'package:mobileappdev/views/RentCarForm.dart';
import 'package:mobileappdev/views/DamageReportScreen.dart';
import '../helpers/ApiService.dart';
import 'package:mobileappdev/theme_config.dart';

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
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement action like Rent this Car
        },
        child: const Icon(Icons.directions_car),
        backgroundColor: ThemeConfig.primaryColor,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _apiService.fetchCar(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var carData = snapshot.data!['Car'][0];
            return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'carImage$id',
                      child: carData['image'] != null
                          ? FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.jpg',
                              image: carData['image'],
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 250,
                              color: Colors.grey[200],
                              child: const Center(
                                  child: Text('No image available')),
                            ),
                    ),
                    const SizedBox(height: 20),
                    buildDetailRow(Icons.confirmation_number, 'License Plate:',
                        '${carData["licensePlate"]}'),
                    buildDetailRow(Icons.branding_watermark, 'Brand:',
                        '${carData["brand"]}'),
                    buildDetailRow(
                        Icons.directions_car, 'Model:', '${carData["model"]}'),
                    buildDetailRow(Icons.local_gas_station, 'Fuel type:',
                        '${carData["fuel"]}'),
                    buildDetailRow(Icons.calendar_today, 'Year:',
                        '${carData["modelYear"]}'),
                    buildDetailRow(
                        Icons.category, 'Type:', '${carData["body"]}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DamageReportScreen(carID: id),
                          ),
                        );
                      },
                      child: const Text('Report Damage'),
                      style: ElevatedButton.styleFrom(
                        primary: ThemeConfig.secondaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RentCarForm(id: id),
                  ],
                ));
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: ThemeConfig.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
