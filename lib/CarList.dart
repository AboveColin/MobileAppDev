import 'package:flutter/material.dart';
import 'CarScreen.dart';

class CarList extends StatelessWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
      ),
      body: ListView.builder(
      itemCount: 10, // Number of available cars
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.directions_car),
          title: Text('Car $index'), // Replace with actual car name
          subtitle:
              const Text('Location, Availability'), // Replace with actual details
          trailing: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarScreen(id: index)),
              );
            }, // Logic to book or view car
            child: const Text('Book'),
          ),
        );
      },
    ),
    );
  }
}