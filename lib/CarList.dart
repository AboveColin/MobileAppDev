import 'package:flutter/material.dart';
import 'CarScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarList extends StatefulWidget {
  const CarList({Key? key}) : super(key: key);

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarList> {

  late Future<List<dynamic>> carsFuture;

  @override
  void initState() {
    super.initState();
    carsFuture = fetchData(); // Initialize the future
  }

  Future<List<dynamic>> fetchData() async {
    var url = Uri.parse('http://192.168.178.2:8000/getCars');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['Cars']; // Assuming 'Cars' is the key in the JSON response
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      carsFuture = fetchData(); // Reset the future to reload data
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
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            var cars = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                var car = cars[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.directions_car),  // Example icon
                    title: Text(
                      '${car[2]} ${car[3]}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('License Plate: ${car[0]}'),
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
            )
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
