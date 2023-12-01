import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobileappdev/views/StartScreen.dart';
import 'package:mobileappdev/views/Authentication/ResetPasswordScreen.dart'; // Import your ResetPasswordScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      if (response.payload != null) {
        print('Payload: ${response.payload}');
        // Assuming you have a navigator key
        // You need to pass this key to MaterialApp
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(resetToken: response.payload!),
        ));
      }
    },
  );

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  void _updateTheme(bool isDarkMode) {
    if (mounted) {
      setState(() {
        _darkMode = isDarkMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Use the navigator key here
      title: 'Automaat',
      theme: _darkMode ? ThemeData.dark() : ThemeData.light(),
      home: StartScreen(onThemeChanged: _updateTheme),
    );
  }
}
