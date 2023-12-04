import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobileappdev/views/StartScreen.dart';
import 'package:mobileappdev/views/Authentication/ResetPasswordScreen.dart';
import 'package:mobileappdev/theme_config.dart';
import 'package:mobileappdev/helpers/StorageHelper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Local Notifications Setup
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
        navigatorKey.currentState?.push(MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(resetToken: response.payload!),
        ));
      }
    },
  );

  final StorageHelper storageHelper = StorageHelper();
  await storageHelper.getDarkModePreference();

  runApp(
    ChangeNotifierProvider(
      create: (context) => storageHelper,
      child: MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final storageHelper = Provider.of<StorageHelper>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Automaat',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: storageHelper.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StartScreen(),
    );
  }
}
