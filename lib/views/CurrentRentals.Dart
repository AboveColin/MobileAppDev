import 'package:flutter/material.dart';
import 'package:mobileappdev/views/RentCarForm.dart';
import 'package:mobileappdev/views/DamageReportScreen.dart';
import '../helpers/ApiService.dart';
import 'package:mobileappdev/theme_config.dart';

class CurrentRentals extends StatelessWidget {
  CurrentRentals({super.key});

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Rental'),
        centerTitle: true,
        elevation: 2,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _apiService.fetchCurrentRental(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            print(snapshot.data);
            var carData = snapshot.data!;
            return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Hero(
                      tag: 'carImage$carData["id"]',
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
                    buildDetailRow(Icons.calendar_month, "Rental From", '${carData["fromDate"]}'),
                    buildDetailRow(Icons.calendar_today_outlined, "Return Before",  '${carData["toDate"]}'),
                    buildDetailRow(Icons.sell, "Rental state", '${carData["RentalState"]}'),
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
                        // TODO: _apiService.stopRental()
                      },
                      child: const Text('Stop Rental'),
                      style: ElevatedButton.styleFrom(
                        primary: ThemeConfig.primaryColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DamageReportScreen(carID: carData["carID"]),
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
                  ],
                ));
          } else if (snapshot.hasError) {
            return Center(child: Text('No Rentals Found'));
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
