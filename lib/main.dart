import 'package:flutter/material.dart';

import 'MapScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarShare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Available Cars'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addCar() {
    // Logic to add a new car
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: 10, // Number of available cars
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Car $index'), // Replace with actual car name
            subtitle:
                Text('Location, Availability'), // Replace with actual details
            trailing: ElevatedButton(
              onPressed: () {}, // Logic to book or view car
              child: Text('Book'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        },
        tooltip: 'Add Car',
        child: const Icon(Icons.car_rental),
      ),
    );
  }
}
