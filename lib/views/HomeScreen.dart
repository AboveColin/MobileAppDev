import 'MapScreen.dart';
import 'package:mobileappdev/views/profile/ProfileScreen.dart';
import 'CarList.dart';
import 'FAQ_Screen.dart';
import 'package:flutter/material.dart';
import 'CurrentRentals.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  // ignore: unused_field
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final preferencesService = StorageHelper();
    final settings = await preferencesService.getSettings();
    if (mounted) {
      setState(() {
        _darkMode = settings.darkMode;
      });
    }
  }

  late final List<Widget> _widgetOptions = <Widget>[
    const CarList(),
    const MapScreen(),
    CurrentRentals(),
    const ProfileScreen(),
    const FAQScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: themeData.colorScheme.surface,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Rental',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
              icon: Icon(Icons.question_mark_rounded),
              label: "FAQ",
          )
        ],
        selectedIndex: _selectedIndex,
        indicatorColor: Colors.amber[800],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
