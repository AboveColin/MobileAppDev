import 'package:flutter/material.dart';
import '../helpers/ApiService.dart'; // Import ApiService

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _apiService.fetchDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var data = snapshot.data!;

            var totalCustomers = data['Costumers'][0]['costumers'];
            var carsAvailable = data['Cars'][0]['cars'];
            var activeRentals = data['Rentals'][0]['rentals'];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Overview',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: const Text('Total Customers'),
                      trailing: Text('$totalCustomers'),
                      leading: const Icon(Icons.person),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: const Text('Cars Available'),
                      trailing: Text('$carsAvailable'),
                      leading: const Icon(Icons.directions_car),
                    ),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: const Text('Active Rentals'),
                      trailing: Text('$activeRentals'),
                      leading: const Icon(Icons.car_rental),
                    ),
                  ),
                ],
              ),
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