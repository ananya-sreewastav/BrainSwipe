import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> upcomingStudyGroups = [];
  List<Map<String, dynamic>> upcomingEvents = [];
  List<Map<String, dynamic>> upcomingTutoringSessions = [];

  @override
  void initState() {
    super.initState();
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    // Fetch all data in parallel
    fetchUpcomingStudyGroups(userEmail);
    fetchUpcomingEvents(userEmail);
    fetchUpcomingTutoringSessions(userEmail);
  }

  // Fetch study groups
  Future<void> fetchUpcomingStudyGroups(String userEmail) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('registered_study_groups')
          .get();

      List<Map<String, dynamic>> studyGroups = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime groupDate = DateTime.parse(data['date']);
        if (groupDate.isAfter(DateTime.now())) {
          studyGroups.add({
            'subject': data['subject'],
            'date': groupDate,
            'time': data['time'],
          });
        }
      });

      setState(() {
        upcomingStudyGroups = studyGroups;
      });
    } catch (e) {
      print('Error fetching study groups: $e');
    }
  }

  // Fetch events from 'events' subcollection
  Future<void> fetchUpcomingEvents(String userEmail) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('events')
          .get();

      List<Map<String, dynamic>> events = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime eventDate = (data['eventDate'] as Timestamp).toDate();
        if (eventDate.isAfter(DateTime.now())) {
          events.add({
            'eventDescription': data['eventDescription'],
            'eventDate': eventDate,
          });
        }
      });

      setState(() {
        upcomingEvents = events;
      });
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  // Fetch upcoming tutoring sessions
  Future<void> fetchUpcomingTutoringSessions(String userEmail) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('registered_tutee')
          .where(FieldPath.documentId, isEqualTo: userEmail) // Check if the user is the tutee
          .get();

      List<Map<String, dynamic>> sessions = [];
      snapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime sessionDate = DateTime.parse(data['dateBooked']);

        if (sessionDate.isAfter(DateTime.now())) {
          sessions.add({
            'tutorName': data['tutorName'],
            'subject': data['subject'],
            'dateBooked': sessionDate,
          });
        }
      });

      setState(() {
        upcomingTutoringSessions = sessions;
      });
    } catch (e) {
      print('Error fetching tutoring sessions: $e');
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming Study Groups:', style: sectionHeaderStyle(isDarkMode)),
              if (upcomingStudyGroups.isNotEmpty)
                ...upcomingStudyGroups.map((group) => ListTile(
                  title: Text('Study Group: ${group['subject']}'),
                  subtitle: Text('Date: ${DateFormat('yyyy-MM-dd').format(group['date'])}, Time: ${group['time']}'),
                )).toList()
              else
                Text('No upcoming study groups.', style: sectionTextStyle(isDarkMode)),

              SizedBox(height: 20),

              Text('Upcoming Events in the Calendar:', style: sectionHeaderStyle(isDarkMode)),
              if (upcomingEvents.isNotEmpty)
                ...upcomingEvents.map((event) => ListTile(
                  title: Text('Event: ${event['eventDescription']}'),
                  subtitle: Text('Date: ${DateFormat('yyyy-MM-dd').format(event['eventDate'])}'),
                )).toList()
              else
                Text('No upcoming events in the calendar.', style: sectionTextStyle(isDarkMode)),

              SizedBox(height: 20),

              Text('Upcoming Tutoring Sessions:', style: sectionHeaderStyle(isDarkMode)),
              if (upcomingTutoringSessions.isNotEmpty)
                ...upcomingTutoringSessions.map((session) => ListTile(
                  title: Text('Tutoring Session: ${session['subject']}'),
                  subtitle: Text('Tutor: ${session['tutorName']}, Date: ${DateFormat('yyyy-MM-dd').format(session['dateBooked'])}'),
                )).toList()
              else
                Text('No upcoming tutoring sessions.', style: sectionTextStyle(isDarkMode)),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle sectionHeaderStyle(bool isDarkMode) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }

  TextStyle sectionTextStyle(bool isDarkMode) {
    return TextStyle(
      fontSize: 16,
      color: isDarkMode ? Colors.white : Colors.black,
    );
  }
}
