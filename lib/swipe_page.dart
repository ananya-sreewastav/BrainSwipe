import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  int currentIndex = 0;
  String swipeDirection = '';

  final List<Map<String, String>> studyGroups = [
    {
      'name': 'Group 1',
      'image': 'assets/img.png',
      'venue': 'Library Room A',
      'date': 'Aug 15, 2024'
    },
    {
      'name': 'Group 2',
      'image': 'assets/img_1.png',
      'venue': 'Cafe Study',
      'date': 'Aug 16, 2024'
    },
    {
      'name': 'Group 3',
      'image': 'assets/img_2.png',
      'venue': 'Community Hall',
      'date': 'Aug 17, 2024'
    },
  ];

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      setState(() {
        swipeDirection = 'Interested';
        if (currentIndex < studyGroups.length - 1) {
          currentIndex++;
        }
      });
    } else if (details.primaryVelocity! < 0) {
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
      body: GestureDetector(
        onHorizontalDragEnd: _onHorizontalDrag,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ...List.generate(studyGroups.length, (index) {
              return _buildStudyGroupCard(
                name: studyGroups[index]['name']!,
                image: studyGroups[index]['image']!,
                venue: studyGroups[index]['venue']!,
                date: studyGroups[index]['date']!,
                isVisible: index == currentIndex,
              );
            }),
            if (swipeDirection.isNotEmpty)
              Positioned(
                top: 100,
                child: Text(
                  swipeDirection,
                  style: GoogleFonts.roboto(
                    color: Colors.black,
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
    required String image,
    required String venue,
    required String date,
    required bool isVisible,
  }) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      bottom: isVisible ? 100 : -300,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 300),
        opacity: isVisible ? 1.0 : 0.0,
        child: Container(
          width: 300,
          height: 450,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Venue: $venue',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Date: $date',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
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
