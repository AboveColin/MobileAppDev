import 'Dashboard.dart';
import 'MapScreen.dart';
import 'ProfileScreen.dart';
import 'CarList.dart';
import 'Authentication/LoginScreen.dart';
import 'Authentication/RegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'helpers/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.onThemeChanged});

  final String title;
  final Function(bool) onThemeChanged;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final preferencesService = PreferencesService();
    final settings = await preferencesService.getSettings();
    setState(() {
      _darkMode = settings.darkMode;
    });
  }

  late final List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    const CarList(),
    const MapScreen(),
    ProfileScreen(onThemeChanged: widget.onThemeChanged),
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.directions_car),
            label: 'Cars',
          ),
          NavigationDestination(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
