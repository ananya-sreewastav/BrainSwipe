import 'package:flutter/material.dart';

class SwipePage extends StatefulWidget {
  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {

  String swipeDirection = 'Swipe left or right';

  void _onHorizontalDrag(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      setState(() {
        swipeDirection = 'Interested';
      });
    } else if (details.primaryVelocity! < 0) {
      setState(() {
        swipeDirection = 'Not interested';
      });
    }
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

      ),
      body: GestureDetector(
        onHorizontalDragEnd: _onHorizontalDrag,
        child: Container(
          color: Colors.blueGrey,
          alignment: Alignment.center,
          child: Text(
            swipeDirection,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
