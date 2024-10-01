import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // For user authentication

class Tut extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? _certificatePath;

  // Form field variables
  String? firstSubject;
  String? secondSubject;
  String? firstSubjectMarks;
  String? secondSubjectMarks;
  String? firstSubjectProficiency;
  String? secondSubjectProficiency;

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
              _buildSubjectPreferenceCard(
                  context,
                  screenHeight,
                  fontSize,
                  padding,
                  'First Subject Preference',
                  'Please enter the first subject preference',
                      (value) => firstSubject = value,
                      (value) => firstSubjectMarks = value,
                      (value) => firstSubjectProficiency = value
              ),
              _buildSubjectPreferenceCard(
                  context,
                  screenHeight,
                  fontSize,
                  padding,
                  'Second Subject Preference',
                  'Please enter the second subject preference',
                      (value) => secondSubject = value,
                      (value) => secondSubjectMarks = value,
                      (value) => secondSubjectProficiency = value
              ),
              _buildCertificationCard(context, screenHeight, padding, fontSize, isDarkMode),

              // Submit Button
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Ensure to call save() to populate the variables
                      _saveTutorData(); // Save data to Firestore
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

  // Subject preference card builder
  Widget _buildSubjectPreferenceCard(
      BuildContext context,
      double screenHeight,
      double fontSize,
      double padding,
      String title,
      String validationMessage,
      Function(String?) onSubjectSaved,
      Function(String?) onMarksSaved,
      Function(String?) onProficiencySaved
      ) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., Math',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return validationMessage;
                }
                return null;
              },
              onSaved: onSubjectSaved,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Aggregate Semester Marks',
              style: TextStyle(fontSize: fontSize),
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g., 85%',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the aggregate semester marks';
                }
                return null;
              },
              onSaved: onMarksSaved,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Proficiency Level',
              style: TextStyle(fontSize: fontSize),
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
              onChanged: (value) => onProficiencySaved(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a proficiency level';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  // Certification card
  Widget _buildCertificationCard(
      BuildContext context,
      double screenHeight,
      double padding,
      double fontSize,
      bool isDarkMode
      ) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Certifications in Subject Domain (Optional Tellfast)',
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
                hintText: 'e.g., Certified Math Tutor',
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  _certificatePath = result.files.single.path;
                }
              },
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Certificate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[700] : const Color(0xFFB3E5FC),
              ),
            ),
            if (_certificatePath != null)
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01),
                child: Text(
                  'Uploaded: ${_certificatePath!.split('/').last}',
                  style: TextStyle(fontSize: fontSize * 0.9),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Function to save tutor data to Firestore
  Future<void> _saveTutorData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle unauthenticated user
      print("User is not authenticated");
      return;
    }

    final userId = user.email; // Or use UID depending on your structure
    final tutorsCollection = FirebaseFirestore.instance.collection('tutors');
    final userTutorSubCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('my_tutors'); // Sub-collection under user

    Map<String, dynamic> tutorData = {
      'firstSubject': firstSubject,
      'firstSubjectMarks': firstSubjectMarks,
      'firstSubjectProficiency': firstSubjectProficiency,
      'secondSubject': secondSubject,
      'secondSubjectMarks': secondSubjectMarks,
      'secondSubjectProficiency': secondSubjectProficiency,
      'certificatePath': _certificatePath,
      'createdAt': FieldValue.serverTimestamp(),
    };

    // Log the data to debug
    print("Tutor data to be saved: $tutorData");

    // Save data to both collections
    try {
      await tutorsCollection.add(tutorData);
      await userTutorSubCollection.add(tutorData);
      print("Tutor data saved successfully");
    } catch (e) {
      print("Failed to save tutor data: $e");
    }
  }
}
