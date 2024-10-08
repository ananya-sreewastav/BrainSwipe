import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'cart_page.dart'; // Import the cart page

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<Map<String, dynamic>> _interestedGroups = []; // List to store swiped right groups

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
            likeAction: () {
              _showSnackBar("Interested");
              _interestedGroups.add(data); // Add to interested list when swiped right
            },
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
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Navigate to CartPage when cart icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(interestedGroups: _interestedGroups),
                ),
              );
            },
          ),
        ],
      ),
      // Update the background to be white
      backgroundColor: Colors.white,
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
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
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
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Color(0xFF00BFA5), Color(0xFF4DD0E1)] // Teal and Cyan for Dark Mode
                : [Color(0xFF9C27B0), Color(0xFFE91E63)], // Purple and Pink for Light Mode
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          elevation: 15,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          color: Colors.transparent, // Transparent to show the gradient background
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data['subject'] ?? 'No subject',
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Department: ${data['department'] ?? 'No department'}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Date: ${data['date'] ?? 'No date'}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Time: ${data['time'] ?? 'No time'}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Location: ${data['location'] ?? 'No location'}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Members: ${data['members'] ?? 'No members'}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
