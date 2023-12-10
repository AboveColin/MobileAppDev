import 'package:flutter/material.dart';
import '../SettingsScreen.dart';
import '../StartScreen.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:mobileappdev/views/profile/EditProfileScreen.dart';
import 'package:mobileappdev/views/PastRentalsScreen.dart';
import 'package:mobileappdev/theme_config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageHelper storageHelper = StorageHelper();
  Map<String, dynamic>? customerData;
  bool isLoading = true; // To handle loading state

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();
  }

  Future<void> _fetchCustomerData() async {
    setState(() => isLoading = true);
    try {
      Map<String, dynamic>? data = await storageHelper.getProfileData();
      if (mounted) {
        setState(() {
          customerData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorDialog('Error fetching customer data');
    }
  }

  void _logout() async {
    await storageHelper.clearStorage();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const StartScreen()),
        (route) => false);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchCustomerData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildProfileContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
        tooltip: 'Edit Profile',
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildProfileContent() {
    var profileImage =
        customerData?['profilePicture'] ?? 'https://picsum.photos/200';
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            CircleAvatar(
                radius: 50, backgroundImage: NetworkImage(profileImage)),
            const SizedBox(height: 10),
            _buildProfileDetail('Name',
                '${customerData?['firstName'] ?? ""} ${customerData?['lastName'] ?? "Loading..."}'),
            _buildProfileDetail(
                'Email', '${customerData?['email'] ?? "Loading..."}'),
            _buildProfileDetail(
                'Birthdate', '${customerData?['birthDate'] ?? "Loading..."}'),
            const SizedBox(height: 20),
            _buildActionButton(
                'View Past Rentals',
                () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PastRentalsScreen()))),
            const SizedBox(height: 20),
            _buildActionButton('Logout', _logout),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: ThemeConfig.primaryColor,
        foregroundColor: ThemeConfig.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text),
    );
  }
}
