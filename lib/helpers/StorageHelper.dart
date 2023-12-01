import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:mobileappdev/models/Settings.dart';

class StorageHelper {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> saveProfileData(Map<String, dynamic>? data) async {
    await _storage.write(key: 'profileData', value: jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getProfileData() async {
    String? data = await _storage.read(key: 'profileData');
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  Future<void> deleteProfileData() async {
    await _storage.delete(key: 'profileData');
  }

  Future<void> saveSettings(Settings settings) async {
    print(settings);
    await _storage.write(key: 'settings', value: jsonEncode(settings));
  }

  Future<Settings> getSettings() async {
    String? data = await _storage.read(key: 'settings');
    if (data != null) {
      return Settings.fromJson(jsonDecode(data));
    }
    return Settings(darkMode: false);
  }

  Future<void> saveCarData(List<dynamic> carData) async {
    String jsonCarData = jsonEncode(carData);
    await _storage.write(key: 'carData', value: jsonCarData);
  }

  Future<List<dynamic>> getCarData() async {
    String? jsonCarData = await _storage.read(key: 'carData');
    if (jsonCarData != null) {
      return jsonDecode(jsonCarData);
    }
    return [];
  }
}
