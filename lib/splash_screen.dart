import 'dart:async';
import 'package:flutter/material.dart';
import 'login.dart'; // Ensure you import your LoginPage

class SplashScreen extends StatefulWidget {
  final Function toggleDarkMode; // Add this line to accept the toggleDarkMode function

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
              Color(0xFF066375), // Your specified teal color
              Color(0xFF3AB3A0), // A lighter complementary shade for the gradient
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo.png', // Path to your logo
            width: 400, // Width of the logo
            height: 500, // Height of the logo
          ),
        ),
      ),
    );
  }
}
