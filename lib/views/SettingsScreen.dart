import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../helpers/StorageHelper.dart';
import '../models/Settings.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsScreen({super.key, required this.onThemeChanged});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool darkMode = false;
  final StorageHelper _preferencesService = StorageHelper();

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
  void initState() {
    super.initState();
    _populateFields();
  }

  void _populateFields() async {
    final settingsJson = await _preferencesService.getSettings();
    final settings = Settings.fromJson({
      'darkMode': settingsJson.darkMode,
    });
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
