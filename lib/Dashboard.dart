import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Overview',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Total Customers'),
                trailing: Text('120'), // Replace with actual data
                leading: Icon(Icons.person),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Cars Available'),
                trailing: Text('45'), // Replace with actual data
                leading: Icon(Icons.directions_car),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Active Rentals'),
                trailing: Text('20'), // Replace with actual data
                leading: Icon(Icons.car_rental),
              ),
            ),
            Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Scheduled Repairs'),
                trailing: Text('15'), // Replace with actual data
                leading: Icon(Icons.build),
              ),
            ),
            // ... Add more cards for other data points
          ],
        ),
      ),
    );
  }
}
