import 'package:flutter/material.dart';

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
    'Saturday':[],

   
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Text(
          'BrainSwipe',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            size: 34,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);  // Go back to previous page
          },
        ),
      ),
      backgroundColor: Colors.white,
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
                color: Colors.black,
              ),
            ),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: _hoursController,
              decoration: InputDecoration(labelText: 'Hours Per Day'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addSubject,
              child: Text('Add Subject'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateTimetable,
              child: Text('Generate Timetable'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _timetable.keys.length,
                itemBuilder: (context, index) {
                  String day = _timetable.keys.elementAt(index);
                  List<String> subjects = _timetable[day] ?? [];

                  return Card(
                    child: ListTile(
                      title: Text(day),
                      subtitle: Text(subjects.join(', ')),
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
