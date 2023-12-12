import 'package:flutter/material.dart';
import '../SettingsScreen.dart';
import '../StartScreen.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:mobileappdev/views/profile/EditProfileScreen.dart';
import 'package:mobileappdev/views/PastRentalsScreen.dart';
import 'package:mobileappdev/theme_config.dart';
import 'package:mobileappdev/views/paymentsScreen.dart';

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

  Widget FloatingButton() {
    return FloatingActionButton(
      onPressed: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const EditProfileScreen())),
      tooltip: 'Edit Profile',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: const Icon(Icons.edit),
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
      floatingActionButton: FloatingButton(),
    );
  }

  Widget _buildProfileContent() {
    var profileImage =
        customerData?['profilePicture'] ?? 'https://picsum.photos/200';
    return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 160,
          decoration: BoxDecoration(
            color: ThemeConfig.secondaryColor,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 40, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: ThemeConfig.primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
                    child: Container(
                        width: 70,
                        height: 70,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(profileImage, fit: BoxFit.cover)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${customerData?['firstName'] ?? ""} ${customerData?['lastName'] ?? "Loading..."}',
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            '${customerData?['email'] ?? "Loading..."}',
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${customerData?['birthDate'] ?? "Loading..."}',
                            ),
                          ],
                        ),
                        // const SizedBox(height: 100),
                        // _buildProfileInfo(),
                        // _buildActionsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )

        // Column(
        //   children: <Widget>[
        //     const SizedBox(height: 20),
        //     CircleAvatar(
        //       radius: 50,
        //       backgroundImage: NetworkImage(profileImage),
        //     ),
        //     const SizedBox(height: 10),
        //     Text(
        //       '${customerData?['firstName'] ?? ""} ${customerData?['lastName'] ?? "Loading..."}',
        //       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        //     ),
        //     Text(
        //       '${customerData?['email'] ?? "Loading..."}',
        //       style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        //     ),
        //     const SizedBox(height: 20),
        //     _buildProfileInfo(),
        //     _buildActionsSection(),
        //   ],
        // ),
        );
  }

  Widget _buildProfileInfo() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileDetail(
                'Birthdate', '${customerData?['birthDate'] ?? "Loading..."}'),
            const Divider(),
            // Additional details here if any
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildActionButton(
            "Past Payments",
            () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PastPaymentsScreen())),
          ),
          _buildActionButton(
            "View Past Rentals",
            () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PastRentalsScreen())),
          ),
          _buildActionButton("Logout", _logout),
        ],
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
