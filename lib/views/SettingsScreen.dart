import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../helpers/StorageHelper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  final StorageHelper _preferencesService = StorageHelper();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    darkMode = await _preferencesService.getDarkModePreference();
    setState(() {});
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      darkMode = value;
      _preferencesService.setDarkModePreference(value);
    });
  }

  void showNotification() async {
    print('showNotification');
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority:
          Priority.high, // optioneel, bepaalt de prioriteit van de notificatie
      showWhen: true, // optioneel, toont of verbergt de tijd van de notificatie
      // Andere configuraties indien nodig
    );
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Notificatie Titel',
      'Dit is de body van de notificatie',
      generalNotificationDetails,
    );
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
            onChanged: _toggleDarkMode,
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              // Navigate to account settings
            },
          ),
          ListTile(
            title: const Text('Test notifications'),
            onTap: () {
              // Navigate to notification settings
              showNotification();
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
        ],
      ),
    );
  }
}
