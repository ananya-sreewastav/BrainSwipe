import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDcNdhnAqX-7YTTdVm3xnDh4eTtDGk5P8w",
        appId: "1:746344704147:android:7ad3fb9242a21133ae4566",
        messagingSenderId: "746344704147",
        projectId: "brainswipe-test",
        storageBucket: "brainswipe-test.appspot.com",
      ),
    ); // Initialize Firebase
    print("Success connected to Firebase");
  } catch (e) {
    print("Error: $e");
  }
  runApp(MyApp()); // Run the app
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
