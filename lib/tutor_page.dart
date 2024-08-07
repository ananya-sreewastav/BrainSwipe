import 'package:flutter/material.dart';
import 'tut.dart';
import 'package:google_fonts/google_fonts.dart';
class TutorPage extends StatelessWidget {
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
      body: Column(
        children: [
          SizedBox(height: AppBar().preferredSize.height + 20), // Space below the AppBar
          Center(
            child: Text(
              'Choose Your Role',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20), // Space between the text and the squares
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Replace this with the navigation to your desired page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Tut()), // Replace TuteePage() with the page you want to navigate to
                          );
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          color: Colors.cyan.withOpacity(0.5),
                          child: Center(
                            child: Text(
                              'Tutor',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 2), // Space for the next square
                  ],
                ),
                SizedBox(height: 20), // Space between the two rows
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 2), // Space for the previous square
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Replace this with the navigation to your desired page

                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 3,
                          color: Colors.cyan.withOpacity(0.5),
                          child: Center(
                            child: Text(
                              'Tutee',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
