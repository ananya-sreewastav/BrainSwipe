import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'congratulations_page.dart';

class CreateStudyGroupForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _membersController = TextEditingController();

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
                controller: _subjectController,
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
                controller: _timeController,
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
                controller: _locationController,
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
                controller: _membersController,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Creating Study Group...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Create the study group and add it to Firestore
                    final user = FirebaseAuth.instance.currentUser;
                    final studyGroupData = {
                      'subject': _subjectController.text,
                      'department': _subjectController.text,
                      'time': _timeController.text,
                      'location': _locationController.text,
                      'members': int.parse(_membersController.text),
                      'createdAt': FieldValue.serverTimestamp(),
                    };

                    if (user != null) {
                      // Add to the global collection
                      final studyGroupDocRef = await FirebaseFirestore.instance
                          .collection('study_groups')
                          .add(studyGroupData);

                      // Add to the user's subcollection
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.email)
                          .collection('my_study_groups')
                          .doc(studyGroupDocRef.id)
                          .set(studyGroupData);

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
