import 'package:flutter/material.dart';
import 'package:mobileappdev/views/StartScreen.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:intl/intl.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  DateTime _birthDate = DateTime.now(); // Changed to DateTime
  final ApiService _apiService = ApiService();

  // ignore: unused_field
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
    final preferencesService = StorageHelper();
    final settings = await preferencesService.getSettings();
    setState(() {
      _darkMode = settings.darkMode;
    });
  }

  void _register() async {
    // ignore: unnecessary_null_comparison
    if (_birthDate == null) {
      // Handle the case where the birth date is not set
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birth date')),
      );
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;
    String lastName = _lastNameController.text;
    String firstName = _firstNameController.text;
    String birthDateString = DateFormat('yyyy-MM-dd').format(_birthDate);

    // Check if the fields are not empty
    if (email.isEmpty ||
        password.isEmpty ||
        lastName.isEmpty ||
        firstName.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Call the registration method of the ApiService
      var response = await _apiService.registerUser(
        email: email,
        password: password,
        lastName: lastName,
        firstName: firstName,
        birthDate: birthDateString,
      );

      // Handle the response according to your API structure
      if (response == true) {
        // Navigate to the next screen or show a success message
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartScreen(
              onThemeChanged: _updateTheme,
            ),
          ),
        ); // Example
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.toString())),
        );
      }
    } catch (e) {
      // Handle any errors here
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      labelText: '',
      fillColor: Colors.white,
      filled: true,
    );

    var buttonStyle = ElevatedButton.styleFrom(
      primary: Colors.blue, // Button color
      onPrimary: Colors.white, // Text color
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _lastNameController,
              decoration: inputDecoration.copyWith(labelText: 'Last Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _firstNameController,
              decoration: inputDecoration.copyWith(labelText: 'First Name'),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectBirthDate(context),
              child: IgnorePointer(
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Birth Date',
                    // ignore: unnecessary_null_comparison
                    hintText: _birthDate == null
                        ? 'Select Birth Date'
                        : DateFormat('yyyy-MM-dd').format(_birthDate),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: inputDecoration.copyWith(labelText: 'E-Mail'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: inputDecoration.copyWith(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonStyle,
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
