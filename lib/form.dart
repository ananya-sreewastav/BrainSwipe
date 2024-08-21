import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:google_fonts/google_fonts.dart';
import 'congratulations_page.dart'; // Import the CongratulationsPage

class CreateStudyGroupForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

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
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Subject Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the subject name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Department
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                items: <String>[
                  'Computer Science',
                  'Mathematics',
                  'Physics',
                  'Chemistry',
                  'Biology'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a department';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Time
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Location
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Number of Members
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Number of Members',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of members';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.blueGrey : Color(0xFF191970),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Creating Study Group...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Navigate to the CongratulationsPage after a delay
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CongratulationsPage(),
                        ),
                      );
                    });
                  }
                },
                child: Text(
                  'Create Study Group',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
