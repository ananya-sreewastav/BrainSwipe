import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart'; // Ensure this import is correct
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore

class Tut extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? _certificatePath;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables to hold form data
  String? _firstSubject;
  String? _firstMarks;
  String? _firstProficiency;
  String? _secondSubject;
  String? _secondMarks;
  String? _secondProficiency;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04;
    final fontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF052659),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: isDarkMode ? Colors.white : Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Card for First Subject Preference
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Subject Preference',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Math',
                        ),
                        onChanged: (value) {
                          _firstSubject = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the first subject preference';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Aggregate Semester Marks',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 85%',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _firstMarks = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the aggregate semester marks for the first subject';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Proficiency Level',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ['Beginner', 'Intermediate', 'Advanced']
                            .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                            .toList(),
                        onChanged: (value) {
                          _firstProficiency = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the proficiency level for the first subject';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // (Repeat similar code for Second Subject Preference)
              // Card for Second Subject Preference
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Second Subject Preference',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Science',
                        ),
                        onChanged: (value) {
                          _secondSubject = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the second subject preference';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Aggregate Semester Marks',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 90%',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _secondMarks = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the aggregate semester marks for the second subject';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        'Proficiency Level',
                        style: TextStyle(
                          fontSize: fontSize,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ['Beginner', 'Intermediate', 'Advanced']
                            .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                            .toList(),
                        onChanged: (value) {
                          _secondProficiency = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select the proficiency level for the second subject';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Submit Button
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Send data to Firestore
                      _firestore.collection('subject_preferences').add({
                        'first_subject': _firstSubject,
                        'first_marks': _firstMarks,
                        'first_proficiency': _firstProficiency,
                        'second_subject': _secondSubject,
                        'second_marks': _secondMarks,
                        'second_proficiency': _secondProficiency,
                        'certificate_path': _certificatePath,
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Data submitted successfully!')),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to submit data: $error')),
                        );
                      });
                    }
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.grey[800] : const Color(0xFF191970),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2,
                      vertical: screenHeight * 0.02,
                    ),
                    textStyle: TextStyle(fontSize: fontSize),
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