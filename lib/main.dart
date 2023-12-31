import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:hima_front_end/pages/Back-Screen.dart';
import 'package:hima_front_end/pages/map.dart';
import 'package:hima_front_end/pages/officer.dart';
import 'package:hima_front_end/pages/officerList.dart';
import 'package:hima_front_end/pages/signin_auth.dart';
import 'package:hima_front_end/pages/splash.dart';
import 'package:hima_front_end/pages/supervisor-home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  log(
    (await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .requestPermission())
        .toString(),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حِمى',
      theme: ThemeData(
        useMaterial3: true,
        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 99, 154, 125),
          brightness: Brightness.light,
        ),
        // Define the default `TextTheme`.
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: SupervisorHomepage(), //method to spicify the show screen
    );
  }

  Widget startScreen() {
    if (getID() == 'supervisor') {
      return SupervisorHomepage();
    } else if (getRole() == "officer") {
      return BackScreen();
    } else {
      return Splash();
    }
  }

  //get session id to make statful session
  Future<dynamic> getID() async {
    return await SessionManager().get("id");
  }

  //get session role to redirect to correct homepage
  Future<dynamic> getRole() async {
    return await SessionManager().get("role");
  }
}
