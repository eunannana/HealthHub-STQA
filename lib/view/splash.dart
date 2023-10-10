/*
 * SplashScreen is a Flutter widget that represents the initial splash screen of the HealthHub app.
 * It is displayed when the app is launched and provides a brief introduction to the app before navigating to the login page.
 *
 * The widget includes the following elements:
 * - A background color.
 * - An app logo.
 * - A welcome message.
 *
 * The splash screen automatically transitions to the login page after a specified duration.
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthhub/view/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 67, 8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/healthhub.png', 
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Let's go healthy together with HealthHub!",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Timer to navigate to the login page after 5 seconds.
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }
}
