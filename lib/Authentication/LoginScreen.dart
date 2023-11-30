import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart'; // Add this package for animations
import 'package:mobileappdev/HomeScreen.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import '../helpers/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

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

  void _login() async {
    // Implement login logic using _apiService
    String email = _emailController.text;
    String password = _passwordController.text;

    // Check if the fields are not empty
    if (email.isEmpty || password.isEmpty) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      print('Logging in...');
      // Call the login method of the ApiService
      var response = await _apiService.loginUser(
        email: email,
        password: password,
      );

      // Handle the response according to your API structure
      if (response == true) {
        // Navigate to the next screen or show a success message
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                title: 'Available Cars',
                onThemeChanged: _updateTheme, // Passing the callback
              ),
            ));
      } else {
        print(response);
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF); // Example primary color
    const secondaryColor = Color(0xFFF5F6FA); // Example secondary color

    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      labelText: '',
      fillColor: Colors.white,
      filled: true,
    );

    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6DD5FA),
              Color(0xFFFF758C)
            ], // Updated vibrant gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: TextField(
                  controller: _emailController,
                  decoration: inputDecoration.copyWith(
                    labelText: 'E-Mail',
                    prefixIcon: const Icon(Icons.email, color: primaryColor),
                    labelStyle: const TextStyle(color: primaryColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: 10),
              FadeInDown(
                child: TextField(
                  controller: _passwordController,
                  decoration: inputDecoration.copyWith(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock, color: primaryColor),
                    labelStyle: const TextStyle(color: primaryColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              FadeInUp(
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
