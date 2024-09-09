import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'cart_page.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  int currentIndex = 0;
  String swipeDirection = '';
  List<Map<String, String>> interestedGroups = [];
  List<Map<String, String>> studyGroups = [];

  @override
  void initState() {
    super.initState();
    fetchStudyGroups();
  }

  Future<void> fetchStudyGroups() async {
    // Fetch study groups from Firestore
    CollectionReference groups = FirebaseFirestore.instance.collection('studyGroups');
    QuerySnapshot snapshot = await groups.get();

    List<Map<String, String>> fetchedGroups = [];
    for (var doc in snapshot.docs) {
      Map<String, String> groupData = {
        'name': doc['name'],
        'venue': doc['venue'],
        'date': doc['date'],
      };

      fetchedGroups.add(groupData);
    }

    setState(() {
      studyGroups = fetchedGroups;
    });
  }

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity! > 0) { // Swipe right
      setState(() {
        swipeDirection = 'Interested';
        interestedGroups.add(studyGroups[currentIndex]); // Store interested group
        if (currentIndex < studyGroups.length - 1) {
          currentIndex++;
        }
      });
    } else if (details.primaryVelocity! < 0) { // Swipe left
      setState(() {
        swipeDirection = 'Not interested';
        if (currentIndex < studyGroups.length - 1) {
          currentIndex++;
        }
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        swipeDirection = '';
      });
    });
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
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: interestedGroups),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: studyGroups.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
        onHorizontalDragEnd: _onHorizontalDrag,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(studyGroups.length, (index) {
              return _buildStudyGroupCard(
                name: studyGroups[index]['name']!,
                venue: studyGroups[index]['venue']!,
                date: studyGroups[index]['date']!,
                isVisible: index == currentIndex,
                isDarkMode: isDarkMode,
              );
            }),
            if (swipeDirection.isNotEmpty)
              Positioned(
                top: 100,
                child: Text(
                  swipeDirection,
                  style: GoogleFonts.roboto(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyGroupCard({
    required String name,
    required String venue,
    required String date,
    required bool isVisible,
    required bool isDarkMode,
  }) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: isVisible ? 100 : -300,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.white24 : Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.playfairDisplay(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Venue: $venue',
                style: GoogleFonts.roboto(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Date: $date',
                style: GoogleFonts.roboto(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
