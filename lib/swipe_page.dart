import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];

  @override
  void initState() {
    super.initState();
    _fetchStudyGroups();
  }

  void _fetchStudyGroups() {
    FirebaseFirestore.instance.collection('study_groups').snapshots().listen((snapshot) {
      setState(() {
        _swipeItems = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return SwipeItem(
            content: StudyGroupCard(data),
            likeAction: () => _showSnackBar("Interested"),
            nopeAction: () => _showSnackBar("Not Interested"),
          );
        }).toList();

        _matchEngine = MatchEngine(swipeItems: _swipeItems);
      });
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: _swipeItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 30),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: SwipeCards(
                    matchEngine: _matchEngine,
                    onStackFinished: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No more study groups')),
                      );
                    },
                    itemBuilder: (context, index) {
                      return _swipeItems[index].content;
                    },
                    upSwipeAllowed: false,
                    fillSpace: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
          // Instruction text overlay
          Positioned(
            top: 10, // Position at the top
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7), // Semi-transparent background
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Swipe left if you are not interested, swipe right if you are interested',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudyGroupCard extends StatelessWidget {
  final Map<String, dynamic> data;

  StudyGroupCard(this.data);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Center(
      // Wrap card inside a Container that takes 70% of height and 80% of width
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,  // 80% of the screen width
        height: MediaQuery.of(context).size.height * 0.70, // 70% of the screen height
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0), // Centered with no extra padding
          elevation: 10, // Elevation for prominent card shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // More pronounced rounded corners
          ),
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(30), // Increased padding for more spacing inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['subject'] ?? 'No subject',
                  style: GoogleFonts.lato(
                    fontSize: 24, // Larger text for the subject
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 20), // Increased spacing between subject and details
                Text('Department: ${data['department'] ?? 'No department'}'),
                Text('Date: ${data['date'] ?? 'No date'}'),
                Text('Time: ${data['time'] ?? 'No time'}'),
                Text('Location: ${data['location'] ?? 'No location'}'),
                Text('Members: ${data['members'] ?? 'No members'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
