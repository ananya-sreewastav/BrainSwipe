import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userID = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Student,',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Past Study Groups:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .collection('registered_study_groups')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                      'No past study groups available.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    );
                  }

                  final pastGroups = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final date = DateTime.tryParse(data['date'] ?? '') ?? DateTime.now();
                    return date.isBefore(DateTime.now());
                  }).toList();

                  if (pastGroups.isEmpty) {
                    return Text(
                      'No past study groups available.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    );
                  }

                  return ListView(
                    children: pastGroups.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildStudyGroupBox(data, isDarkMode);
                    }).toList(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Upcoming Study Groups:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userID)
                    .collection('registered_study_groups')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text(
                      'No upcoming study groups available.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    );
                  }

                  final upcomingGroups = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final date = DateTime.tryParse(data['date'] ?? '') ?? DateTime.now();
                    return date.isAfter(DateTime.now());
                  }).toList();

                  if (upcomingGroups.isEmpty) {
                    return Text(
                      'No upcoming study groups available.',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    );
                  }

                  return ListView(
                    children: upcomingGroups.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildStudyGroupBox(data, isDarkMode);
                    }).toList(),
                  );
                },
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((_) {
                    Navigator.pushReplacementNamed(context, '/');
                  });
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
                  foregroundColor: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyGroupBox(Map<String, dynamic> data, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.blueGrey,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '${data['subject']} on ${data['date'] ?? 'No date'}',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
