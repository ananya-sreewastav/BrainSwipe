import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF191970),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Student,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Past Study Groups:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildStudyGroupBoxes(3), // Replace with the actual number of past study groups
            SizedBox(height: 20),
            Text(
              'Upcoming Study Groups:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            _buildStudyGroupBoxes(3), // Replace with the actual number of upcoming study groups
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/'); // Navigate to login page
                },
                child: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyGroupBoxes(int count) {
    return Column(
      children: List.generate(count, (index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          height: 50,
          color: Colors.blue[100],
          child: Center(
            child: Text(
              'Study Group ${index + 1}',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }),
    );
  }
}
