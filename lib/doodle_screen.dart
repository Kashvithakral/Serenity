import 'package:flutter/material.dart';

class DoodleScreen extends StatelessWidget {
  const DoodleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doodle'),
      ),
      body: const Center(
        child: Text('Doodle Pad'),
      ),
    );
  }
}
