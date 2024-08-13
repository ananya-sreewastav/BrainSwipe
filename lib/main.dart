import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';
import 'sign.dart';
import 'first.dart';
import 'user.dart';
import 'planner.dart';
import 'swipe_page.dart';
import 'timetable_page.dart';
import 'tutor_page.dart';
import 'tut.dart';
import 'create.dart';
import 'form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainSwipe App',
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(toggleDarkMode: _toggleDarkMode),
        '/sign': (context) => SignPage(),
        '/first': (context) => FirstPage(),
        '/user': (context) => UserPage(),
        '/planner': (context) => PlannerPage(),
        '/swipe': (context) => SwipePage(),
        '/tutor': (context) => TutorPage(),
        '/timetable': (context) => TimetablePage(),
        '/tut': (context) => Tut(),
      },
    );
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
    );
  }
}
