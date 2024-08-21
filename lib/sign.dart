import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF052659),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // First Name Field
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                // Last Name Field
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Enter a password of at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Course Field
                TextFormField(
                  controller: _courseController,
                  decoration: InputDecoration(
                    labelText: 'Course',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(height: 10),
                // Year Field
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: 'Year',
                    labelStyle: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black,
                    ),
                    border: OutlineInputBorder(),
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // Create the user with Firebase Authentication
                          UserCredential userCredential =
                          await _auth.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );

                          // Create a document in Firestore using the email as the document ID
                          await _firestore
                              .collection('users')
                              .doc(_emailController.text)
                              .set({
                            'email': _emailController.text,
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                            'username': _usernameController.text,
                            'course': _courseController.text,
                            'year': int.parse(_yearController.text),
                          });

                          // Navigate to the login page after successful sign-up
                          Navigator.pushReplacementNamed(context, '/');
                        } catch (e) {
                          print('Error: $e');
                          // Handle error (e.g., show a snackbar with the error message)
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Sign up failed: ${e.toString()}'),
                          ));
                        }
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
    );
  }
}
