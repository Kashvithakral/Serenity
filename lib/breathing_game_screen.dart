import 'package:flutter/material.dart';

class BreathingGameScreen extends StatefulWidget {
  const BreathingGameScreen({Key? key}) : super(key: key);

  @override
  _BreathingGameScreenState createState() => _BreathingGameScreenState();
}

class _BreathingGameScreenState extends State<BreathingGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Game'),
      ),
      body: const Center(
        child: Text('Breathing Game Content'),
      ),
    );
  }
}
