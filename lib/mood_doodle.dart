import 'package:flutter/material.dart';

class MoodDoodle extends StatefulWidget {
  @override
  _MoodDoodleState createState() => _MoodDoodleState();
}

class _MoodDoodleState extends State<MoodDoodle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Doodle'),
      ),
      body: Center(
        child: Text(
          'Mood Doodle - Under Development',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
