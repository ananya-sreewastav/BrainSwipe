import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Tut extends StatelessWidget {
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
    );
    }
}
