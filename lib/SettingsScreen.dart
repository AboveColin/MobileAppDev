import 'package:flutter/material.dart';
import 'helpers/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsScreen({Key? key, required this.onThemeChanged})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  final _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() async {
    final settings = await _preferencesService.getSettings();
    setState(() {
      darkMode = settings.darkMode;
    });
  }

  void _saveSettings(bool value) async {
    final newSettings = Settings(darkMode: value);
    await _preferencesService.saveSettings(newSettings);
    widget.onThemeChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: darkMode,
            onChanged: (value) {
              setState(() {
                darkMode = value;
              });
              _saveSettings(value);
            },
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            title: const Text('Privacy and Security'),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          ListTile(
            title: const Text('Language'),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              // Show app version or other information
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () {
              // Handle user sign-out
            },
          ),
        ],
      ),
    );
  }
}
