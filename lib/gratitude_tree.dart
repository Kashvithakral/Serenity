import 'package:flutter/material.dart';

class GratitudeTree extends StatefulWidget {
  @override
  _GratitudeTreeState createState() => _GratitudeTreeState();
}

class _GratitudeTreeState extends State<GratitudeTree> {
  List<String> gratitudeEntries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude Tree'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Gratitude Tree',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter something you are grateful for',
              ),
              onSubmitted: (text) {
                setState(() {
                  gratitudeEntries.add(text);
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add gentle reminder logic here
            },
            child: const Text('Add Reminder'),
          ),
        ],
      ),
    );
  }
}
