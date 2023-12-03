// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
// For animations
import 'package:intl/intl.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:mobileappdev/theme_config.dart';
import 'package:mobileappdev/views/StartScreen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  DateTime _birthDate = DateTime.now();
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
    String email = _emailController.text;
    String password = _passwordController.text;
    String lastName = _lastNameController.text;
    String firstName = _firstNameController.text;
    String birthDateString = DateFormat('yyyy-MM-dd').format(_birthDate);

    if (email.isEmpty ||
        password.isEmpty ||
        lastName.isEmpty ||
        firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      var response = await _apiService.registerUser(
        email: email,
        password: password,
        lastName: lastName,
        firstName: firstName,
        birthDate: birthDateString,
      );

      if (response == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StartScreen(
                    onThemeChanged: _updateTheme,
                  )),
        );
      } else {
        print(response);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.toString())),
        );
      }
    } catch (e) {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ThemeConfig.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFFFF758C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeConfig.primaryColor,
                  foregroundColor: ThemeConfig.secondaryColor,
                ),
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
