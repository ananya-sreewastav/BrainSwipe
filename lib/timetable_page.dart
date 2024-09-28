import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subject {
  String name;
  int hoursPerSubject; // Number of hours allocated to the subject

  Subject(this.name, this.hoursPerSubject);
}

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<Subject> _subjects = [];
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _maxHoursController = TextEditingController();
  Map<String, List<String>> _timetable = {};
  int? _maxHoursPerDay;

  // Set the maximum hours per day for study
  void _setMaxHoursPerDay() {
    final int maxHours = int.tryParse(_maxHoursController.text) ?? 0;

    if (maxHours > 0) {
      setState(() {
        _maxHoursPerDay = maxHours;
      });
      _maxHoursController.clear();
    }
  }

  // Add a new subject
  void _addSubject() {
    final String subjectName = _subjectController.text;
    final int hoursPerSubject = int.tryParse(_hoursController.text) ?? 0;

    if (subjectName.isNotEmpty && hoursPerSubject > 0) {
      setState(() {
        _subjects.add(Subject(subjectName, hoursPerSubject));
      });

      _subjectController.clear();
      _hoursController.clear();
    }
  }

  // Generate the timetable
  void _generateTimetable() {
    if (_maxHoursPerDay != null && _maxHoursPerDay! > 0) {
      setState(() {
        _timetable = generateTimetable(_subjects, _maxHoursPerDay!);
      });
    }
  }

  // Show a popup if the subject needs to be pushed to the next day
  void _showPushToNextDayPopup(BuildContext context, String subjectName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Subject Exceeds Maximum Hours"),
          content: Text(
              "The subject '$subjectName' exceeds the daily limit. It will be pushed to the next day."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to generate the timetable
  Map<String, List<String>> generateTimetable(
      List<Subject> subjects, int maxHoursPerDay) {
    Map<String, List<String>> timetable = {
      'Monday': [],
      'Tuesday': [],
      'Wednesday': [],
      'Thursday': [],
      'Friday': [],
      'Saturday': [],
      'Sunday': [],
    };

    int currentDayIndex = 0;
    int currentDayHours = 0;
    List<String> days = timetable.keys.toList();

    // Loop through subjects and distribute them across the days
    for (var subject in subjects) {
      while (subject.hoursPerSubject > 0) {
        String currentDay = days[currentDayIndex];

        // Check if adding this subject exceeds the max hours for the day
        if (currentDayHours + subject.hoursPerSubject <= maxHoursPerDay) {
          // Add subject to the day
          timetable[currentDay]!
              .add('${subject.name} (${subject.hoursPerSubject} hrs)');
          currentDayHours += subject.hoursPerSubject;
          subject.hoursPerSubject = 0; // All hours allocated
        } else {
          // Determine how many hours can be added to the current day
          int remainingHours = maxHoursPerDay - currentDayHours;

          if (remainingHours > 0) {
            timetable[currentDay]!
                .add('${subject.name} (${remainingHours} hrs)');
            subject.hoursPerSubject -= remainingHours;
            currentDayHours = maxHoursPerDay; // Set the day to max
          }

          // Move to the next day
          currentDayIndex = (currentDayIndex + 1) % days.length;
          currentDayHours = 0;

          // Show popup if the subject needs to be pushed to the next day
          _showPushToNextDayPopup(context, subject.name);
        }
      }
    }

    return timetable;
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
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Maximum Hours Per Day',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _maxHoursController,
              decoration: InputDecoration(
                labelText: 'Max Hours Per Day',
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _setMaxHoursPerDay,
              child: Text(
                'Set Max Hours',
                style: TextStyle(color: Colors.white), // Bright text color
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isDarkMode ? Colors.grey[800] : Color(0xFF191970),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Add Subjects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(
                labelText: 'Hours Per Subject',
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text(
                'Add Subject',
                style: TextStyle(color: Colors.white), // Bright text color
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isDarkMode ? Colors.grey[800] : Color(0xFF191970),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateTimetable,
              child: Text(
                'Generate Timetable',
                style: TextStyle(color: Colors.white), // Bright text color
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                isDarkMode ? Colors.grey[800] : Color(0xFF191970),
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 24),
            if (_timetable.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _timetable.length,
                  itemBuilder: (context, index) {
                    String day = _timetable.keys.elementAt(index);
                    List<String> subjects = _timetable[day]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        ...subjects.map((subject) => Text(
                          subject,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.black87,
                          ),
                        )),
                        SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}