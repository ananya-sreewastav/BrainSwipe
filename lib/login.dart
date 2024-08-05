import 'package:flutter/material.dart';
import 'sign.dart'; // Import the Sign page
import 'first.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void navigateToFirstPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/first');
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.pushNamed(context, '/sign');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF191970),
        title: Text(
          'BrainSwipe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back button
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hello Student,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
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
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
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
                        bool isLoggedIn = true; // Replace with actual login logic

                        if (isLoggedIn) {
                          navigateToFirstPage(context); // Navigate to first page
                        }
                      }
                    },
                    icon: Icon(Icons.book),
                    label: Text('Login'),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Are you new here?',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      navigateToSignUp(context); // Navigate to sign up page
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
    );
  }
}
