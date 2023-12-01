import 'package:flutter/material.dart';
import 'SettingsScreen.dart';
import 'StartScreen.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:mobileappdev/Views/EditProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const ProfileScreen({super.key, required this.onThemeChanged});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageHelper storageHelper = StorageHelper();
  Map<String, dynamic>? customerData = {};

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    try {
      Map<String, dynamic>? data = await storageHelper.getProfileData();
      if (mounted) {
        setState(() {
          customerData = data;
        });
      }
      print(customerData); // Log retrieved data
    } catch (e) {
      print('Error fetching customer data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var profileImage =
        customerData?['profilePicture'] ?? 'https://picsum.photos/200';
    return Scaffold(
      appBar: AppBar(
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
      body: RefreshIndicator(
        onRefresh: _fetchCustomerData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileImage),
                ),
                const SizedBox(height: 10),
                Text(
                  'Naam: ${customerData?['firstName'] ?? ""} ${customerData?['lastName'] ?? "Loading..."}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Email: ${customerData?['email'] ?? "Loading..."}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  'Geboortedatum: ${customerData?['birthDate'] ?? "Loading..."}',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // put on bottom of screen
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await storageHelper.deleteToken();
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StartScreen(
                                onThemeChanged: (bool) {
                                  widget.onThemeChanged(bool);
                                },
                              )),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.red)),
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileScreen(),
              ),
            );
          },
          child: const Icon(Icons.edit),
          tooltip: 'Edit Profile',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          )),
    );
  }
}
