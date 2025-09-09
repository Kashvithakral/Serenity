import 'package:flutter/material.dart';

class PositiveWordHunt extends StatefulWidget {
  @override
  _PositiveWordHuntState createState() => _PositiveWordHuntState();
}

class _PositiveWordHuntState extends State<PositiveWordHunt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Positive Word Hunt'),
      ),
      body: Center(
        child: Text(
          'Positive Word Hunt - Coming Soon!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
