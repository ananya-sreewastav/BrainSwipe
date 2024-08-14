import 'package:google_fonts/google_fonts.dart'; // Ensure this is the correct package
import 'package:flutter/material.dart';

class CongratulationsPage extends StatefulWidget {
  @override
  _CongratulationsPageState createState() => _CongratulationsPageState();
}

class _CongratulationsPageState extends State<CongratulationsPage> {
  // Add a variable to track whether the card has been scratched
  bool isScratched = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF191970),
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: isDarkMode ? Colors.white : Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20), // Add space below the AppBar
            Text(
              'Congratulations!',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.yellow : Colors.blueAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40), // Add space above the scratch card
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Revealed content
                    Text(
                      '50 Rs coupon for a meal at Mingos Cafeteria',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.yellow : Colors.green[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Scratchable layer
                    if (!isScratched)
                      GestureDetector(
                        onPanUpdate: (details) {
                          // Implement scratch logic here
                          setState(() {
                            isScratched = true; // Reveal the content after initial scratch
                          });
                        },
                        child: Container(
                          width: 350, // Increase the width
                          height: 250, // Increase the height
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                isDarkMode
                                    ? Colors.deepPurple[800]!
                                    : Colors.orangeAccent[400]!,
                                isDarkMode
                                    ? Colors.deepPurple[400]!
                                    : Colors.orangeAccent[200]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20), // Larger border radius
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Scratch to Reveal',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 28, // Increase font size
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
