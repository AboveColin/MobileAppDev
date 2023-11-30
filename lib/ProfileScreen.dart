import 'package:flutter/material.dart';
import 'package:mobileappdev/SettingsScreen.dart';
import 'StartScreen.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  ProfileScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  final StorageHelper storageHelper = StorageHelper();
  Map<String, dynamic> customerData = {};

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    try {
      Map<String, dynamic> data = await _apiService.fetchCustomer();
      setState(() {
        customerData = data;
      });
      print(customerData); // Log de opgehaalde gegevens
    } catch (e) {
      print('Fout bij het ophalen van klantgegevens: $e');
      // Je kunt hier ook een foutmelding tonen aan de gebruiker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      SettingsScreen(onThemeChanged: widget.onThemeChanged),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://picsum.photos/200'),
            ),
            const SizedBox(height: 10),
            Text(
              'Naam: ${customerData['Customer']?[0]['lastName'] ?? "Loading..."}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Email: ${customerData['Customer']?[0]['email'] ?? "Loading..."}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add edit profile functionality
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await storageHelper.deleteToken();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => StartScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
