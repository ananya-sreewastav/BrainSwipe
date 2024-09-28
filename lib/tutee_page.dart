import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore

class TuteePage extends StatefulWidget {
  @override
  _TuteePageState createState() => _TuteePageState();
}

class _TuteePageState extends State<TuteePage> {
  final TextEditingController _subjectController = TextEditingController();
  List<DocumentSnapshot> availableTutors = [];

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void searchTutors(String subject) async {
    if (subject.isNotEmpty) {
      final result = await _firestore
          .collection('tutors')
          .where('subjects', arrayContains: subject)
          .get();

      setState(() {
        availableTutors = result.docs;
      });
    }
  }

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
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: AppBar().preferredSize.height + 20),
            Center(
              child: Text(
                'What subject do you need help with?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                hintText: 'Enter a subject...',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchTutors(_subjectController.text),
                ),
              ),
            ),
            SizedBox(height: 20),
            availableTutors.isEmpty
                ? Expanded(
              child: Center(
                child: Text(
                  'No tutors found. Please search for a subject.',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: availableTutors.length,
                itemBuilder: (context, index) {
                  var tutorData = availableTutors[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        '${tutorData['name']} - ${tutorData['subjects'].join(', ')}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Add navigation to tutor details or booking page
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
