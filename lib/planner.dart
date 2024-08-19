import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlannerPage extends StatefulWidget {
  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {};

  TextEditingController _eventController = TextEditingController();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    final snapshot = await eventsCollection.get();
    final eventsMap = <DateTime, List<String>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final eventDate = (data['eventDate'] as Timestamp).toDate();
      final eventDescription = data['eventDescription'] as String;

      if (!eventsMap.containsKey(eventDate)) {
        eventsMap[eventDate] = [];
      }
      eventsMap[eventDate]?.add(eventDescription);
    }

    setState(() {
      _events = eventsMap;
    });
  }

  Future<void> _saveEvent(String eventDescription) async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    await eventsCollection.add({
      'eventDate': _selectedDay,
      'eventDescription': eventDescription,
    });

    setState(() {
      if (_events[_selectedDay] != null) {
        _events[_selectedDay]?.add(eventDescription);
      } else {
        _events[_selectedDay] = [eventDescription];
      }
      _eventController.clear();
    });
  }

  Future<void> _deleteEvent(int index) async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    final querySnapshot = await eventsCollection
        .where('eventDate', isEqualTo: _selectedDay)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docToDelete = querySnapshot.docs[index];
      await eventsCollection.doc(docToDelete.id).delete();

      setState(() {
        _events[_selectedDay]?.removeAt(index);
      });
    }
  }

  void _editEvent(int index, String newEvent) async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    final querySnapshot = await eventsCollection
        .where('eventDate', isEqualTo: _selectedDay)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docToUpdate = querySnapshot.docs[index];
      await eventsCollection.doc(docToUpdate.id).update({
        'eventDescription': newEvent,
      });

      setState(() {
        _events[_selectedDay]?[index] = newEvent;
      });
    }
  }

  void _showEditDialog(int index) {
    TextEditingController _editController = TextEditingController();
    _editController.text = _events[_selectedDay]?[index] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          title: Text('Edit Event'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(
              labelText: 'Event',
              border: OutlineInputBorder(),
              fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
              filled: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _editEvent(index, _editController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

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
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (selectedDay.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("You can't select a past date."),
                  ),
                );
                return;
              }
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            enabledDayPredicate: (day) {
              return !day.isBefore(DateTime.now().subtract(Duration(days: 1)));
            },
            eventLoader: (day) {
              if (_events.containsKey(day)) {
                return _events[day]!;
              } else {
                return [];
              }
            },
          ),
          ...(_events[_selectedDay] ?? []).asMap().entries.map((entry) {
            int index = entry.key;
            String event = entry.value;
            return ListTile(
              title: Text(
                event,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: () => _showEditDialog(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: isDarkMode ? Colors.white : Colors.black),
                    onPressed: () => _deleteEvent(index),
                  ),
                ],
              ),
            );
          }).toList(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _eventController,
              decoration: InputDecoration(
                labelText: 'Add Event',
                border: OutlineInputBorder(),
                fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                filled: true,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_eventController.text.isEmpty) {
                return;
              }
              _saveEvent(_eventController.text);
            },
            child: Text(
              'Add Event',
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.grey[700] : Color(0xFF191970),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
