import 'package:flutter/material.dart';
import 'package:mobileappdev/StartScreen.dart';
import 'helpers/shared_preferences.dart';

import 'HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  void _updateTheme(bool isDarkMode) {
    setState(() {
      _darkMode = isDarkMode;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automaat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: _darkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: StartScreen(),
    );
  }
}
