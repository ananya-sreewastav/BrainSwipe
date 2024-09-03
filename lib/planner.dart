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

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _loadEvents() async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    try {
      final snapshot = await eventsCollection.get();
      final eventsMap = <DateTime, List<String>>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final eventDate = (data['eventDate'] as Timestamp).toDate();
        final eventDescription = data['eventDescription'] as String;

        final normalizedDate = _normalizeDate(eventDate);

        if (!eventsMap.containsKey(normalizedDate)) {
          eventsMap[normalizedDate] = [];
        }
        eventsMap[normalizedDate]?.add(eventDescription);
      }

      setState(() {
        _events = eventsMap;
        print("Events loaded: $_events");
      });
    } catch (e) {
      print('Error loading events: $e');
    }
  }

  Future<void> _saveEvent(String eventDescription) async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    try {
      await eventsCollection.add({
        'eventDate': Timestamp.fromDate(_normalizeDate(_selectedDay)),
        'eventDescription': eventDescription,
      });

      setState(() {
        final normalizedDate = _normalizeDate(_selectedDay);
        if (_events[normalizedDate] != null) {
          _events[normalizedDate]?.add(eventDescription);
        } else {
          _events[normalizedDate] = [eventDescription];
        }
        _eventController.clear();
        print("Event saved: $_events");
      });
    } catch (e) {
      print('Error saving event: $e');
    }
  }

  Future<void> _deleteEvent(int index) async {
    if (_currentUser == null) return;

    final userEmail = _currentUser!.email;
    if (userEmail == null) return;

    final eventsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('events');

    try {
      final querySnapshot = await eventsCollection
          .where('eventDate', isEqualTo: Timestamp.fromDate(_normalizeDate(_selectedDay)))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docToDelete = querySnapshot.docs[index];
        await eventsCollection.doc(docToDelete.id).delete();

        setState(() {
          final normalizedDate = _normalizeDate(_selectedDay);
          _events[normalizedDate]?.removeAt(index);
          if (_events[normalizedDate]?.isEmpty ?? true) {
            _events.remove(normalizedDate);
          }
          print("Event deleted: $_events");
        });
      }
    } catch (e) {
      print('Error deleting event: $e');
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

    try {
      final querySnapshot = await eventsCollection
          .where('eventDate', isEqualTo: Timestamp.fromDate(_normalizeDate(_selectedDay)))
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docToUpdate = querySnapshot.docs[index];
        await eventsCollection.doc(docToUpdate.id).update({
          'eventDescription': newEvent,
        });

        setState(() {
          final normalizedDate = _normalizeDate(_selectedDay);
          _events[normalizedDate]?[index] = newEvent;
          print("Event edited: $_events");
        });
      }
    } catch (e) {
      print('Error editing event: $e');
    }
  }

  void _showEditDialog(int index) {
    TextEditingController _editController = TextEditingController();
    _editController.text = _events[_normalizeDate(_selectedDay)]?[index] ?? '';

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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_normalizeDate(_selectedDay), _normalizeDate(day));
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = _normalizeDate(selectedDay);
                _focusedDay = focusedDay;

                if (_selectedDay.isBefore(_normalizeDate(DateTime.now()))) {
                  // Show a SnackBar if trying to select a past date
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot add events to past dates.'),
                    ),
                  );
                }

                print("Selected Day: $_selectedDay");
                print("Events on selected day: ${_events[_normalizeDate(_selectedDay)] ?? []}");
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
            eventLoader: (day) {
              final normalizedDate = _normalizeDate(day);
              return _events[normalizedDate] ?? [];
            },
          ),
          ...(_events[_normalizeDate(_selectedDay)] ?? []).asMap().entries.map((entry) {
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
              if (_eventController.text.isEmpty ||
                  _normalizeDate(_selectedDay).isBefore(_normalizeDate(DateTime.now()))) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter an event and select a valid date.'),
                  ),
                );
                return;
              }
              _saveEvent(_eventController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.grey[800] : Color(0xFF052659),
            ),
            child: Text('Add Event'),
          ),
        ],
      ),
    );
  }
}
