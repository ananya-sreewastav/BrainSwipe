import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF191970),
          title: Text(
            'BrainSwipe',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white
    );
  }
}