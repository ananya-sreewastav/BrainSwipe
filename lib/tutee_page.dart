import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // To format date

class TuteePage extends StatefulWidget {
  @override
  _TuteePageState createState() => _TuteePageState();
}

class _TuteePageState extends State<TuteePage> {
  final TextEditingController _subjectController = TextEditingController();
  List<Map<String, dynamic>> availableTutors = [];
  DateTime? selectedDate;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Search for tutors based on subject in each user's 'my_tutors' subcollection
  void searchTutors(String subject) async {
    if (subject.isNotEmpty) {
      List<Map<String, dynamic>> tutors = [];

      try {
        // Get all users
        QuerySnapshot userSnapshot = await _firestore.collection('users').get();

        // Iterate over each user document
        for (var userDoc in userSnapshot.docs) {
          // Fetch the 'my_tutors' subcollection for each user
          QuerySnapshot tutorSnapshot = await userDoc.reference.collection('my_tutors').get();

          // Collect matching tutors from 'my_tutors' subcollection
          for (var tutorDoc in tutorSnapshot.docs) {
            Map<String, dynamic> tutorData = tutorDoc.data() as Map<String, dynamic>;

            // Check if either 'firstSubject' or 'secondSubject' matches the searched subject
            if (tutorData['firstSubject'] == subject || tutorData['secondSubject'] == subject) {
              String matchedSubject;
              String proficiency;

              // Determine which subject matched
              if (tutorData['firstSubject'] == subject) {
                matchedSubject = tutorData['firstSubject'];
                proficiency = tutorData['firstSubjectProficiency'];
              } else {
                matchedSubject = tutorData['secondSubject'];
                proficiency = tutorData['secondSubjectProficiency'];
              }

              // Prepare the tutor data including user's first and last name
              tutors.add({
                'firstName': userDoc['firstName'],
                'lastName': userDoc['lastName'],
                'matchedSubject': matchedSubject,
                'proficiency': proficiency,
                'email': userDoc['email'],
              });
            }
          }
        }

        // Update state with the collected tutors
        if (mounted) {
          setState(() {
            availableTutors = tutors;
          });
        }
      } catch (error) {
        print("Failed to search tutors: $error");
      }
    }
  }

  // Function to book a session and save the details in Firestore
  Future<String> _bookSession(Map<String, dynamic> tutorData) async {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Future.error("User not logged in. Please login to book a session.");
    }

    if (selectedDate == null) {
      return Future.error("Please select a date to book the session.");
    }

    String tuteeEmail = currentUser.email ?? '';
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

    try {
      // Creating the registered_tutee collection and adding a document under it with the user's email
      await _firestore.collection('registered_tutee').doc(tuteeEmail).set({
        'dateBooked': formattedDate,
        'tutorName': '${tutorData['firstName']} ${tutorData['lastName']}',
        'tutorEmail': tutorData['email'],
        'subject': tutorData['matchedSubject'],
      });

      return "Session successfully booked for $formattedDate";
    } catch (error) {
      return Future.error("Failed to book session: $error");
    }
  }

  // Show hardcoded dates to pick and confirm booking
  void _showBookingDates(BuildContext context, Map<String, dynamic> tutorData) {
    List<DateTime> availableDates = [
      DateTime.now().add(Duration(days: 1)),
      DateTime.now().add(Duration(days: 3)),
      DateTime.now().add(Duration(days: 5)),
      DateTime.now().add(Duration(days: 7)),
      DateTime.now().add(Duration(days: 10)),
      DateTime.now().add(Duration(days: 14)),
    ];

    // Capture a stable reference to context
    final localContext = context;

    showDialog(
      context: localContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Date'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableDates.length,
              itemBuilder: (context, index) {
                DateTime date = availableDates[index];
                return ListTile(
                  title: Text(DateFormat('yyyy-MM-dd').format(date)),
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                    Navigator.of(context).pop();

                    // Show confirmation dialog to book
                    if (mounted) {
                      showDialog(
                        context: localContext,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Booking'),
                            content: Text(
                              'Do you want to book a session with ${tutorData['firstName']} ${tutorData['lastName']} on ${DateFormat('yyyy-MM-dd').format(selectedDate!)}?',
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Book'),
                                onPressed: () async {
                                  Navigator.of(context).pop(); // Close the dialog

                                  String message;
                                  try {
                                    message = await _bookSession(tutorData);
                                  } catch (errorMessage) {
                                    message = errorMessage.toString();
                                  }

                                  if (mounted) {
                                    ScaffoldMessenger.of(localContext).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                  var tutorData = availableTutors[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(
                        '${tutorData['firstName']} ${tutorData['lastName']} - ${tutorData['matchedSubject']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Proficiency: ${tutorData['proficiency']}',
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        _showBookingDates(context, tutorData);
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
