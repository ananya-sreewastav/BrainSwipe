import 'package:brainswipe/create.dart';
import 'package:brainswipe/tutor_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'user.dart';
import 'planner.dart';
import 'swipe_page.dart';
import 'timetable_page.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey[900] : Color(0xFF064A58), // Adjusted for dark mode
        title: Text(
          'BrainSwipe',
          style: GoogleFonts.playfairDisplay(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            size: 34,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserPage()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.grey[850]!]
                : [Color(0xFFF0FFFF), Color(0xFF003366)], // Adjusted for dark mode
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Section1(),
              SizedBox(height: 16),
              Section2(),
              SizedBox(height: 16),
              Section3(),
              SizedBox(height: 16),
              Section4(),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonSectionContainer extends StatelessWidget {
  final Widget child;

  CommonSectionContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}

class Section1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CommonSectionContainer(
      child: Column(
        children: [
          Text(
            'WANT TO MAKE STUDYING INTERESTING?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'then use our feature and connect with your peers',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Create()),
              );
            },
            icon: Icon(Icons.school, size: 30),
            label: Text(
              'Click Here',
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class Section2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CommonSectionContainer(
      child: Column(
        children: [
          Text(
            'HAVE A LOT ON YOUR PLATE BUT DON\'T KNOW HOW TO REMEMBER?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'then Plan Ahead',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlannerPage()),
              );
            },
            icon: Icon(Icons.calendar_today, size: 30),
            label: Text(
              'Click Here',
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class Section3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CommonSectionContainer(
      child: Column(
        children: [
          Text(
            'TIRED BY MAKING TIMETABLES? (PLUS YOU DON\'T EVEN STICK TO IT)',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'then help us generate a personalized timetable',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimetablePage()),
              );
            },
            icon: Icon(Icons.schedule, size: 30),
            label: Text(
              'Click Here',
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class Section4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return CommonSectionContainer(
      child: Column(
        children: [
          Text(
            'NEED SOME PERSONALIZED HELP',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'then use our feature and connect with your peers',
            style: GoogleFonts.openSans(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TutorPage()),
              );
            },
            icon: Icon(Icons.help, size: 30),
            label: Text(
              'Click Here',
              style: GoogleFonts.openSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
