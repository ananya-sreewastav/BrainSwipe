import 'package:flutter/material.dart';

class TutorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF191970),
        title: Text(
          'BrainSwipe',
          style: TextStyle(
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
                color: Colors.lightBlue[900],
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
                    SizedBox(width: MediaQuery.of(context).size.width / 2), // Space for the next square
                  ],
                ),
                SizedBox(height: 20), // Space between the two rows
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 2), // Space for the previous square
                    Expanded(
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
