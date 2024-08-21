import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subject {
  String name;
  int hoursPerDay;

  Subject(this.name, this.hoursPerDay);
}

Map<String, List<String>> generateTimetable(List<Subject> subjects) {
  Map<String, List<String>> timetable = {
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
    'Sunday': [],
  };

  subjects.forEach((subject) {
    int hoursRemaining = subject.hoursPerDay;
    timetable.forEach((day, slots) {
      if (hoursRemaining > 0) {
        slots.add(subject.name);
        hoursRemaining--;
      }
    });
  });

  return timetable;
}

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final List<Subject> _subjects = [];
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  Map<String, List<String>> _timetable = {};

  void _addSubject() {
    final String subjectName = _subjectController.text;
    final int hoursPerDay = int.tryParse(_hoursController.text) ?? 0;

    if (subjectName.isNotEmpty && hoursPerDay > 0) {
      setState(() {
        _subjects.add(Subject(subjectName, hoursPerDay));
      });

      _subjectController.clear();
      _hoursController.clear();
    }
  }

  void _generateTimetable() {
    setState(() {
      _timetable = generateTimetable(_subjects);
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
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Subjects',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(
                labelText: 'Subject Name',
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(
                labelText: 'Hours Per Day',
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
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
              child: Text('Add Subject'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[800] : Color(0xFF191970),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateTimetable,
              child: Text('Generate Timetable'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.grey[800] : Color(0xFF191970),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _timetable.keys.length,
                itemBuilder: (context, index) {
                  String day = _timetable.keys.elementAt(index);
                  List<String> subjects = _timetable[day] ?? [];

                  return Card(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: ListTile(
                      title: Text(
                        day,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        subjects.join(', '),
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _hoursController.dispose();
    super.dispose();
  }
}
