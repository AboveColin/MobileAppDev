import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveSettings(Settings settings) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool('darkMode', settings.darkMode);

    // Add other settings to save as needed
  }

  Future<Settings> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    final darkMode = preferences.getBool('darkMode') ?? false;

    return Settings(darkMode: darkMode);
  }
}

class Settings {
  final bool darkMode;

  Settings({required this.darkMode});
}
