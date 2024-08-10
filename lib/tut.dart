import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart'; // Ensure this import is correct

class Tut extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String? _certificatePath;

  @override
  Widget build(BuildContext context) {
    // Get the screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate padding and font size based on screen size
    final padding = screenWidth * 0.04;
    final fontSize = screenWidth * 0.045;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF191970),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
        centerTitle: true,
      ),
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
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Math',
                        ),
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
                        style: TextStyle(fontSize: fontSize),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 85%',
                        ),
                        keyboardType: TextInputType.number,
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
                        style: TextStyle(fontSize: fontSize),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ['Beginner', 'Intermediate', 'Advanced']
                            .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                            .toList(),
                        onChanged: (value) {},
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

              // Card for Second Subject Preference
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
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
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Science',
                        ),
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
                        style: TextStyle(fontSize: fontSize),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 90%',
                        ),
                        keyboardType: TextInputType.number,
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
                        style: TextStyle(fontSize: fontSize),
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: ['Beginner', 'Intermediate', 'Advanced']
                            .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                            .toList(),
                        onChanged: (value) {},
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

              // Card for Certifications
              Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Certifications in Subject Domain (Optional)',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'e.g., Certified Math Tutor',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Allow the user to pick a file (for uploading certificate)
                          FilePickerResult? result =
                          await FilePicker.platform.pickFiles();

                          if (result != null) {
                            _certificatePath = result.files.single.path;
                            // Perform actions with the selected file path
                          }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload Certificate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB3E5FC), // Updated property
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
              ),

              // Submit Button
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                    }
                  },
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF191970), // Updated property
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
