import 'package:flutter/material.dart';
import 'CarScreen.dart';
import 'helpers/ApiService.dart'; // Import ApiService

class CarList extends StatefulWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {
  late Future<List<dynamic>> carsFuture;
  final ApiService _apiService =
      ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    carsFuture = _apiService.fetchCars(); // Use fetchCars from ApiService
  }

  Future<void> _refreshData() async {
    setState(() {
      carsFuture = _apiService.fetchCars(); // Reset the future to reload data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Cars'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            var cars = snapshot.data!;
            print(cars);
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  var car = cars[index];
                  print(car);
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Icon(Icons.directions_car), // Example icon
                      title: Text(
                        '${car["brand"]} ${car["model"]}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('License Plate: ${car["licensePlate"]}'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CarScreen(id: index + 1),
                          ),
                        );
                      },
                    ),
                  );
                },
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
