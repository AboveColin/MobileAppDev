import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileappdev/helpers/StorageHelper.dart'; // Import StorageHelper

class ApiService {
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

  Future<bool> loginUser(
      {required String email, required String password}) async {
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
    var url = Uri.parse('$baseUrl/register');
    try {
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

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        await storageHelper.saveToken(jsonData['access_token']);
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
  }

  // Protected routes
  Future<Map<String, dynamic>> fetchDashboardData() async {
    var url = Uri.parse('$baseUrl/getdashboard');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);

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

  Future<Map<String, dynamic>> fetchCustomer() async {
    var url = Uri.parse('$baseUrl/getCustomer');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);

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

  Future<Map<String, dynamic>> fetchRental(int id) async {
    var url = Uri.parse('$baseUrl/getRental/$id');
    try {
      var headers = await _getHeaders();
      var response = await http.get(url, headers: headers);

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
}
