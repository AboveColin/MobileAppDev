import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart'; // Add flutter_animator package for animations
import 'package:mobileappdev/views/Authentication/LoginScreen.dart';
import 'package:mobileappdev/views/Authentication/RegistrationScreen.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:mobileappdev/views/HomeScreen.dart';
import 'package:mobileappdev/theme_config.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  final StorageHelper storageHelper = StorageHelper();
  // ignore: unused_field
  bool _darkMode = false;
  late AnimationController _animationController;
  late Animation _animation;
  bool _isSmokeVisible = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
    _loadSettings();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: -450.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final settings = await storageHelper.getSettings();
    if (mounted) {
      setState(() {
        _darkMode = settings.darkMode;
      });
    }
  }

  Future<void> _checkIfLoggedIn() async {
    String? token = await storageHelper.getToken();
    if (token != null && mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: FadeInDown(
                    // Added animation
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _animationController.forward();
                            setState(() {
                              _isSmokeVisible = true;
                            });
                          },
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.translate(
                                offset: Offset(_animation.value, 0),
                                child: Stack(
                                  children: [
                                    // Smoke Image
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // blank space to align smoke
                                          const SizedBox(width: 130),
                                          Image.asset('assets/logo.png',
                                              height: 120.0),
                                          Visibility(
                                            visible: _isSmokeVisible,
                                            child: Image.asset(
                                                'assets/smoke.png',
                                                height: 120.0),
                                          )
                                        ])

                                    // Car Image
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20, width: double.infinity),
                        const Text(
                          'Welcome to Automaat!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FadeInUp(
                    // Added animation
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: ThemeConfig.primaryColor,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const Text('Login',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                        ),
                        const SizedBox(height: 15),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 45, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('Register',
                              style: TextStyle(fontSize: 18)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegistrationScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
