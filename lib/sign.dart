import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'first.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _generatedOtp = '';

  void navigateToFirstPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/first');
  }

  // Simulate sending OTP
  void _sendOtp() {
    final random = Random();
    _generatedOtp = (random.nextInt(900000) + 100000).toString(); // Generate a 6-digit OTP
    print('Generated OTP: $_generatedOtp'); // In a real app, this would be sent via SMS

    _showOtpDialog();
  }

  // Simulate verifying OTP
  void _verifyOtp() {
    if (_otpController.text == _generatedOtp) {
      navigateToFirstPage(context);
    } else {
      _showErrorDialog('Invalid OTP. Please try again.');
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter the OTP'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _verifyOtp();
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF191970),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: isDarkMode ? Colors.white : Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hello Student,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.length < 8) {
                        return 'Username must be at least 8 characters long';
                      }
                      if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                        return 'Username must contain at least one uppercase letter and one number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Department',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Course',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      border: OutlineInputBorder(),
                      fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
                        return 'Password must contain at least one uppercase letter and one number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _sendOtp(); // Simulate sending OTP and navigating after OTP validation
                        }
                      },
                      icon: Icon(Icons.check),
                      label: Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
