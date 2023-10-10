/*
 * MyApp is the main entry point of the HealthHub Flutter application.
 * It initializes Firebase, sets the application theme, and defines the initial screen.
 *
 * The widget includes the following features:
 * - Initialization of Firebase services using Firebase.initializeApp().
 * - Setting the color scheme for the application.
 * - Setting the initial screen to the SplashScreen.
 * - Disabling the debug banner in release mode.
 */

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:healthhub/view/splash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthHub', // Application title
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 225, 125, 25)), // Custom color scheme
        useMaterial3: true, // Enable Material 3 design
      ),
      home: const SplashScreen(), // Initial screen is the SplashScreen
      debugShowCheckedModeBanner: false, // Disable debug banner in release mode
    );
  }
}
