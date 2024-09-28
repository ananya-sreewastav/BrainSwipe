import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // Ensure you import your LoginPage

class SplashScreen extends StatefulWidget {
  final Function toggleDarkMode;

  const SplashScreen({Key? key, required this.toggleDarkMode}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 4 seconds
    Timer(Duration(seconds: 4), () {
      // Navigate to the login page after 4 seconds, passing the toggleDarkMode function
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage(toggleDarkMode: widget.toggleDarkMode)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF064A58), // Dark teal
              Color(0xFF066375), // Slightly lighter teal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BRAINSWIPE",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "PERSONALIZATION AT IT'S PEAK",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
