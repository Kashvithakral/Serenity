import 'package:flutter/material.dart';
import 'positive_word_hunt.dart';

class WordHuntScreen extends StatelessWidget {
  const WordHuntScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Hunt'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PositiveWordHunt()),
            );
          },
          child: const Text('Play Positive Word Hunt'),
        ),
      ),
    );
  }
}
