import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobileappdev/helpers/StorageHelper.dart'; // Import StorageHelper
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobileappdev/main.dart';
import 'package:mobileappdev/views/Authentication/LoginScreen.dart';

class ApiService {
  final Connectivity _connectivity = Connectivity();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final String baseUrl = "https://automaat.cdevries.dev";
  final StorageHelper storageHelper = StorageHelper();

  Future<Map<String, String>> _getHeaders() async {
    String? token = await storageHelper.getToken();
    if (token != null) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
    return {'Content-Type': 'application/json'};
  }

  logoutIfNotAuthorized({httpStatusCode = int}) {
    if (httpStatusCode == 401) {
      StorageHelper().deleteToken();
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => LoginScreen(
          onThemeChanged: (bool isDarkMode) {},
        ),
      ));
    }
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    print(connectivityResult);
    return connectivityResult != ConnectivityResult.none;
  }

  void showNotification(String token) async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'channelDescription',
      importance: Importance.max,
      priority: Priority.high,
    );
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Nieuw wachtwoord!',
      'Hier is uw nieuwe wachtwoord!',
      generalNotificationDetails,
      payload: token, // The reset token you want to pass
    );
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    print(email + password);
    var url = Uri.parse('$baseUrl/login');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print(jsonData);
        await storageHelper
            .saveToken(jsonData['access_token']); // Use StorageHelper
        await fetchCustomer();
        return true;
      } else {
        // You can handle different status codes differently here
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String lastName,
    required String firstName,
    required String birthDate,
  }) async {
    if (await _isConnected()) {
      var url = Uri.parse('$baseUrl/register');
      try {
        print('Registering...');
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'last_name': lastName,
            'first_name': firstName,
            'birth_date': birthDate,
            'profile_picture': '',
          }),
        );
        print(response.body);

        if (response.statusCode == 200) {
          print('Registration successful');
          var jsonData = json.decode(response.body);

          await storageHelper.saveToken(jsonData['access_token']);
          await fetchCustomer();
          return true;
        } else {
          print('Registration failed');
          print(response.body);
          return false;
        }
      } catch (e) {
        print('Error: $e');
        return false;
      }
    } else {
      print('No internet connection');
      return false;
    }
  }

  // Protected routes
  Future<Map<String, dynamic>> fetchDashboardData() async {
    var url = Uri.parse('$baseUrl/getdashboard');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);

      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['Dashboard'];
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> fetchRentals() async {
    var url = Uri.parse('$baseUrl/getRentals');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['Rentals'];
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> fetchCars() async {
    var url = Uri.parse('$baseUrl/getCars');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData['Cars'];
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> fetchCar(int id) async {
    var url = Uri.parse('$baseUrl/getCar/$id');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData;
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>?> fetchCustomer() async {
    var url = Uri.parse('$baseUrl/getCustomer');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print(jsonData);
        await storageHelper.saveProfileData(jsonData['Customer']?[0]);
        print("data: ${jsonData['Customer']?[0]}");
        return jsonData['Customer']?[0];
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // throw Exception('Failed to load data');
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchRental(int id) async {
    var url = Uri.parse('$baseUrl/getRental/$id');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        return jsonData;
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    var url = Uri.parse('$baseUrl/updateProfile');
    String? token = await storageHelper.getToken();
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(profileData),
      );
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update profile');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> changePassword({
    required String? currentPassword,
    required String? newPassword,
  }) async {
    var url = Uri.parse('$baseUrl/changePassword');
    try {
      String? token = await storageHelper.getToken();
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming a successful response indicates password change
        return true;
      } else {
        // You can handle different status codes differently here
        print(
            'Password change failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during password change: $e');
      return false;
    }
  }

  Future<void> sendResetPasswordLink(String email) async {
    var url = Uri.parse('$baseUrl/forgot-password');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // Assuming a successful response indicates password change
        // send reset password link
        var data = jsonDecode(response.body);

        // print(data['token']);
        showNotification(data['token']);
        return;
      } else {
        // You can handle different status codes differently here
        print(
            'Password change failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to send reset password link');
      }
    } catch (e) {
      print('Error during password change: $e');
      throw Exception('Failed to send reset password link');
    }
  }

  Future<bool> resetPassword(String token, String newPassword) async {
    final url = Uri.parse('$baseUrl/reset-password');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'token': token,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Password reset successful
    } else {
      return false; // Password reset failed
    }
  }

  Future<bool> sendDamageReport(
      {required String description,
      required String image,
      required int carID}) async {
    var url = Uri.parse('$baseUrl/saveDamageReport');
    try {
      var headers = await _getHeaders();
      var response = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          'description': description,
          'image_url': image,
          'car_id': carID,
        }),
      );
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to save damage report');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchDamageReports() async {
    var url = Uri.parse('$baseUrl/getDamageReports');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);
      logoutIfNotAuthorized();
      if (response.statusCode == 200) {
        // print(response.body[0]);
        var jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        print('Failed to load data');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data');
    }
  }
}
