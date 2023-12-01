import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart'; // Add this package for animations
import 'package:mobileappdev/views/HomeScreen.dart';
import 'package:mobileappdev/helpers/ApiService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:mobileappdev/views/Authentication/ForgotPasswordScreen.dart';
import 'package:mobileappdev/theme_config.dart';

class LoginScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  const LoginScreen({super.key, required this.onThemeChanged});
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                onThemeChanged: _updateTheme,
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
    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      labelText: '',
      fillColor: Colors.white,
      filled: true,
    );

    var buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: ThemeConfig.primaryColor,
      foregroundColor: ThemeConfig.secondaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Login'),
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
                    prefixIcon: const Icon(Icons.email,
                        color: ThemeConfig.primaryColor),
                    labelStyle:
                        const TextStyle(color: ThemeConfig.primaryColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeConfig.primaryColor),
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
                    prefixIcon:
                        const Icon(Icons.lock, color: ThemeConfig.primaryColor),
                    labelStyle:
                        const TextStyle(color: ThemeConfig.primaryColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: ThemeConfig.primaryColor),
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
              FadeInUp(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ForgotPasswordScreen(apiService: _apiService),
                    ));
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
